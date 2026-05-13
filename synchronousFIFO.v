// Synchronous FIFO 

module FIFO #(
    parameter DATA_WIDTH =8,
    parameter ADDRESS_WIDTH =4,
    parameter FIFO_DEPTH = (1 << ADDRESS_WIDTH)
)(
    input clk,
    input rst_n,
    input wr_en,
    input [DATA_WIDTH-1:0] wr_data,
    input rd_en,
    output [DATA_WIDTH-1:0]rd_data,
    output full,
    output empty,
    output [ADDRESS_WIDTH:0] count
    
);

reg [DATA_WIDTH-1:0]mem[FIFO_DEPTH];
reg [ADDRESS_WIDTH:0] rd_ptr;
reg [ADDRESS_WIDTH:0] wr_ptr;

assign rd_data = mem[rd_ptr[ADDRESS_WIDTH-1:0]];

assign full = (wr_ptr[ADDRESS_WIDTH] != rd_ptr[ADDRESS_WIDTH]) && (wr_ptr[ADDRESS_WIDTH-1:0]==(rd_ptr[ADDRESS_WIDTH-1:0]));
assign empty = (wr_ptr == rd_ptr);

assign count = wr_ptr-rd_ptr;

always @(posedge clk or negedge rst_n) begin 
    if(!rst_n) begin
        rd_ptr <= 0;
        wr_ptr <= 0;
    end 
    else 
    if (wr_en && !full) begin
        wr_ptr <= wr_ptr +1;
        mem[wr_ptr[ADDRESS_WIDTH-1:0]] <= wr_data;
    end 
     if (rd_en && !empty) begin
        rd_ptr <= rd_ptr +1;
    end 
    
end


endmodule 

`timescale 1ns/1ps

module FIFO_tb;

    // --- 1. Signal Declarations ---
    parameter DATA_WIDTH = 8;
    parameter ADDRESS_WIDTH = 3;

    reg clk;
    reg rst_n;
    reg wr_en;
    reg [DATA_WIDTH-1:0] wr_data;
    reg rd_en;

    wire [DATA_WIDTH-1:0] rd_data;
    wire full, empty;
    wire [ADDRESS_WIDTH:0] count;

    // --- 2. UUT Instantiation ---
    FIFO #(DATA_WIDTH, ADDRESS_WIDTH) uut (
        .clk(clk), .rst_n(rst_n),
        .wr_en(wr_en), .wr_data(wr_data),
        .rd_en(rd_en), .rd_data(rd_data),
        .full(full), .empty(empty), .count(count)
    );

    // --- 3. Clock Generation ---
    always #5 clk = ~clk; // 100MHz clock

    // --- 4. Main Test Procedure ---
    initial begin
        // A. Initialization & Reset
        integer i;
        clk = 0;
        rst_n = 0;
        wr_en = 0;
        rd_en = 0;
        wr_data = 0;
        
        $display("--- Step 1: System Reset ---");
        #20 rst_n = 1; 
        @(posedge clk); 

        $display("--- Dumping FIFO Memory Contents ---");
        for (i = 0; i < (1 << ADDRESS_WIDTH); i = i + 1) begin
            $display("Address %0d: Data = %d", i, uut.mem[i]);
        end


        // B. Write until Full
        $display("--- Step 2: Writing until Full ---");
        repeat (8) begin
            @(posedge clk);
            wr_en = 1;
            wr_data = wr_data + 1;
        end

        @(posedge clk) wr_en = 0; // Turn off write enable
        #10;

        $display("--- Dumping FIFO Memory Contents ---");
        for (i = 0; i < (1 << ADDRESS_WIDTH); i = i + 1) begin
            $display("Address %0d: Data = %d", i, uut.mem[i]);
        end


        // C. Test Overflow (Write while Full)
        $display("--- Step 3: Testing Overflow Protection ---");
        @(posedge clk);
        wr_en = 1;
        wr_data = 200; // This should be ignored by the FIFO
        @(posedge clk);
        wr_en = 0;

        $display("--- Dumping FIFO Memory Contents ---");
        for (i = 0; i < (1 << ADDRESS_WIDTH); i = i + 1) begin
            $display("Address %0d: Data = %d", i, uut.mem[i]);
        end


        // D. Read until Empty
        $display("--- Step 4: Reading until Empty ---");
        repeat (8) begin
            @(posedge clk);
            rd_en = 1;
        end
        @(posedge clk) rd_en = 0; // Turn off read enable
        #10;

        $display("--- Dumping FIFO Memory Contents ---");
        for (i = 0; i < (1 << ADDRESS_WIDTH); i = i + 1) begin
            $display("Address %0d: Data = %d", i, uut.mem[i]);
        end


        // E. Test Underflow (Read while Empty)
        $display("--- Step 5: Testing Underflow Protection ---");
        @(posedge clk);
        rd_en = 1; // This should be ignored by the FIFO
        @(posedge clk);
        rd_en = 0;

        $display("--- Dumping FIFO Memory Contents ---");
        for (i = 0; i < (1 << ADDRESS_WIDTH); i = i + 1) begin
            $display("Address %0d: Data = %d", i, uut.mem[i]);
        end

        // F. Write until Full - again
        $display("--- Step 6: Writing until Full ---");
        repeat (8) begin
            @(posedge clk);
            wr_en = 1;
            wr_data = wr_data + 1;
        end

        @(posedge clk) wr_en = 0; // Turn off write enable
        #10;

        $display("--- Dumping FIFO Memory Contents ---");
        for (i = 0; i < (1 << ADDRESS_WIDTH); i = i + 1) begin
            $display("Address %0d: Data = %d", i, uut.mem[i]);
        end

        // F. Finish
        $display("--- Step 7: Simulation Complete ---");


        $display("--- Dumping FIFO Memory Contents ---");
        for (i = 0; i < (1 << ADDRESS_WIDTH); i = i + 1) begin
            $display("Address %0d: Data = %d", i, uut.mem[i]);
        end

        #50 $finish;
    end

    

endmodule
