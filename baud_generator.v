module baud_generator(
input clk,rst,
output reg baud_tick
    );
    reg [13:0] count;

always @(posedge clk or posedge rst) begin
    if (rst) begin
        count <= 0;
        baud_tick <= 0;
    end
    else if (count == 10416) begin
        count <= 0;
        baud_tick <= 1;
    end
    else begin
        count <= count + 1;
        baud_tick <= 0;
    end
end
endmodule
