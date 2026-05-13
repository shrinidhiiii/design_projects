// binary_toGray convertor

module binary_toGray(
    input [5:0] in,
    output reg[5:0] out
);

always_comb begin 
    out[5] = in[5];
  for(int i=4; i>=0; i--) begin 
    out[i] = in[i] ^ in[i+1];
end 
end 

endmodule 



module tb;
  reg [5:0]in;
  wire [5:0]out;
  
  binary_toGray dut (.in(in), .out(out));
  
  initial begin 
    $monitor("in : %d, out : %d", in, out);
    in =0;
    
    #10;
    
    repeat(50) begin 
      in = in +1;
      #10;
    end 
    
    
    #50;
    $finish;
    
  end 
  
endmodule
