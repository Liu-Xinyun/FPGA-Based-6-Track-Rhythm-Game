`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/05/30 10:41:04
// Design Name: 
// Module Name: clk_div_2ms
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


module clk_div_2ms(
    input clk,
    input reset,
    output reg clk_2ms
    );

    reg [20:0] count = 0;

    always @(posedge clk) begin
        if (!reset) begin
            count <= 0;
            clk_2ms = 0;
        end

        else if (count < 200000) begin
            count <= count + 1;
        end

        else begin
            clk_2ms <= ~clk_2ms;
            count <= 0;
        end 
    end

endmodule
