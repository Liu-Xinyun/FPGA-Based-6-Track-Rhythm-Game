`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/06/27 20:11:03
// Design Name: 
// Module Name: beginning_render
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


module beginning_render(
    input OriginalClk,
    input [9:0] XPosition,
    input [9:0] YPosition,
    output reg [15:0] LayerOutput
    );

    parameter word_length = 500;
    parameter word_width = 68;
    parameter word_shiftX = 70;
    parameter word_shiftY = 40;

    parameter picture_length = 300;
    parameter picture_width = 300;
    parameter picture_shiftX = 170;
    parameter picture_shiftY = 150;


    wire [15:0] Word_BackgroundData;
    wire [16:0] Word_CurrentROMAddress;
    assign Word_IsInDisplayArea = ({8'b0,XPosition} > word_shiftX & {8'b0,XPosition} < word_shiftX + word_length)
                                & ({8'b0,YPosition} > word_shiftY & {8'b0,YPosition} < word_shiftY + word_width);
    assign Word_CurrentROMAddress = Word_IsInDisplayArea ? ({8'b0,XPosition} - word_shiftX) + ({8'b0,YPosition} - word_shiftY) * word_length : 0; 

    wire [15:0] Picture_BackgroundData;
    wire [16:0] Picture_CurrentROMAddress;
    assign Picture_IsInDisplayArea = ({8'b0,XPosition} > picture_shiftX & {8'b0,XPosition} < picture_shiftX + picture_length)
                                   & ({8'b0,YPosition} > picture_shiftY & {8'b0,YPosition} < picture_shiftY + picture_width);
    assign Picture_CurrentROMAddress = Picture_IsInDisplayArea ? ({8'b0,XPosition} - picture_shiftX) + ({8'b0,YPosition} - picture_shiftY) * picture_length : 0; 
 
    reg PrescaledClk = 0;
    always@(posedge OriginalClk) begin
        PrescaledClk <= PrescaledClk + 1;
    end

    blk_mem_gen_0 picture_render(PrescaledClk, Picture_CurrentROMAddress, Picture_BackgroundData);
    blk_mem_gen_3 word_render(PrescaledClk, Word_CurrentROMAddress, Word_BackgroundData);

    always@(posedge OriginalClk) begin
        if      (Word_IsInDisplayArea)    LayerOutput <= Word_BackgroundData;
        else if (Picture_IsInDisplayArea) LayerOutput <= Picture_BackgroundData;
        else                              LayerOutput <= 16'hfff0;   
    end  
endmodule
