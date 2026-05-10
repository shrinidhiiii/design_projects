// ALU and flag generator 

module flag_gen(
    input  [7:0] result,
    input        carry_out,
    input        carry_in_msb,  // carry into bit 7 (MSB)
    output       Z,             // zero
    output       N,             // negative
    output       C,             // carry
    output       V              // overflow
);
    assign Z = (result == 8'b0);   // all bits zero
    assign N = result[7];          // MSB is sign bit
    assign C = carry_out;          // carry out of MSB
    assign V = carry_out ^ carry_in_msb; // signed overflow
endmodule


module ALU(
    input      [7:0] A,
    input      [7:0] B,
    input      [2:0] op,       // operation select
    output reg [7:0] result,
    output           Z,        // zero flag
    output           N,        // negative flag
    output           C,        // carry flag
    output           V         // overflow flag
);

    // internal signals for flag generator
    reg  carry_out;
    reg  carry_in_msb;
    wire [8:0] temp; // 9-bit to capture carry

    // Operation codes
    // 000 = ADD
    // 001 = SUB
    // 010 = AND
    // 011 = OR
    // 100 = XOR
    // 101 = NOT A
    // 110 = shift left A by 1
    // 111 = shift right A by 1

    always_comb begin
        result       = 8'b0;
        carry_out    = 1'b0;
        carry_in_msb = 1'b0;

        case(op)
            3'b000: begin  // ADD
                {carry_out, result} = A + B;
                carry_in_msb = A[6] & B[6]; // carry into MSB
            end

            3'b001: begin  // SUB (A - B)
                {carry_out, result} = A + (~B + 1);
                carry_in_msb = A[6] & (~B[6]);
            end

            3'b010: begin  // AND
                result       = A & B;
                carry_out    = 1'b0;
                carry_in_msb = 1'b0;
            end

            3'b011: begin  // OR
                result       = A | B;
                carry_out    = 1'b0;
                carry_in_msb = 1'b0;
            end

            3'b100: begin  // XOR
                result       = A ^ B;
                carry_out    = 1'b0;
                carry_in_msb = 1'b0;
            end

            3'b101: begin  // NOT A
                result       = ~A;
                carry_out    = 1'b0;
                carry_in_msb = 1'b0;
            end

            3'b110: begin  // Shift Left A by 1
                result       = A << 1;
                carry_out    = A[7]; // MSB shifts out
                carry_in_msb = 1'b0;
            end

            3'b111: begin  // Shift Right A by 1
                result       = A >> 1;
                carry_out    = A[0]; // LSB shifts out
                carry_in_msb = 1'b0;
            end

            default: begin
                result       = 8'b0;
                carry_out    = 1'b0;
                carry_in_msb = 1'b0;
            end
        endcase
    end

    // instantiate flag generator
    flag_gen fg(
        .result      (result),
        .carry_out   (carry_out),
        .carry_in_msb(carry_in_msb),
        .Z           (Z),
        .N           (N),
        .C           (C),
        .V           (V)
    );

endmodule


