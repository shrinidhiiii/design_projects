// D Flip-Flop (Asynchronous Reset)
//Reset happens immediately, without waiting for clock.

module dff_async_reset (
    input  wire clk,
    input  wire rst,
    input  wire d,
    output reg  q
);

always @(posedge clk or posedge rst) begin
    if (rst)
        q <= 1'b0;
    else
        q <= d;
end

endmodule


module tb_dff_async_reset;

reg clk;
reg rst;
reg d;
wire q;

dff_async_reset dut (
    .clk(clk),
    .rst(rst),
    .d(d),
    .q(q)
);

always #5 clk = ~clk;

initial begin
    clk = 0;
    rst = 0;
    d   = 0;

    d = 1; #10;
    d = 0; #10;

    
    // Async reset triggers immediately
    
    rst = 1; #3;
    rst = 0;

    d = 1; #10;

    $finish;
end

endmodule