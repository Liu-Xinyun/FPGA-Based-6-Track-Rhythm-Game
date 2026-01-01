`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/06/05 20:35:01
// Design Name: 
// Module Name: layer_mixer
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


module layer_mixer(
    input [15:0] Layer_beginning,
    input [15:0] Layer0,
    input [15:0] Layer1,
    input [15:0] Layer2,
    input [3:0] game_state,
    output reg [11:0] Data
    );

    parameter beginning = 0;
    parameter ingame = 1;
    parameter halt = 2;

    always @(*) begin
        case (game_state)
            beginning : begin
                            Data[11:0] = Layer_beginning[15:4];
                        end
            ingame    : begin
                            Data[11:8] = Layer2[0]?Layer2[15:12]:Layer1[0]?Layer1[15:12]:Layer0[0]?Layer0[15:12]:0;
                            Data[7:4]  = Layer2[0]?Layer2[11:8]:Layer1[0]?Layer1[11:8]:Layer0[0]?Layer0[11:8]:0;
                            Data[3:0]  = Layer2[0]?Layer2[7:4]:Layer1[0]?Layer1[7:4]:Layer0[0]?Layer0[7:4]:0;
                        end
            halt      : begin
                            Data[11:8] = Layer2[0]?Layer2[15:12]:Layer1[0]?Layer1[15:12]:Layer0[0]?Layer0[15:12]:0;
                            Data[7:4]  = Layer2[0]?Layer2[11:8]:Layer1[0]?Layer1[11:8]:Layer0[0]?Layer0[11:8]:0;
                            Data[3:0]  = Layer2[0]?Layer2[7:4]:Layer1[0]?Layer1[7:4]:Layer0[0]?Layer0[7:4]:0;
                        end 
            default: Data = 12'h000;
        endcase
    end

endmodule
