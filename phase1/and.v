// and gate 
`timescale 1ns/1ns
module and_gate(
    input a,
    input b,
    output out
);

assign out = a&b;
// and(out,a,b);

endmodule 


//tb

module and_tb;

reg a_tb;
reg b_tb;
wire out_tb;

and_gate dut (.a(a_tb),
              .b(b_tb),
              .out(out_tb));

initial begin 
    $dumpfile("waves.vcd");
    $dumpvars;

    // $dumpvars(0, and_tb); // dumps all variables in and_tb and all its submodules 
    // $dumpvars(1, and_tb); // dumps all variables only in and_tb and not its submodules 
  $monitor("a is %d, b is %d, out is %d", a_tb, b_tb, out_tb);

    a_tb = 0;
    b_tb = 0;
    #10;
    a_tb = 1;
    b_tb = 0;
    #10;
    a_tb = 0;
    b_tb = 1;
    #10;
    a_tb = 1;
    b_tb = 1;

    #10;
    $finish;



end 
endmodule 

// note:
/*
if the input is more than 1 bit. then bitwise add is performed. 
meaning if a=5(101), b=7(111), then result is 5(101)
meaning if a=3(11), b=4(100), then result is 0(000)

*/
