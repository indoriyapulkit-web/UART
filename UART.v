module UART(
input clk,rst,tx_start,rx,
input [7:0] data_in,
output tx,tx_busy,tx_done,rx_done,
output [7:0] data_out

);
    wire baud_tick;
    baud_generator bg1(clk,rst,baud_tick);
    uart_tx t1(baud_tick,clk,rst,tx_start,data_in,tx,tx_busy,tx_done);
    uart_rx r1(baud_tick,clk,rst,rx,data_out,rx_done);
endmodule
