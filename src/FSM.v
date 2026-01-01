`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/06/27 14:43:32
// Design Name: 
// Module Name: FSM
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


module FSM(
    input OriginalClk,
    input reset,
    input button_beginning,
    input button_ingame,
    input button_halt,
    output [3:0] game_state
    );

    parameter beginning = 0;
    parameter ingame = 1;
    parameter halt = 2;
    parameter ending = 3;

    reg [3:0] current_state = beginning;
    reg [3:0] next_state = beginning;

    always @(posedge OriginalClk) begin
        current_state <= next_state;
    end

    always @(posedge OriginalClk) begin
        if (!reset) begin
            next_state <= beginning;
        end 
        else case (current_state)
            beginning : next_state <= (button_beginning == 1) ? ingame : beginning;
            ingame    : next_state <= (button_ingame == 1) ? halt : ingame; 
            halt      : next_state <= (button_halt == 1) ? ingame : halt;
            ending    : next_state <= ending;
            default: next_state <= beginning;
        endcase
    end

    assign game_state = current_state;

endmodule

