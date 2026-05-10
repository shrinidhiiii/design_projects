// barrel shifter 

/*
combinational circuit
shift or rotate by any number of bit positions in a single clock cycle

inputs :
    data (8 bits)
    shift amount (3 bit signal)
    direction (1 bit control : 0=left, 1=right)
    mode (logical/arithmetic/rotate - 2 bit control signal)


Logical Left --> Shift bits left, fill vacated LSBs with 0s
Logical Right --> Shift bits right, fill vacated MSBs with 0s
Arithmetic Right --> Shift bits right, fill vacated MSBs with the sign bit (MSB)
Rotate Left --> Bits shifted out from the MSB wrap around to the LSB
Rotate Right --> Bits shifted out from the LSB wrap around to the MSB

Example (8-bit data)
Suppose data = 8'b10110100

logical left - <<2 - 1101_0000
logical right - >>2 - 0010_1101
arithmetic right - >>> 2 - 1110_1101
rotate left - rotate_by_2bits - 11010010
rotate right - rotate_by_2bits - 00101101

*/

module bshifter(
    input      [7:0] in,
    input      [2:0] shift_amt,
    input            direction,
    input      [1:0] mode,
    output reg [7:0] out
);

    always_comb begin
        out = 8'b0; // default

        // Logical
        if (mode == 2'd0) begin
            if (direction == 1'b0)
                out = in << shift_amt;
            else
                out = in >> shift_amt;
        end

        // Arithmetic
        else if (mode == 2'd1) begin
            if (direction == 1'b0)
                out = in << shift_amt;        // same as logical left
            else
                out = $signed(in) >>> shift_amt; // sign bit replicated
        end

        // Rotate
        else if (mode == 2'd2) begin
            if (direction == 1'b0)
                out = (in << shift_amt) | (in >> (8 - shift_amt)); // rotate left
            else
                out = (in >> shift_amt) | (in << (8 - shift_amt)); // rotate right
        end

        else begin
            out = 8'b0;
        end
    end

endmodule

module bshifter_tb;

    // Inputs
    reg [7:0] in;
    reg [2:0] shift_amt;
    reg       direction;
    reg [1:0] mode;

    // Output
    wire [7:0] out;

    // Instantiate DUT (Device Under Test)
    bshifter dut (
        .in        (in),
        .shift_amt (shift_amt),
        .direction (direction),
        .mode      (mode),
        .out       (out)
    );

    initial begin
        $display("in       | shift | dir | mode | out");
        $display("---------|-------|-----|------|--------");
        $monitor("%b |   %0d   |  %0d  |  %0d   | %b", in, shift_amt, direction, mode, out);

        // ---- Logical Left Shift ----
        in = 8'b10110100; shift_amt = 3'd2; direction = 0; mode = 2'd0;
        #10;
        in = 8'b10110100; shift_amt = 3'd4; direction = 0; mode = 2'd0;
        #10;

        // ---- Logical Right Shift ----
        in = 8'b10110100; shift_amt = 3'd2; direction = 1; mode = 2'd0;
        #10;
        in = 8'b10110100; shift_amt = 3'd4; direction = 1; mode = 2'd0;
        #10;

        // ---- Arithmetic Right Shift ----
        in = 8'b10110100; shift_amt = 3'd2; direction = 1; mode = 2'd1;
        #10;
        in = 8'b00110100; shift_amt = 3'd2; direction = 1; mode = 2'd1; // positive number
        #10;

        // ---- Rotate Left ----
        in = 8'b10110100; shift_amt = 3'd2; direction = 0; mode = 2'd2;
        #10;
        in = 8'b10110100; shift_amt = 3'd4; direction = 0; mode = 2'd2;
        #10;

        // ---- Rotate Right ----
        in = 8'b10110100; shift_amt = 3'd2; direction = 1; mode = 2'd2;
        #10;
        in = 8'b10110100; shift_amt = 3'd4; direction = 1; mode = 2'd2;
        #10;

        // ---- Edge Cases ----
        in = 8'b10110100; shift_amt = 3'd0; direction = 0; mode = 2'd0; // shift by 0
        #10;
        in = 8'b10110100; shift_amt = 3'd7; direction = 0; mode = 2'd0; // max shift
        #10;
        in = 8'b00000000; shift_amt = 3'd3; direction = 0; mode = 2'd0; // all zeros
        #10;
        in = 8'b11111111; shift_amt = 3'd3; direction = 1; mode = 2'd0; // all ones
        #10;

        $display("=== Test Complete ===");
        $finish;
    end

endmodule


/*
1. 
input reg is invalid syntax
Inputs cannot be declared as reg. reg is only for outputs or internal signals.

// Wrong
input reg [7:0] in;

// Correct
input [7:0] in;

2. 
reg [7:0] copy_in = in outside always block
You cannot assign an input to a reg at declaration time like this — it won't track changes to in. Move it inside the always_comb block.

// Wrong - static, won't update
reg [7:0] copy_in = in;

// Correct - inside always_comb
reg [7:0] copy_in;
always_comb begin
    copy_in = in;  // now it updates whenever in changes

3. 
Driving in inside always block
in is an input port, you cannot assign to it. This line is illegal:

// Wrong
in = in >> shift_amt;  // can't drive an input!

// Correct - use copy_in instead
copy_in = copy_in >> shift_amt;

// These do the exact same thing, no need for <
out = (in << shift_amt);
out = (in <<< shift_amt);

whereas >>> and >> are differnt
>> - logical (fill with 0s)
>>> - arithmetic (fill with MSB bit)

// Correct
copy_in = in[shift_amt-1 : 0];  // grab bottom bits  <- but this is not synthesizable with variable index
// Better way:
out = (in >> shift_amt) | (in << (8 - shift_amt));

*/
