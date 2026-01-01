`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/05/30 10:31:49
// Design Name: 
// Module Name: display_score
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


module display_score(
    input [31:0] score,
    input clk,
    input reset,
    output reg [11:0] seg1_out,
    output reg [11:0] seg2_out
    );

    parameter WORD_0 = 8'b11111100;
    parameter WORD_1 = 8'b01100000;
    parameter WORD_2 = 8'b11011010;
    parameter WORD_3 = 8'b11110010;
    parameter WORD_4 = 8'b01100110;
    parameter WORD_5 = 8'b10110110;
    parameter WORD_6 = 8'b10111110;
    parameter WORD_7 = 8'b11100000;
    parameter WORD_8 = 8'b11111110;
    parameter WORD_9 = 8'b11110110;

    parameter S0 = 0;
    parameter S1 = 1;
    parameter S2 = 2;
    parameter S3 = 3;

    // 产生 500 Hz 时钟
    wire clk_2ms;
    clk_div_2ms clk_div_2ms(.clk(clk), .reset(reset), .clk_2ms(clk_2ms));

    wire [3:0] bcd_out[7:0];

    //转换为 BCD 码
    BCD BCD(
        .number(score),
        .bcd0(bcd_out[0]),
        .bcd1(bcd_out[1]),
        .bcd2(bcd_out[2]),
        .bcd3(bcd_out[3]),
        .bcd4(bcd_out[4]),
        .bcd5(bcd_out[5]),
        .bcd6(bcd_out[6]),
        .bcd7(bcd_out[7])
    );
    
    //数码管输出
    reg [1:0] current_state = 0, next_state;

    always @(*) begin
        if (!reset) begin
            next_state <= S0;
        end
        else case (current_state)
            S0: next_state = S1;
            S1: next_state = S2;
            S2: next_state = S3;
            S3: next_state = S0; 
            default: next_state = S0;
        endcase 
    end

    always @(posedge clk_2ms) begin
        current_state <= next_state;
    end

    always @(*) begin
        case (current_state)
            S0: if (bcd_out[7]==0) begin seg1_out<={4'b1000,WORD_0}; end
                else if (bcd_out[7]==1) begin seg1_out<={4'b1000,WORD_1}; end
                else if (bcd_out[7]==2) begin seg1_out<={4'b1000,WORD_2}; end
                else if (bcd_out[7]==3) begin seg1_out<={4'b1000,WORD_3}; end
                else if (bcd_out[7]==4) begin seg1_out<={4'b1000,WORD_4}; end
                else if (bcd_out[7]==5) begin seg1_out<={4'b1000,WORD_5}; end
                else if (bcd_out[7]==6) begin seg1_out<={4'b1000,WORD_6}; end
                else if (bcd_out[7]==7) begin seg1_out<={4'b1000,WORD_7}; end
                else if (bcd_out[7]==8) begin seg1_out<={4'b1000,WORD_8}; end
                else if (bcd_out[7]==9) begin seg1_out<={4'b1000,WORD_9}; end
     
            S1: if (bcd_out[6]==0) begin seg1_out<={4'b0100,WORD_0}; end
                else if (bcd_out[6]==1) begin seg1_out<={4'b0100,WORD_1}; end
                else if (bcd_out[6]==2) begin seg1_out<={4'b0100,WORD_2}; end
                else if (bcd_out[6]==3) begin seg1_out<={4'b0100,WORD_3}; end
                else if (bcd_out[6]==4) begin seg1_out<={4'b0100,WORD_4}; end
                else if (bcd_out[6]==5) begin seg1_out<={4'b0100,WORD_5}; end
                else if (bcd_out[6]==6) begin seg1_out<={4'b0100,WORD_6}; end
                else if (bcd_out[6]==7) begin seg1_out<={4'b0100,WORD_7}; end
                else if (bcd_out[6]==8) begin seg1_out<={4'b0100,WORD_8}; end
                else if (bcd_out[6]==9) begin seg1_out<={4'b0100,WORD_9}; end
            
            S2: if (bcd_out[5]==0) begin seg1_out<={4'b0010,WORD_0}; end
                else if (bcd_out[5]==1) begin seg1_out<={4'b0010,WORD_1}; end
                else if (bcd_out[5]==2) begin seg1_out<={4'b0010,WORD_2}; end
                else if (bcd_out[5]==3) begin seg1_out<={4'b0010,WORD_3}; end
                else if (bcd_out[5]==4) begin seg1_out<={4'b0010,WORD_4}; end
                else if (bcd_out[5]==5) begin seg1_out<={4'b0010,WORD_5}; end
                else if (bcd_out[5]==6) begin seg1_out<={4'b0010,WORD_6}; end
                else if (bcd_out[5]==7) begin seg1_out<={4'b0010,WORD_7}; end
                else if (bcd_out[5]==8) begin seg1_out<={4'b0010,WORD_8}; end
                else if (bcd_out[5]==9) begin seg1_out<={4'b0010,WORD_9}; end

            S3: if (bcd_out[4]==0) begin seg1_out<={4'b0001,WORD_0}; end
                else if (bcd_out[4]==1) begin seg1_out<={4'b0001,WORD_1}; end
                else if (bcd_out[4]==2) begin seg1_out<={4'b0001,WORD_2}; end
                else if (bcd_out[4]==3) begin seg1_out<={4'b0001,WORD_3}; end
                else if (bcd_out[4]==4) begin seg1_out<={4'b0001,WORD_4}; end
                else if (bcd_out[4]==5) begin seg1_out<={4'b0001,WORD_5}; end
                else if (bcd_out[4]==6) begin seg1_out<={4'b0001,WORD_6}; end
                else if (bcd_out[4]==7) begin seg1_out<={4'b0001,WORD_7}; end
                else if (bcd_out[4]==8) begin seg1_out<={4'b0001,WORD_8}; end
                else if (bcd_out[4]==9) begin seg1_out<={4'b0001,WORD_9}; end
            default: begin seg1_out <= 12'b000000000000; end     
        endcase

        case (current_state)
            S0: if (bcd_out[3]==0) begin seg2_out<={4'b1000,WORD_0}; end
                else if (bcd_out[3]==1) begin seg2_out<={4'b1000,WORD_1}; end
                else if (bcd_out[3]==2) begin seg2_out<={4'b1000,WORD_2}; end
                else if (bcd_out[3]==3) begin seg2_out<={4'b1000,WORD_3}; end
                else if (bcd_out[3]==4) begin seg2_out<={4'b1000,WORD_4}; end
                else if (bcd_out[3]==5) begin seg2_out<={4'b1000,WORD_5}; end
                else if (bcd_out[3]==6) begin seg2_out<={4'b1000,WORD_6}; end
                else if (bcd_out[3]==7) begin seg2_out<={4'b1000,WORD_7}; end
                else if (bcd_out[3]==8) begin seg2_out<={4'b1000,WORD_8}; end
                else if (bcd_out[3]==9) begin seg2_out<={4'b1000,WORD_9}; end
     
            S1: if (bcd_out[2]==0) begin seg2_out<={4'b0100,WORD_0}; end
                else if (bcd_out[2]==1) begin seg2_out<={4'b0100,WORD_1}; end
                else if (bcd_out[2]==2) begin seg2_out<={4'b0100,WORD_2}; end
                else if (bcd_out[2]==3) begin seg2_out<={4'b0100,WORD_3}; end
                else if (bcd_out[2]==4) begin seg2_out<={4'b0100,WORD_4}; end
                else if (bcd_out[2]==5) begin seg2_out<={4'b0100,WORD_5}; end
                else if (bcd_out[2]==6) begin seg2_out<={4'b0100,WORD_6}; end
                else if (bcd_out[2]==7) begin seg2_out<={4'b0100,WORD_7}; end
                else if (bcd_out[2]==8) begin seg2_out<={4'b0100,WORD_8}; end
                else if (bcd_out[2]==9) begin seg2_out<={4'b0100,WORD_9}; end
            
            S2: if (bcd_out[1]==0) begin seg2_out<={4'b0010,WORD_0}; end
                else if (bcd_out[1]==1) begin seg2_out<={4'b0010,WORD_1}; end
                else if (bcd_out[1]==2) begin seg2_out<={4'b0010,WORD_2}; end
                else if (bcd_out[1]==3) begin seg2_out<={4'b0010,WORD_3}; end
                else if (bcd_out[1]==4) begin seg2_out<={4'b0010,WORD_4}; end
                else if (bcd_out[1]==5) begin seg2_out<={4'b0010,WORD_5}; end
                else if (bcd_out[1]==6) begin seg2_out<={4'b0010,WORD_6}; end
                else if (bcd_out[1]==7) begin seg2_out<={4'b0010,WORD_7}; end
                else if (bcd_out[1]==8) begin seg2_out<={4'b0010,WORD_8}; end
                else if (bcd_out[1]==9) begin seg2_out<={4'b0010,WORD_9}; end

            S3: if (bcd_out[0]==0) begin seg2_out<={4'b0001,WORD_0}; end
                else if (bcd_out[0]==1) begin seg2_out<={4'b0001,WORD_1}; end
                else if (bcd_out[0]==2) begin seg2_out<={4'b0001,WORD_2}; end
                else if (bcd_out[0]==3) begin seg2_out<={4'b0001,WORD_3}; end
                else if (bcd_out[0]==4) begin seg2_out<={4'b0001,WORD_4}; end
                else if (bcd_out[0]==5) begin seg2_out<={4'b0001,WORD_5}; end
                else if (bcd_out[0]==6) begin seg2_out<={4'b0001,WORD_6}; end
                else if (bcd_out[0]==7) begin seg2_out<={4'b0001,WORD_7}; end
                else if (bcd_out[0]==8) begin seg2_out<={4'b0001,WORD_8}; end
                else if (bcd_out[0]==9) begin seg2_out<={4'b0001,WORD_9}; end
            default: begin seg2_out <= 12'b000000000000; end     
        endcase
    end

endmodule
