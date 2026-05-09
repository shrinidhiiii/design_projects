// carry lookahead adder 
/*
The Problem with Ripple Carry
In your ripple carry adder, 
each full adder has to wait for the previous carry to arrive before it can compute its result. 
For a 4-bit adder, carry ripples through 4 stages — for 32 or 64 bits, this delay becomes very large.

Instead of waiting for carry to ripple, CLA pre-computes all carries at once using two helper signals:
Generate (G) — this bit generates a carry regardless of carry-in:
    G = A & B

Propagate (P) — this bit propagates an incoming carry forward:
    P = A ^ B

*/

module CLA_4bit (
    input  logic [3:0] A, B,
    input  logic       Cin,
    output logic [3:0] Sum,
    output logic       Cout
);
    logic [3:0] G, P;       // Generate and Propagate
    logic [4:0] C;          // Carries C[0]=Cin, C[4]=Cout

    // Step 1: Compute G and P for each bit
    assign G = A & B;
    assign P = A ^ B;

    // Step 2: Pre-compute ALL carries in parallel
    assign C[0] = Cin;
    assign C[1] = G[0] | (P[0] & C[0]);
    assign C[2] = G[1] | (P[1] & G[0]) | (P[1] & P[0] & C[0]);
    assign C[3] = G[2] | (P[2] & G[1]) | (P[2] & P[1] & G[0]) | (P[2] & P[1] & P[0] & C[0]);
    assign C[4] = G[3] | (P[3] & G[2]) | (P[3] & P[2] & G[1]) | (P[3] & P[2] & P[1] & G[0]) 
                       | (P[3] & P[2] & P[1] & P[0] & C[0]);

    // Step 3: Compute Sum using pre-computed carries
    assign Sum  = P ^ C[3:0]; // Full adder sum formula
                                    // Sum = A ^ B ^ Cin
                                    // We can rewrite this as:
                                    // Sum = P ^ Cin

    assign Cout = C[4];

endmodule

`timescale 1ns/1ps

module CLA_4bit_tb;

    logic [3:0] A, B, Sum;
    logic Cin, Cout;

    CLA_4bit dut (
        .A    (A),
        .B    (B),
        .Cin  (Cin),
        .Sum  (Sum),
        .Cout (Cout)
    );

    initial begin
        $monitor("A=%0d B=%0d Cin=%0d | Sum=%0d Cout=%0d", A, B, Cin, Sum, Cout);

        A = 4'b0000; B = 4'b0000; Cin = 0; #10;  // 0  + 0  = 0
        A = 4'b0001; B = 4'b0001; Cin = 0; #10;  // 1  + 1  = 2
        A = 4'b0101; B = 4'b0011; Cin = 0; #10;  // 5  + 3  = 8
        A = 4'b1010; B = 4'b0101; Cin = 1; #10;  // 10 + 5 + 1 = 16
        A = 4'b1111; B = 4'b1111; Cin = 0; #10;  // 15 + 15 = 30
        A = 4'b1111; B = 4'b1111; Cin = 1; #10;  // 15 + 15 + 1 = 31

        $finish;
    end

endmodule
