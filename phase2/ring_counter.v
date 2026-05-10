/*

Ring Counter
A ring counter is:
a shift register
where last bit feeds back to first bit
Only ONE bit is high.


Start:
    0001
After clocks:
    0010
    0100
    1000
    0001
The 1 rotates around.

*/

module ring_counter (
    input clk,
    input rst,
    output reg [3:0] q
);

always @(posedge clk) begin
    if (rst)
        q <= 4'b0001;
    else
        q <= {q[2:0], q[3]};
end

endmodule


`timescale 1ns/1ps

module tb_ring;

reg clk, rst;
wire [3:0] q;

ring_counter dut(
    .clk(clk),
    .rst(rst),
    .q(q)
);

always #5 clk = ~clk;

initial begin
    clk = 0;
    rst = 1;

    #10 rst = 0;

    #100 $finish;
end

endmodule