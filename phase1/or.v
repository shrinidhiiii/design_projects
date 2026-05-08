// or gate 
`timescale 1ns/1ns
module or_gate(
    input a,
    input b,
    output out
);

assign out = a | b;
// or(out,a,b);

endmodule 


//tb

module or_tb;

reg a_tb;
reg b_tb;
wire out_tb;

or_gate dut (.a_tb(a),
              .b_tb(b),
              .out_tb(out));
              
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