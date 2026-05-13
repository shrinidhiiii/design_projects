// Asynchronous FIFO


module async_fifo #(
    parameter DATA_WIDTH = 8,
    parameter ADDR_WIDTH = 4
)(
    // Write Domain
    input  wire wr_clk,
    input  wire wr_rst_n,
    input  wire wr_en,
    input  wire [DATA_WIDTH-1:0] wr_data,
    output wire full,

    // Read Domain
    input  wire rd_clk,
    input  wire rd_rst_n,
    input  wire rd_en,
    output wire [DATA_WIDTH-1:0] rd_data,
    output wire empty
);

    localparam DEPTH = 1 << ADDR_WIDTH;

    reg [DATA_WIDTH-1:0] mem [0:DEPTH-1];
    reg [ADDR_WIDTH:0]   wr_ptr, rd_ptr;      // Binary pointers
    wire [ADDR_WIDTH:0]  wr_ptr_g, rd_ptr_g;  // Gray code pointers
    
    reg [ADDR_WIDTH:0]   wr_ptr_g_sync1, wr_ptr_g_sync2;
    reg [ADDR_WIDTH:0]   rd_ptr_g_sync1, rd_ptr_g_sync2;

    // Dual Port Memory 
    always @(posedge wr_clk) begin
        if (wr_en && !full)
            mem[wr_ptr[ADDR_WIDTH-1:0]] <= wr_data;
    end
    
    assign rd_data = mem[rd_ptr[ADDR_WIDTH-1:0]];

    // Write Domain Logic 
    always @(posedge wr_clk or negedge wr_rst_n) begin
        if (!wr_rst_n) wr_ptr <= 0;
        else if (wr_en && !full) wr_ptr <= wr_ptr + 1;
    end

    
    assign wr_ptr_g = (wr_ptr >> 1) ^ wr_ptr; // Binary to Gray conversion 

    // Synchronize Read Pointer into Write Domain
    always @(posedge wr_clk or negedge wr_rst_n) begin
        if (!wr_rst_n) begin
            rd_ptr_g_sync1 <= 0;
            rd_ptr_g_sync2 <= 0;
        end else begin
            rd_ptr_g_sync1 <= rd_ptr_g;
            rd_ptr_g_sync2 <= rd_ptr_g_sync1;
        end
    end

    // Read Domain Logic 
    always @(posedge rd_clk or negedge rd_rst_n) begin
        if (!rd_rst_n) rd_ptr <= 0;
        else if (rd_en && !empty) rd_ptr <= rd_ptr + 1;
    end

    assign rd_ptr_g = (rd_ptr >> 1) ^ rd_ptr;

    // Synchronize Write Pointer into Read Domain
    always @(posedge rd_clk or negedge rd_rst_n) begin
        if (!rd_rst_n) begin
            wr_ptr_g_sync1 <= 0;
            wr_ptr_g_sync2 <= 0;
        end else begin
            wr_ptr_g_sync1 <= wr_ptr_g;
            wr_ptr_g_sync2 <= wr_ptr_g_sync1;
        end
    end

    // Full and Empty Flags 
    // Empty: Gray pointers are identical
    assign empty = (rd_ptr_g == wr_ptr_g_sync2);

    // Full: MSB and MSB-1 should be flipped, rest are same (Gray code property)
    assign full  = (wr_ptr_g == {~rd_ptr_g_sync2[ADDR_WIDTH:ADDR_WIDTH-1], 
                                 rd_ptr_g_sync2[ADDR_WIDTH-2:0]});

endmodule


`timescale 1ns/1ps

module async_fifo_tb;

    // Parameters
    parameter DATA_WIDTH = 8;
    parameter ADDR_WIDTH = 4;
    
    // Write Domain Signals
    reg wr_clk = 0;
    reg wr_rst_n = 0;
    reg wr_en = 0;
    reg [DATA_WIDTH-1:0] wr_data = 0;
    wire full;

    // Read Domain Signals
    reg rd_clk = 0;
    reg rd_rst_n = 0;
    reg rd_en = 0;
    wire [DATA_WIDTH-1:0] rd_data;
    wire empty;

    // Instantiate the FIFO
    async_fifo #(DATA_WIDTH, ADDR_WIDTH) uut (
        .wr_clk(wr_clk),
        .wr_rst_n(wr_rst_n),
        .wr_en(wr_en),
        .wr_data(wr_data),
        .full(full),
        .rd_clk(rd_clk),
        .rd_rst_n(rd_rst_n),
        .rd_en(rd_en),
        .rd_data(rd_data),
        .empty(empty)
    );

    // Clock Generation
    // Write Clock: 100MHz (10ns period)
    always #5 wr_clk = ~wr_clk;
    
    // Read Clock: ~40MHz (25ns period)
    always #12.5 rd_clk = ~rd_clk;

    // Test Procedure
    initial begin
        // Reset System
        wr_rst_n = 0;
        rd_rst_n = 0;
        #50;
        wr_rst_n = 1;
        rd_rst_n = 1;
        #20;

        // --- Test 1: Write until Full ---
        repeat (20) begin
            @(posedge wr_clk);
            if (!full) begin
                wr_en = 1;
                wr_data = wr_data + 1;
            end else begin
                wr_en = 0;
            end
        end
        wr_en = 0;
        
        #100; // Wait for synchronization

        // --- Test 2: Read until Empty ---
        repeat (20) begin
            @(posedge rd_clk);
            if (!empty) begin
                rd_en = 1;
            end else begin
                rd_en = 0;
            end
        end
        rd_en = 0;

        #100;
        $display("Simulation Finished");
        $finish;
    end

    // Monitor output
    initial begin
        $monitor("Time: %0t | wr_data: %h | rd_data: %h | Full: %b | Empty: %b", 
                 $time, wr_data, rd_data, full, empty);
    end

endmodule
