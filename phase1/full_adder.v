// full_adder
/*
two input bits + carry in 
A + B + Cin

uses :
    to add two multi-bit numbers:
          1011
        + 0110

Addition starts from the right side.
At each stage, a carry may come from the previous bit.
A half adder cannot process that incoming carry.
So processors use full adders.

| A | B | Cin | Sum | Cout |
| - | - | --- | --- | ---- |
| 0 | 0 | 0   | 0   | 0    |
| 0 | 0 | 1   | 1   | 0    |
| 0 | 1 | 0   | 1   | 0    |
| 0 | 1 | 1   | 0   | 1    |
| 1 | 0 | 0   | 1   | 0    |
| 1 | 0 | 1   | 0   | 1    |
| 1 | 1 | 0   | 0   | 1    |
| 1 | 1 | 1   | 1   | 1    |


odd number of inputs is 1 --> xor 
so sum = A'B'Cin + A'BCin' + AB'Cin' + ABCin
Cout= AB + ACin + BCin
*/
module full_adder(
    input A,
    input B,
    input Cin, 
    output sum,
    output carry 

);

assign sum = A ^ B ^ Cin;
assign carry = (A & B) | (A & Cin) | (B & Cin);

endmodule 

module full_adder_tb;
reg a_tb;
reg b_tb;
reg cin_tb;
wire sum_tb ;
wire carry_tb;

full_adder dut (.A(a_tb), 
                .B(b_tb),
                .Cin(cin_tb),
                .sum(sum_tb),
                .carry(carry_tb));

initial begin 

    $monitor("a is %b, b is %b, Cin is %b, sum is %b, carry is %b", a_tb, b_tb, cin_tb, sum_tb, carry_tb);

    a_tb = 0;
    b_tb = 0;
    cin_tb = 0;

    #10;
    a_tb = 1;
    b_tb = 1;
    cin_tb = 0;

    #10;
    a_tb = 1;
    b_tb = 0;
    cin_tb = 0;

    #10;
    a_tb = 0;
    b_tb = 1;
    cin_tb = 0;

    #10;
    a_tb = 1;
    b_tb = 1;
    cin_tb = 1;

    #10;
    a_tb = 0;
    b_tb = 0;
    cin_tb = 1;

    #10;
    a_tb = 0;
    b_tb = 1;
    cin_tb = 1;

    #10;
    a_tb = 1;
    b_tb = 0;
    cin_tb = 1;

 

    #10;
    $finish;


end 

endmodule