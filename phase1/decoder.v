
// 3:8 decoder

module decoder(
    input in,
    output out
);

reg [2:0] in;
reg [7:0] out;

// always_comb begin 
//     case(in)
//         3'b000 : out = 8'b0000_0001;
//         3'b001 : out = 8'b0000_0010;
//         3'b010 : out = 8'b0000_0100;
//         3'b011 : out = 8'b0000_1000;
//         3'b100 : out = 8'b0001_0000;
//         3'b101 : out = 8'b0010_0000;
//         3'b110 : out = 8'b0100_0000;
//         3'b111 : out = 8'b1000_0000;
//         default : out = 8'b0000_0000;

//     endcase
// end 

assign out = 1'b1 << in;

// always_comb begin
//     out = 8'b00000000;
//     out[in] = 1'b1;
// end

endmodule 

module decoder_tb;

reg [2:0] in;
reg [7:0] out;

 decoder dut(.in(in),
              .out(out));

initial begin 
    $monitor("in is %d, out is %d", in, out);
    in =0;

    #10;
    in = 1;
    #10;
    in = 5;
    #10;
    in = 6;
    #10;
    in = 7;

    #10;
    in = 2;
    #10;
    in = 4;
    #10;
    in = 3;
    #10;
    in = 0;
    #10;
    in = 6;
    #10;
    in = 7;
    #10;
    in = 2;
    #10;
    in = 4;
    #10;
    in = 5;

    #10;
    $finish;

end 
endmodule