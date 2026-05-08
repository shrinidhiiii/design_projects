// priority encoder

/*
A priority encoder is an encoder that gives priority to the highest-priority active input when multiple inputs are 1.

Normal encoders assume:
only one input is active at a time.
But real hardware often violates that assumption.
Priority encoders solve this problem.

4-2 encoder
| Inputs | Output |
| ------ | ------ |
| 0001   | 00     |
| 0010   | 01     |
| 0100   | 10     |
| 1000   | 11     |

What if input is:
    1010
Two inputs are active.
Which output should it produce?
Undefined.

A priority encoder says:
“If multiple inputs are 1, choose the highest-priority one.”

get the highest priority input bit and treat others as dont cares
*/

// 4-2 priority encoder
module priority_encoder(
    input logic [3:0]in,
    output logic [1:0] out
);

always_comb begin
    casez(in)
    4'b1zzz : out = 3;
    4'b01zz : out = 2;
    4'b001z : out = 1;
    4'b0001 : out = 0;
    default : out = 0;

    endcase
end
endmodule 

module priority_encoder_tb;
    reg [3:0] in;
    wire [1:0] out;

    priority_encoder dut (.in(in), .out(out));

    initial begin
    in = 4'b0000; #10;
    $display("%0t\t%b\t%0d", $time, in, out);

    in = 4'b0001; #10;
    $display("%0t\t%b\t%0d", $time, in, out);

    in = 4'b0010; #10;
    $display("%0t\t%b\t%0d", $time, in, out);

    in = 4'b0011; #10;
    $display("%0t\t%b\t%0d", $time, in, out);

    in = 4'b0100; #10;
    $display("%0t\t%b\t%0d", $time, in, out);

    in = 4'b0110; #10;
    $display("%0t\t%b\t%0d", $time, in, out);

    in = 4'b1000; #10;
    $display("%0t\t%b\t%0d", $time, in, out);

    in = 4'b1111; #10;
    $display("%0t\t%b\t%0d", $time, in, out);

         $finish;

    end
endmodule


/*

There are three case statements:
case
casez
casex
They all look similar, but they treat x and z completely differently.

case (strict matching)
    No wildcards allowed
    x and z are treated as literal values

    case (in)
        4'b10xx: out = 1;  // ❌ NOT a pattern
    endcase
    This will NOT match patterns. It only matches exact bits.

| Input bit | Treated as             |
| --------- | ---------------------- |
| 0         | 0                      |
| 1         | 1                      |
| x         | x (must match exactly) |
| z         | z (must match exactly) |


casez (z = wildcard, safe version)
    z and ? are treated as don’t care
    x is treated as a real value (NOT wildcard)

    casez (in)
        4'b1???: out = 3;
        4'b01??: out = 2;
    endcase

? or z → ignored in comparison
x → still significant

| Symbol | Meaning in casez |
| ------ | ---------------- |
| 0      | must match 0     |
| 1      | must match 1     |
| z      | don’t care       |
| ?      | don’t care       |
| x      | must match x     |


casex (dangerous wildcard)
    x AND z are both treated as don’t care
    casex (in)
        4'b1xxx: out = 3;
    endcase

x = ignored
z = ignored
anything unknown becomes wildcard


Why casez is preferred over casex
    Because:
    x = unknown value (could be real bug)
    z = high impedance (intentional tri-state)
    So:
    casez → safer, preserves x visibility
    casex → hides simulation bugs

Synthesis tools:
ignore x anyway (treat as don't care)
but simulation must catch bugs
So casex can make simulation lie to you.


*/