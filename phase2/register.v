// N bit register 

module nbit_register #(
    parameter N = 8
)(
    input  wire         clk,
    input  wire         rst,
    input  wire [N-1:0] d,
    output reg  [N-1:0] q
);

always @(posedge clk) begin
    if (rst)
        q <= 0;
    else
        q <= d;
end

endmodule

module tb_nbit_register;

parameter N = 8;

reg clk;
reg rst;
reg [N-1:0] d;
wire [N-1:0] q;

nbit_register #(.N(N)) dut (
    .clk(clk),
    .rst(rst),
    .d(d),
    .q(q)
);

always #5 clk = ~clk;

initial begin
    clk = 0;
    rst = 1;
    d   = 0;

    #10;
    rst = 0;

    d = 8'hAA; #10;
    d = 8'h55; #10;
    d = 8'hF0; #10;

    rst = 1; #10;
    rst = 0;

    d = 8'h0F; #10;

    $finish;
end

endmodule