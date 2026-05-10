// D Flip-Flop (Synchronous Reset)

//Reset is checked only on clock edge.

module dff_sync_reset (
    input  wire clk,
    input  wire rst,
    input  wire d,
    output reg  q
);

always @(posedge clk) begin
    if (rst)
        q <= 1'b0;
    else
        q <= d;
end

endmodule


module tb_dff_sync_reset;

reg clk;
reg rst;
reg d;
wire q;

dff_sync_reset dut (
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

    d = 1; #10;
    d = 0; #10;
    d = 1; #10;

    rst = 1; #10;
    rst = 0; #10;

    $finish;
end

endmodule