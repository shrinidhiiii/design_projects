// 2:1 mux 
`timescale 1ps/1ps

module mux2_1(
    input reg[3:0] a,
    input reg[3:0] b,
    input reg sel,
    output reg[3:0] out

);
assign out = sel ? a: b;
// if sel ==1, then out = a, else out = b;

endmodule 

module mux2_1tb;
reg[3:0] a_tb;
reg[3:0] b_tb;
reg sel_tb;
wire [3:0] out_tb;

mux2_1 dut (.a(a_tb),
            .b(b_tb),
            .sel(sel_tb),
            .out(out_tb));

initial begin 
    $dumpfile("waves.vcd");
    $dumpvars;

    $monitor("a is %d, b is %d, sel is %d, out is %d", a_tb, b_tb, sel_tb, out_tb);

    a_tb =0;
    b_tb = 0;
    sel_tb =0;

    #10;

    a_tb = 11;
    b_tb = 5;
    sel_tb = 1;

    #10;

    a_tb = 11;
    b_tb = 10;
    sel_tb = 0;

    #10;

    a_tb = 12;
    b_tb = 15;
    sel_tb = 1;

    #10;
    $finish;

end 
endmodule


// 4:1 mux 


module mux4_1(
    input reg[3:0] a,
    input reg[3:0] b,
    input reg[3:0] c,
    input reg[3:0] d,
    input reg[1:0] sel,
    output reg[3:0] out

);
// always_comb begin 
//     if(sel == 0) out = a;
//     else if (sel == 1) out = b;
//     else if (sel == 2) out = c;
//     else out = d;
// end 

// always @(*) begin 
//     if(sel == 0) out = a;
//     else if (sel == 1) out = b;
//     else if (sel == 2) out = c;
//     else out = d;

// end 

always @(*) begin 
    case(sel) 
        0: out = a;
        1: out = b;
        2: out = c;
        3: out = d;
        default: out = 4'b0000;
    endcase
end

endmodule 

module mux4_1tb;
reg[3:0] a_tb;
reg[3:0] b_tb;
reg[3:0] c_tb;
reg[3:0] d_tb;
reg [1:0] sel_tb;
wire [3:0] out_tb;

mux4_1 dut (.a(a_tb),
            .b(b_tb),
            .c(c_tb),
            .d(d_tb),
            .sel(sel_tb),
            .out(out_tb));

initial begin 
    $dumpfile("waves.vcd");
    $dumpvars;

    $monitor("a is %d, b is %d, c is %d, d is %d, sel is %d, out is %d", a_tb, b_tb, c_tb, d_tb, sel_tb, out_tb);

    a_tb =0;
    b_tb = 0;
    c_tb = 0;
    d_tb = 0;
    sel_tb =0;

    #10;

    a_tb = 1;
    b_tb = 5;
    c_tb = 4;
    d_tb = 6;
    sel_tb = 1;

    #10;

    a_tb = 11;
    b_tb = 10;
    c_tb = 12;
    d_tb = 13;
    sel_tb = 2;

    #10;

    a_tb = 12;
    b_tb = 15;
    c_tb = 2;
    d_tb = 5;
    sel_tb = 0;

    #10;
    a_tb = 8;
    b_tb = 9;
    c_tb = 7;
    d_tb = 1;
    sel_tb = 3;

    #10;
    $finish;

end 
endmodule


/*
if you prefer system verilog use always_comb instead of always @(*)
always_comb is a SystemVerilog construct specifically designed for combinational logic.

@(*) means:
“Trigger this block whenever any signal used inside changes.”
This was introduced to avoid manually writing sensitivity lists like:
    always @(a or b)

always_comb explicitly tells the compiler/simulator:
“This block MUST behave as pure combinational logic.”

advantages: 
    better latch detection 

    always_comb begin
        if(sel)
            out = a;
    end

What happens when sel = 0?
out keeps old value → latch inferred.
With always_comb, tools warn/error more aggressively because combinational logic should assign outputs in ALL paths.

Prevents multiple drivers
A variable assigned in an always_comb block cannot be assigned elsewhere procedurally.

Executes once at time 0
always_comb automatically executes once at simulation start.
This avoids some initialization/simulation mismatch issues.


*/

// latches 
/*

A latch is a storage element that remembers a value.
It is similar to a flip-flop, but behaves differently.
The important thing is:
    Flip-flops are edge-triggered
    Latches are level-sensitive
In RTL design, accidental latches are usually considered bugs.

A latch acts like:
    “If enable is ON → output follows input
    If enable is OFF → hold previous value”
So it stores data.

A latch is inferred whenever:
    A combinational block does NOT assign an output in all possible paths.

always_comb begin
    if(sel)
        out = a;
end

What happens when sel == 0?
    There is NO assignment to out.
    So hardware must somehow preserve old value.
    That means synthesis creates memory.
    That memory is a latch.

The synthesizer thinks:
“Since out must keep previous value when sel=0, I need storage.”
So it builds a latch.

why are latches bad ? 
    it creates unnecessary memory for combintional logic
    Latches are transparent while enable is active. Data can propagate unexpectedly.
    This creates:
        glitches
        races
        unpredictable timing behavior
    Flip-flops are safer because they sample only on edges.
*/

/*
A latch is inferred when a combinational block does not assign outputs in every possible execution path, 
forcing hardware to retain the previous value.

*/
