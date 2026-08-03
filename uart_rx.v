module uart_rx(
    
    input  wire baud_tick,clk,
    input  wire rst,
    input  wire rx,
    output reg [7:0] data_out,
    output reg  rx_done
);

//////////////////////////////////////////////////
// State Encoding
//////////////////////////////////////////////////
localparam S0 = 4'd0,
           S1 = 4'd1,
           S2 = 4'd2,
           S3 = 4'd3,
           S4 = 4'd4,
           S5 = 4'd5,
           S6 = 4'd6,
           S7 = 4'd7,
           S8=4'd8,
           S9=4'd9;

//////////////////////////////////////////////////
// State Registers
//////////////////////////////////////////////////
reg [3:0] state, next_state;
reg [7:0] data;
integer i;
//////////////////////////////////////////////////
// 1. State Register
//////////////////////////////////////////////////
always @(posedge clk or posedge rst)
begin
    if(rst)
    begin
        state <= S0;
        data  <= 8'd0;
    end
    else if(baud_tick)
    begin
        state <= next_state;

        case(state)

            S1: data[0] <= rx;
            S2: data[1] <= rx;
            S3: data[2] <= rx;
            S4: data[3] <= rx;
            S5: data[4] <= rx;
            S6: data[5] <= rx;
            S7: data[6] <= rx;
            S8: data[7] <= rx;

            default: ;

        endcase
    end
end

//////////////////////////////////////////////////
// 2. Next-State Logic
//////////////////////////////////////////////////
always @(*) begin

    // Default assignment
    next_state = state;

    case (state)

        S0: begin
            if (!rx)
                next_state = S1;
            else
                next_state = S0;
        end

        S1: begin
                
                next_state = S2;

        end

        S2: begin
                
                next_state = S3;

        end

        S3: begin
                
                next_state = S4;

        end

        S4: begin
                
                next_state = S5;

        end

        S5: begin
                                
                next_state = S6;

        end

        S6: begin
                
                next_state = S7;

        end

        S7: begin
                
                next_state = S8;

        end
        S8:begin
        
        next_state=S9;
        end
        S9:begin
                next_state=S0;       
        end
        default: begin
            next_state = S0;
        end
        

    endcase

end

//////////////////////////////////////////////////
// 3. Output Logic
//////////////////////////////////////////////////
always @(*) begin

    // Default output
    rx_done=0;
    data_out=0;

    case (state)


        S9:begin
            if(rx)begin
                rx_done=rx;
                data_out=data;           
            end
        end
        default:begin
            rx_done=0;
            data_out=0;        
        end
    endcase

end  
endmodule


