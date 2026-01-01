`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/06/06 12:02:50
// Design Name: 
// Module Name: key_render
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


module key_render(
    input OriginalClk,
    input [9:0] XPosition,
    input [9:0] YPosition,
    input [479:0] track1_data,
    input [479:0] track2_data,
    input [479:0] track3_data,
    input [479:0] track4_data,
    input [479:0] track5_data,
    input [479:0] track6_data,
    output reg [15:0] LayerOutput
    );

    parameter track_width = 100;
    parameter trackline_width = 3;
    parameter key_half_width = 40;

    parameter shift = 20;
    parameter track0_start = 0 + shift;
    parameter track1_start = 100 + shift;
    parameter track2_start = 200 + shift;
    parameter track3_start = 300 + shift;
    parameter track4_start = 400 + shift;
    parameter track5_start = 500 + shift;
    parameter track6_start = 600 + shift;

    parameter key1_center = (track0_start + trackline_width + track1_start) / 2;
    parameter key2_center = (track1_start + trackline_width + track2_start) / 2;
    parameter key3_center = (track2_start + trackline_width + track3_start) / 2;
    parameter key4_center = (track3_start + trackline_width + track4_start) / 2;
    parameter key5_center = (track4_start + trackline_width + track5_start) / 2;
    parameter key6_center = (track5_start + trackline_width + track6_start) / 2;

    always @(posedge OriginalClk) begin
        if((track1_data[YPosition] & XPosition > (key1_center - key_half_width) & XPosition < (key1_center + key_half_width))
            | (track2_data[YPosition] & XPosition > (key2_center - key_half_width) & XPosition < (key2_center + key_half_width))
            | (track3_data[YPosition] & XPosition > (key3_center - key_half_width) & XPosition < (key3_center + key_half_width))
            | (track4_data[YPosition] & XPosition > (key4_center - key_half_width) & XPosition < (key4_center + key_half_width))
            | (track5_data[YPosition] & XPosition > (key5_center - key_half_width) & XPosition < (key5_center + key_half_width))
            | (track6_data[YPosition] & XPosition > (key6_center - key_half_width) & XPosition < (key6_center + key_half_width))) LayerOutput <= 16'hfaaf;             
        else  LayerOutput <= 16'hfff0;
    end

endmodule
