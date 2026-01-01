`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/06/05 23:22:00
// Design Name: 
// Module Name: line_render
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

module line_render(
    input OriginalClk,
    input [9:0] XPosition,
    input [9:0] YPosition,
    output reg [15:0] LayerOutput
    );

    parameter trackline_width = 3;
    parameter trackline_position = 440;

    always@(posedge OriginalClk) begin
        if (YPosition > trackline_position & YPosition < trackline_position + trackline_width) LayerOutput <=  16'hff0f; 
        else LayerOutput <=  16'hfff0; 
    end      

endmodule
