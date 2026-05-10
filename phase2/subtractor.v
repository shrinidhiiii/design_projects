// subtractor 
/*
there is no hardware for doing subtraction. 
So do A+(~B+1)
*/

module subtractor(
    input [3:0]a,
    input [3:0]b,
    output [3:0]out

);
// assign out = a - b;
assign out = a + (~b + 1);
endmodule 
