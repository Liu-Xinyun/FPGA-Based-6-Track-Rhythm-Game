`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/06/05 23:23:29
// Design Name: 
// Module Name: background_render
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


module background_render(
    input OriginalClk,
    input [9:0] XPosition,
    input [9:0] YPosition,
    input key_state,
    input [3:0] key_ascii,
    input [2:0] msg,
    output reg [15:0] LayerOutput
    );

    parameter track_width = 100;
    parameter trackline_width = 3;
    parameter window_width = 20;

    parameter shift = 20;
    parameter track0_start = 0 + shift;
    parameter track1_start = 100 + shift;
    parameter track2_start = 200 + shift;
    parameter track3_start = 300 + shift;
    parameter track4_start = 400 + shift;
    parameter track5_start = 500 + shift;
    parameter track6_start = 600 + shift;

    parameter not_in_zone = 0;
    parameter lost = 1;
    parameter far = 2;
    parameter pure = 3;

    always@(posedge OriginalClk) begin
        if ((XPosition > track0_start & XPosition < track0_start + trackline_width)
            | (XPosition > track1_start & XPosition < track1_start + trackline_width)
            | (XPosition > track2_start & XPosition < track2_start + trackline_width)
            | (XPosition > track3_start & XPosition < track3_start + trackline_width)
            | (XPosition > track4_start & XPosition < track4_start + trackline_width)
            | (XPosition > track5_start & XPosition < track5_start + trackline_width)
            | (XPosition > track6_start & XPosition < track6_start + trackline_width)) LayerOutput <=  16'hffff;
        else if (XPosition > track0_start + trackline_width & XPosition < track6_start) LayerOutput <=  16'h444f; 
        else if (XPosition <= track0_start
                | (XPosition >= track6_start + trackline_width & XPosition < track6_start + trackline_width + window_width)) begin
            case (msg)
                not_in_zone : LayerOutput <=  16'h444f;
                lost        : LayerOutput <=  16'hf00f;
                far         : LayerOutput <=  16'h4e5f;
                pure        : LayerOutput <=  16'hf3ff;
                default: LayerOutput <=  16'hfff0;
            endcase
        end
        else LayerOutput <=  16'hfff0; 

        if (key_state) begin
            case (key_ascii)
                1: if (XPosition >= track0_start + trackline_width & XPosition <= track1_start) LayerOutput <=  16'h888f;
                2: if (XPosition >= track1_start + trackline_width & XPosition <= track2_start) LayerOutput <=  16'h888f;
                3: if (XPosition >= track2_start + trackline_width & XPosition <= track3_start) LayerOutput <=  16'h888f;
                4: if (XPosition >= track3_start + trackline_width & XPosition <= track4_start) LayerOutput <=  16'h888f;
                5: if (XPosition >= track4_start + trackline_width & XPosition <= track5_start) LayerOutput <=  16'h888f;
                6: if (XPosition >= track5_start + trackline_width & XPosition <= track6_start) LayerOutput <=  16'h888f;
                default:;
            endcase
        end
    end 

endmodule
