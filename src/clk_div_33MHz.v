`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/06/20 19:32:38
// Design Name: 
// Module Name: clk_div_33MHz
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


module clk_div_33MHz(
    input clk,
    input reset,
    output clk_div_33MHz
    );

    reg [1:0] step1, step;
    always @(posedge clk)
    begin
        case(step)
        2'b00: step<=2'b10;
        2'b01: step<=2'b00;
        2'b10: step<=2'b01;
        default: step<=2'b00;
    endcase
    end
    always @(negedge clk)
    begin
        case(step1)
        2'b00: step1<=2'b10;
        2'b01: step1<=2'b00;
        2'b10: step1<=2'b01;
        default: step1<=2'b00;
    endcase
    end
    assign clk_div_33MHz=(step[0]|step1[0]);

endmodule

