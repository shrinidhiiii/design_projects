// half_adder

/*
// half adder - to add two binary numbers
// sum is xor 
// carry out is and 
// carry in is ignored 

| A | B | Sum | Carry |
| - | - | --- | ----- |
| 0 | 0 | 0   | 0     |
| 0 | 1 | 1   | 0     |
| 1 | 0 | 1   | 0     |
| 1 | 1 | 0   | 1     |

*/

module half_adder(
    input a,
    input b,
    output sum,
    output carry
);

assign sum = a ^ b;
assign carry = a & b;


endmodule 

module half_adder_tb;
reg a_tb;
reg b_tb;
wire sum_tb ;
wire carry_tb;

half_adder dut (.a(a_tb), 
                .b(b_tb),
                .sum(sum_tb),
                .carry(carry_tb));

initial begin 

    $monitor("a is %b, b is %b, sum is %b, carry is %b", a_tb, b_tb, sum_tb, carry_tb);

    a_tb = 0;
    b_tb = 0;

    #10;
    a_tb = 1;
    b_tb = 1;

    #10;
    a_tb = 1;
    b_tb = 0;

    #10;
    a_tb = 0;
    b_tb = 0;

    #10;
    a_tb = 0;
    b_tb = 1;

    #10;
    $finish;


end 

endmodule