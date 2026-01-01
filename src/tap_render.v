`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/06/06 10:46:41
// Design Name: 
// Module Name: tap_render
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

module tap_render(
    input OriginalClk,
    input [9:0] XPosition,
    input [9:0] YPosition,
    output reg [15:0] LayerOutput
    );

    wire [16:0] CurrentROMAddress;
    wire [15:0] BackgroundData;
    assign IsInDisplayArea = ({8'b0,XPosition}>420) && ({8'b0,XPosition}<500) && ({8'b0,YPosition}<8);
    assign CurrentROMAddress = IsInDisplayArea ? {8'b0,XPosition} - 420 + ({8'b0,YPosition}) * 17'd80 : 0; 
 
    reg PrescaledClk = 0;
    always@(posedge OriginalClk)
    begin
        PrescaledClk <= PrescaledClk + 1;
    end
    blk_mem_gen_1 tap_render(PrescaledClk, CurrentROMAddress, BackgroundData);

    always@(posedge OriginalClk) begin
        if (IsInDisplayArea) LayerOutput <= BackgroundData;
        else                 LayerOutput <= 16'hfff0;   
    end      

    

endmodule
