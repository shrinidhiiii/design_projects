/*

// ripple carry adder 
    simplest multi-bit adder. 
    It is built by connecting multiple full adders in series.

    Each full adder adds:
    Aᵢ + Bᵢ + Carry-in (Cᵢ)
    It produces:
    Sum Sᵢ
    Carry-out Cᵢ₊₁
    That carry “ripples” to the next stage → hence the name.

*/

module FA(
    input A,
    input B, 
    input Cin,
    output Sum,
    output Cout
);
assign Sum = A ^ B ^ Cin ;
assign Cout = (A & B) | (A & Cin) | (B & Cin);
endmodule 

// 4 bit ripple carry 
module rippleCarry(
    input logic[3:0] A,
    input logic[3:0] B,
    input logic Cin,
    output logic[3:0] Sum,
    output logic Cout
);

wire c1, c2, c3;

FA f1(A[0], B[0], Cin, Sum[0], c1);
FA f2(A[1], B[1], c1 ,Sum[1], c2);
FA f3(A[2], B[2], c2 ,Sum[2], c3);
FA f4(A[3], B[3], c3 ,Sum[3], Cout);


endmodule 

`timescale 1ns/1ps

module rippleCarry_tb;

    logic [3:0] A, B, Sum;
    logic Cin, Cout;

    rippleCarry dut (
        .A    (A),
        .B    (B),
        .Cin  (Cin),
        .Sum  (Sum),
        .Cout (Cout)
    );

    initial begin
        $monitor("A=%0d B=%0d Cin=%0d | Sum=%0d Cout=%0d", A, B, Cin, Sum, Cout);

        A = 4'b0000; B = 4'b0000; Cin = 0; #10;  // 0 + 0 = 0
        A = 4'b0001; B = 4'b0001; Cin = 0; #10;  // 1 + 1 = 2
        A = 4'b0101; B = 4'b0011; Cin = 0; #10;  // 5 + 3 = 8
        A = 4'b1010; B = 4'b0101; Cin = 1; #10;  // 10 + 5 + 1 = 16
        A = 4'b1111; B = 4'b1111; Cin = 0; #10;  // 15 + 15 = 30
        A = 4'b1111; B = 4'b1111; Cin = 1; #10;  // 15 + 15 + 1 = 31

        $finish;
    end

endmodule
