`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 13.09.2024 20:59:45
// Design Name: 
// Module Name: tb_fifo
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module fifo_tb;

    // Parameters and signals
    reg reset, clk, rd, wr;
    reg [7:0] din;
    wire full, empty;
    wire [7:0] dout;
    wire [3:0] fifo_cnt;

    // Instantiate the FIFO DUT
    fifo uut (
        .reset(reset), 
        .clk(clk), 
        .rd(rd), 
        .wr(wr), 
        .din(din), 
        .full(full), 
        .empty(empty), 
        .dout(dout), 
        .fifo_cnt(fifo_cnt)
    );

    // Clock generation (50 MHz clock)
    always #10 clk = ~clk;

    // Test sequence
    initial begin
        // Initial conditions
        clk = 0; reset = 1; rd = 0; wr = 0; din = 0;
        #20 reset = 0;
        
        // Write to FIFO until full
        $display("Test 1: Write to FIFO until Full");
        wr = 1;
        repeat(8) begin
            din = din + 1;
            #20;
        end
        wr = 0;
        if (full) $display("Test Passed: FIFO Full Detected");
        else $display("Test Failed: FIFO Full Not Detected");

        // Read from FIFO until empty
        $display("Test 2: Read from FIFO until Empty");
        rd = 1;
        repeat(8) #20;
        rd = 0;
        if (empty) $display("Test Passed: FIFO Empty Detected");
        else $display("Test Failed: FIFO Empty Not Detected");

        // Test simultaneous read/write
        $display("Test 3: Simultaneous Read/Write");
        wr = 1; rd = 1; din = 8'hAA;
        repeat(4) #20;
        wr = 0; rd = 0;
        $display("Test Passed: Simultaneous Read/Write Test Completed");

        // Test reset functionality
        $display("Test 4: Reset Functionality");
        reset = 1;
        #20 reset = 0;
        if (fifo_cnt == 0 && empty && !full) $display("Test Passed: FIFO Reset Successful");
        else $display("Test Failed: FIFO Reset Failed");

        $finish;
    end
endmodule


