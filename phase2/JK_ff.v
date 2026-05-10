// JK flipflop 
/*
| J | K | Next Q |
| - | - | ------ |
| 0 | 0 | Hold   |
| 0 | 1 | Reset  |
| 1 | 0 | Set    |
| 1 | 1 | Toggle |

*/

module jk_ff (
    input  wire clk,
    input  wire j,
    input  wire k,
    output reg  q
);

always @(posedge clk) begin
    case ({j, k})
        2'b00: q <= q;     // Hold
        2'b01: q <= 1'b0;  // Reset
        2'b10: q <= 1'b1;  // Set
        2'b11: q <= ~q;    // Toggle
    endcase
end

endmodule


module tb_jk_ff;

reg clk;
reg j;
reg k;
wire q;

jk_ff dut (
    .clk(clk),
    .j(j),
    .k(k),
    .q(q)
);

always #5 clk = ~clk;

initial begin
    clk = 0;

    //
    // Hold
    //
    j = 0; k = 0; #10;

    //
    // Reset
    //
    j = 0; k = 1; #10;

    //
    // Set
    //
    j = 1; k = 0; #10;

    //
    // Toggle
    //
    j = 1; k = 1; #10;
    j = 1; k = 1; #10;

    $finish;
end

endmodule