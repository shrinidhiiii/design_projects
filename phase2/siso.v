// Shift register 

/*
A shift register stores bits and shifts them left/right every clock cycle.

a 4-bit register:
Before shift : 1011
After shift  : 0101

Different types depend on:
    how data enters
    how data exits
*/
/*

SISO - Serial In Serial Out
    Data enters 1 bit at a time
    Data comes out 1 bit at a time

    Din → [FF]→[FF]→[FF]→[FF] → Dout

Every clock: bits move one stage right

*/

module siso (
    input clk,
    input rst,
    input din,
    output reg dout
);

reg [3:0] shift;

always @(posedge clk) begin
    if (rst)
        shift <= 4'b0000;
    else begin
        shift <= {shift[2:0], din};
        dout <= shift[3];
    end
end

endmodule

`timescale 1ns/1ps

module tb_siso;

reg clk, rst, din;
wire dout;

siso dut(
    .clk(clk),
    .rst(rst),
    .din(din),
    .dout(dout)
);

always #5 clk = ~clk;

initial begin
    clk = 0;
    rst = 1;
    din = 0;

    #10 rst = 0;

    din = 1; #10;
    din = 0; #10;
    din = 1; #10;
    din = 1; #10;

    #50 $finish;
end

endmodule