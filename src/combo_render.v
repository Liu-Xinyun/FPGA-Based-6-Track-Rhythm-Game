`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/06/27 14:45:15
// Design Name: 
// Module Name: combo_render
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


module combo_render(
    input OriginalClk,
    input [9:0] XPosition,
    input [9:0] YPosition,
    input [2:0] msg,
    output reg [15:0] LayerOutput
    );

    parameter not_in_zone = 0;
    parameter lost = 1;
    parameter far = 2;
    parameter pure = 3;

    reg [31:0] combo_number = 0;

    always @(posedge OriginalClk) begin
        case (msg)
            not_in_zone : ;
            lost        : combo_number <= 0;
            far         : combo_number <= combo_number + 1;
            pure        : combo_number <= combo_number + 1;
            default:      combo_number <= 0;
        endcase
    end

endmodule
