// xnor


`timescale 1ns/1ns
module xnor_gate(
    input a,
    input b,
    output out
);

assign out =~(a ^ b);
// assign out =(a ~^ b); // also supported
// xnor(out,a,b);

endmodule 


//tb

module xnor_tb;

reg a_tb;
reg b_tb;
wire out_tb;

xnor_gate dut (.a(a_tb),
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

