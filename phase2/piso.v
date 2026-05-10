/*
PISO — Parallel In Serial Out
Load all bits together
Shift out one bit at a time

Load: 1101

Clock outputs:
1
1
0
1
*/

module piso (
    input clk,
    input rst,
    input load,
    input [3:0] pdata,
    output reg sout
);

reg [3:0] shift;

always @(posedge clk) begin
    if (rst)
        shift <= 4'b0000;

    else if (load)
        shift <= pdata;

    else begin
        sout <= shift[3];
        shift <= {shift[2:0], 1'b0};
    end
end

endmodule

`timescale 1ns/1ps

module tb_piso;

reg clk, rst, load;
reg [3:0] pdata;
wire sout;

piso dut(
    .clk(clk),
    .rst(rst),
    .load(load),
    .pdata(pdata),
    .sout(sout)
);

always #5 clk = ~clk;

initial begin
    clk = 0;
    rst = 1;
    load = 0;

    #10 rst = 0;

    pdata = 4'b1101;
    load = 1;

    #10 load = 0;

    #50 $finish;
end

endmodule