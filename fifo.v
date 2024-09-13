`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Ratnadeep
// 
// Create Date: 10.05.2024 20:58:20
// Design Name: 
// Module Name: fifo
// Project Name: synchronous_fifo
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

module fifo (
    input reset, clk, rd, wr,              // Reset, clock, read and write control signals
    input [7:0] din,                       // Data input
    output full, empty,                    // Status signals: Full and Empty
    output reg [7:0] dout,                 // Data output
    output reg [3:0] fifo_cnt              // FIFO counter
);

    // Memory array to store 8 elements of 8 bits each
    reg [7:0] fifo_ram [0:7];              
    reg [2:0] wr_ptr, rd_ptr;              // Write and Read pointers (3 bits for 8-depth FIFO)

    // Full and Empty signals
    assign empty = (fifo_cnt == 0);        // FIFO is empty when fifo_cnt is 0
    assign full = (fifo_cnt == 8);         // FIFO is full when fifo_cnt is 8

    // Write operation
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            wr_ptr <= 0;
            fifo_cnt <= 0;
        end
        else if (wr && !full) begin        // Write when not full
            fifo_ram[wr_ptr] <= din;       // Write data to memory
            wr_ptr <= wr_ptr + 1;          // Increment write pointer
            fifo_cnt <= fifo_cnt + 1;      // Increment FIFO counter
        end
    end

    // Read operation
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            rd_ptr <= 0;
            dout <= 0;
        end
        else if (rd && !empty) begin       // Read when not empty
            dout <= fifo_ram[rd_ptr];      // Read data from memory
            rd_ptr <= rd_ptr + 1;          // Increment read pointer
            fifo_cnt <= fifo_cnt - 1;      // Decrement FIFO counter
        end
    end

    // FIFO Counter - managed in write and read blocks
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            fifo_cnt <= 0;
        end
    end

endmodule

