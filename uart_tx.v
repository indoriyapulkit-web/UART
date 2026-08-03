module uart_tx(

    input  wire baud_tick,
    input  wire clk,
    input  wire rst,
    input  wire tx_start,
    input  wire [7:0] data_in,

    output reg tx,
    output reg tx_busy,
    output reg tx_done
);

//////////////////////////////////////////////////
// State Encoding
//////////////////////////////////////////////////
localparam S0  = 4'd0,
           S1  = 4'd1,
           S2  = 4'd2,
           S3  = 4'd3,
           S4  = 4'd4,
           S5  = 4'd5,
           S6  = 4'd6,
           S7  = 4'd7,
           S8  = 4'd8,
           S9  = 4'd9,
           S10 = 4'd10;

//////////////////////////////////////////////////
// Registers
//////////////////////////////////////////////////
reg [3:0] state, next_state;
reg [7:0] data_in1;

//////////////////////////////////////////////////
// State Register
//////////////////////////////////////////////////
always @(posedge clk or posedge rst)
begin
    if(rst)
    begin
        state    <= S0;
        data_in1 <= 8'd0;
    end
    else
    begin
        state <= next_state;

        // Latch data once when transmission starts
        if(state == S0 && tx_start)
            data_in1 <= data_in;
    end
end

//////////////////////////////////////////////////
// Next-State Logic
//////////////////////////////////////////////////
always @(*)
begin

    next_state = state;

    case(state)

        // Idle
        S0:
        begin
            if(tx_start)
                next_state = S9;
        end

        // Start bit
        S9:
        begin
            if(baud_tick)
                next_state = S1;
        end

        // Data bit 0
        S1:
        begin
            if(baud_tick)
                next_state = S2;
        end

        // Data bit 1
        S2:
        begin
            if(baud_tick)
                next_state = S3;
        end

        // Data bit 2
        S3:
        begin
            if(baud_tick)
                next_state = S4;
        end

        // Data bit 3
        S4:
        begin
            if(baud_tick)
                next_state = S5;
        end

        // Data bit 4
        S5:
        begin
            if(baud_tick)
                next_state = S6;
        end

        // Data bit 5
        S6:
        begin
            if(baud_tick)
                next_state = S7;
        end

        // Data bit 6
        S7:
        begin
            if(baud_tick)
                next_state = S8;
        end

        // Data bit 7
        S8:
        begin
            if(baud_tick)
                next_state = S10;
        end

        // Stop bit
        S10:
        begin
            if(baud_tick)
                next_state = S0;
        end

        default:
            next_state = S0;

    endcase

end

//////////////////////////////////////////////////
// Output Logic
//////////////////////////////////////////////////
always @(*)
begin

    tx      = 1'b1;
    tx_busy = 1'b0;
    tx_done = 1'b0;

    case(state)

        S0:
        begin
            tx = 1'b1;
        end

        // Start bit
        S9:
        begin
            tx      = 1'b0;
            tx_busy = 1'b1;
        end

        S1:
        begin
            tx      = data_in1[0];
            tx_busy = 1'b1;
        end

        S2:
        begin
            tx      = data_in1[1];
            tx_busy = 1'b1;
        end

        S3:
        begin
            tx      = data_in1[2];
            tx_busy = 1'b1;
        end

        S4:
        begin
            tx      = data_in1[3];
            tx_busy = 1'b1;
        end

        S5:
        begin
            tx      = data_in1[4];
            tx_busy = 1'b1;
        end

        S6:
        begin
            tx      = data_in1[5];
            tx_busy = 1'b1;
        end

        S7:
        begin
            tx      = data_in1[6];
            tx_busy = 1'b1;
        end

        S8:
        begin
            tx      = data_in1[7];
            tx_busy = 1'b1;
        end

        // Stop bit
        S10:
        begin
            tx      = 1'b1;
            tx_busy = 1'b1;
            tx_done = 1'b1;
        end

    endcase

end

endmodule
