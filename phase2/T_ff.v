// T flipflop 
/*

| T | Next Q |
| - | ------ |
| 0 | Hold   |
| 1 | Toggle |

*/

module t_ff (
    input  wire clk,
    input  wire t,
    output reg  q
);

always @(posedge clk) begin
    if (t)
        q <= ~q;
    else
        q <= q;
end

// always @(posedge clk)
//     q <= t ? ~q : q;

endmodule


module tb_t_ff;

reg clk;
reg t;
wire q;

t_ff dut (
    .clk(clk),
    .t(t),
    .q(q)
);

always #5 clk = ~clk;

initial begin
    clk = 0;

    // Hold
    t = 0; #20;

    // Toggle every clock edge
    t = 1; #40;

    // Hold again
    t = 0; #20;

    $finish;
end

endmodule