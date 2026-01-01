`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/06/26 14:43:01
// Design Name: 
// Module Name: track_control
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


module track_control(
    input OriginalClk,
    input [9:0] XPosition,
    input [9:0] YPosition,
    input key_state,
    input [3:0] key_ascii,
    input [3:0] game_state,
    input [1:0] choice,
    output reg [2:0] msg,
    output [31:0] score,
    output reg [3:0] debug_led,
    output [479:0] track1_data,
    output [479:0] track2_data,
    output [479:0] track3_data,
    output [479:0] track4_data,
    output [479:0] track5_data,
    output [479:0] track6_data
    );

    parameter beginning = 0;
    parameter ingame = 1;
    parameter halt = 2;
    parameter ending = 3;

    parameter trackline_width = 3;
    parameter trackline_position = 440;
    parameter tap_width = 20;

    parameter not_in_zone = 0;
    parameter lost = 1;
    parameter far = 2;
    parameter pure = 3;

    parameter SpeedRead = 25000000;
    parameter SpeedDown = 330000;
    parameter SpeedMsg = 50000000;
    parameter SpeedHold = 2000000;

    reg [31:0] CountRead = 0;
    reg [31:0] CountDown = 0;
    reg [31:0] CountMsg = 0;
    reg [31:0] CountHold = 0;

    reg [479:0] track1;
    reg [479:0] track2;
    reg [479:0] track3;
    reg [479:0] track4;
    reg [479:0] track5;
    reg [479:0] track6;

    reg [31:0] score1 = 0;
    reg [31:0] score2 = 0;
    reg [31:0] score3 = 0;
    reg [31:0] score4 = 0;
    reg [31:0] score5 = 0;
    reg [31:0] score6 = 0;

    reg [16:0] CurrentROMAddress = 0;
    reg hold = 0;
    wire [5:0] Data1;
    wire [6:0] Data2;

    always @(posedge OriginalClk) begin
        if (game_state == beginning) begin
            CountRead <= 0;
            CountDown <= 0;
            CountMsg <= 0;
            CountHold <= 0;
            CurrentROMAddress <= 0;
            hold <= 0;

            track1 <= 480'b0; track2 <= 480'b0; track1 <= 480'b0; track3 <= 480'b0; track4 <= 480'b0; track5 <= 480'b0; track6 <= 480'b0;
            score1 <= 32'b0; score2 <= 32'b0; score3 <= 32'b0; score4 <= 32'b0; score5 <= 32'b0; score6 <= 32'b0;
        end
        else if (game_state == ingame) begin
            if (CountRead == SpeedRead) begin
                CountRead <= 0;
                CountDown <= CountDown + 1;
                CurrentROMAddress <= CurrentROMAddress + 1;

                case (choice)
                    2'b10:  begin
                                track1[19:0]<=(Data1[0]) ? 20'hfffff:20'h0;
                                track2[19:0]<=(Data1[1]) ? 20'hfffff:20'h0;
                                track3[19:0]<=(Data1[2]) ? 20'hfffff:20'h0;
                                track4[19:0]<=(Data1[3]) ? 20'hfffff:20'h0;
                                track5[19:0]<=(Data1[4]) ? 20'hfffff:20'h0;
                                track6[19:0]<=(Data1[5]) ? 20'hfffff:20'h0;
                            end
                    2'b01:  begin
                                track1[19:0]<=(Data2[0]) ? 20'hfffff:20'h0;
                                track2[19:0]<=(Data2[2]) ? 20'hfffff:20'h0;
                                track3[19:0]<=(Data2[3]) ? 20'hfffff:20'h0;
                                track4[19:0]<=(Data2[4]) ? 20'hfffff:20'h0;
                                track5[19:0]<=(Data2[5]) ? 20'hfffff:20'h0;
                                track6[19:0]<=(Data2[6]) ? 20'hfffff:20'h0;
                            end
                    default: begin
                                track1[19:0]<=20'h0;
                                track2[19:0]<=20'h0;
                                track3[19:0]<=20'h0;
                                track4[19:0]<=20'h0;
                                track5[19:0]<=20'h0;
                                track6[19:0]<=20'h0;
                            end
                endcase
            end
            else if (CountDown == SpeedDown) begin
                CountDown <= 0;
                CountRead <= CountRead + 1;

                track1 <= track1 << 1;
                track2 <= track2 << 1;
                track3 <= track3 << 1;
                track4 <= track4 << 1;
                track5 <= track5 << 1;
                track6 <= track6 << 1;

                if (track1[trackline_position + 5] & track1[trackline_position + 5 + tap_width - 1]) begin
                    msg <= lost;
                    CountMsg <= 0;
                    track1[trackline_position + 30 : trackline_position + 1] <= 30'b0;
                end 
                if (track2[trackline_position + 5] & track2[trackline_position + 5 + tap_width - 1]) begin
                    msg <= lost;
                    CountMsg <= 0;
                    track2[trackline_position + 30 : trackline_position + 1] <= 30'b0;
                end 
                if (track3[trackline_position + 5] & track3[trackline_position + 5 + tap_width - 1]) begin
                    msg <= lost;
                    CountMsg <= 0;
                    track3[trackline_position + 30 : trackline_position + 1] <= 30'b0;
                end 
                if (track4[trackline_position + 5] & track4[trackline_position + 5 + tap_width - 1]) begin
                    msg <= lost;
                    CountMsg <= 0;
                    track4[trackline_position + 30 : trackline_position + 1] <= 30'b0;
                end
                if (track5[trackline_position + 5] & track5[trackline_position + 5 + tap_width - 1]) begin
                    msg <= lost;
                    CountMsg <= 0;
                    track5[trackline_position + 30 : trackline_position + 1] <= 30'b0;
                end
                if (track6[trackline_position + 5] & track6[trackline_position + 5 + tap_width - 1]) begin
                    msg <= lost;
                    CountMsg <= 0;
                    track6[trackline_position + 30 : trackline_position + 1] <= 30'b0;
                end
                
            end
            else if (key_state) begin
                CountHold <= CountHold + 1;
                CountDown <= CountDown + 1;
                CountRead <= CountRead + 1;
                if(CountHold >= SpeedHold) hold <= 1;
                if (!hold) begin
                    if (key_ascii == 1) begin
                        if(track1[trackline_position-5] & track1[trackline_position+5]) begin //pure 
                            msg <= pure;
                            debug_led = 4'b1000;
                            score1 <= score1 + 100;
                            track1[trackline_position+15:trackline_position-15+1] <= 30'b0;
                        end else if(track1[trackline_position-15] & track1[trackline_position-5]) begin //far
                            msg <= far;
                            debug_led = 4'b0100;
                            score1 <= score1 + 50;
                            track1[trackline_position+5:trackline_position-25+1] <= 30'b0;
                        end else if (track1[trackline_position+5] & track1[trackline_position+15]) begin //far
                            msg <= far;
                            debug_led = 4'b0100;
                            score1 <= score1 + 50;
                            track1[trackline_position+25:trackline_position-5+1] <= 30'b0;
                        end else if(track1[trackline_position-25] & track1[trackline_position-10]) begin  //bad 
                            msg <= lost;
                            debug_led = 4'b0010;
                            score1 <= score1 + 20;
                            track1[trackline_position-5:trackline_position-30+1] <= 25'b0;
                        end
                        CountMsg <= 0; 
                    end
                    else if (key_ascii == 2) begin
                        if(track2[trackline_position-5] & track2[trackline_position+5]) begin //pure 
                            msg <= pure;
                            debug_led = 4'b1000;
                            score2 <= score2 + 100;
                            track2[trackline_position+15:trackline_position-15+1] <= 30'b0;
                        end else if(track2[trackline_position-15] & track2[trackline_position-5]) begin //far
                            msg <= far;
                            debug_led = 4'b0100;
                            score2 <= score2 + 50;
                            track2[trackline_position+5:trackline_position-25+1] <= 30'b0;
                        end else if (track2[trackline_position+5] & track2[trackline_position+15]) begin //far
                            msg <= far;
                            debug_led = 4'b0100;
                            score2 <= score2 + 50;
                            track2[trackline_position+25:trackline_position-5+1] <= 30'b0;
                        end else if(track2[trackline_position-25] & track2[trackline_position-10]) begin  //bad 
                            msg <= lost;
                            debug_led = 4'b0010;
                            score2 <= score2 + 20;
                            track2[trackline_position-5:trackline_position-30+1] <= 25'b0;
                        end
                        CountMsg <= 0;
                    end
                    else if (key_ascii == 3) begin
                        if(track3[trackline_position-5] & track3[trackline_position+5]) begin //pure 
                            msg <= pure;
                            debug_led = 4'b1000;
                            score3 <= score3 + 100;
                            track3[trackline_position+15:trackline_position-15+1] <= 30'b0;
                        end else if(track3[trackline_position-15] & track3[trackline_position-5]) begin //far
                            msg <= far;
                            debug_led = 4'b0100;
                            score3 <= score3 + 50;
                            track3[trackline_position+5:trackline_position-25+1] <= 30'b0;
                        end else if (track3[trackline_position+5] & track3[trackline_position+15]) begin //far
                            msg <= far;
                            debug_led = 4'b0100;
                            score3 <= score3 + 50;
                            track3[trackline_position+25:trackline_position-5+1] <= 30'b0;
                        end else if(track3[trackline_position-25] & track3[trackline_position-10]) begin  //bad 
                            msg <= lost;
                            debug_led = 4'b0010;
                            score3 <= score3 + 20;
                            track3[trackline_position-5:trackline_position-30+1] <= 25'b0;
                        end
                        CountMsg <= 0;
                    end
                    else if (key_ascii == 4) begin
                        if(track4[trackline_position-5] & track4[trackline_position+5]) begin //pure 
                            msg <= pure;
                            debug_led = 4'b1000;
                            score4 <= score4 + 100;
                            track4[trackline_position+15:trackline_position-15+1] <= 30'b0;
                        end else if(track4[trackline_position-15] & track4[trackline_position-5]) begin //far
                            msg <= far;
                            debug_led = 4'b0100;
                            score4 <= score4 + 50;
                            track4[trackline_position+5:trackline_position-25+1] <= 30'b0;
                        end else if (track4[trackline_position+5] & track4[trackline_position+15]) begin //far
                            msg <= far;
                            debug_led = 4'b0100;
                            score4 <= score4 + 50;
                            track4[trackline_position+25:trackline_position-5+1] <= 30'b0;
                        end else if(track4[trackline_position-25] & track4[trackline_position-10]) begin  //bad 
                            msg <= lost;
                            debug_led = 4'b0010;
                            score4 <= score4 + 20;
                            track4[trackline_position-5:trackline_position-30+1] <= 25'b0;
                        end
                        CountMsg <= 0;
                    end
                    else if (key_ascii == 5) begin
                        if(track5[trackline_position-5] & track5[trackline_position+5]) begin //pure 
                            msg <= pure;
                            debug_led = 4'b1000;
                            score5 <= score5 + 100;
                            track5[trackline_position+15:trackline_position-15+1] <= 30'b0;
                        end else if(track5[trackline_position-15] & track5[trackline_position-5]) begin //far
                            msg <= far;
                            debug_led = 4'b0100;
                            score5 <= score5 + 50;
                            track5[trackline_position+5:trackline_position-25+1] <= 30'b0;
                        end else if (track5[trackline_position+5] & track5[trackline_position+15]) begin //far
                            msg <= far;
                            debug_led = 4'b0100;
                            score5 <= score5 + 50;
                            track5[trackline_position+25:trackline_position-5+1] <= 30'b0;
                        end else if(track5[trackline_position-25] & track5[trackline_position-10]) begin  //bad 
                            msg <= lost;
                            debug_led = 4'b0010;
                            score5 <= score5 + 20;
                            track5[trackline_position-5:trackline_position-30+1] <= 25'b0;
                        end
                        CountMsg <= 0;
                    end
                    else if (key_ascii == 6) begin
                        if(track6[trackline_position-5] & track6[trackline_position+5]) begin //pure 
                            msg <= pure;
                            debug_led = 4'b1000;
                            score6 <= score6 + 100;
                            track6[trackline_position+15:trackline_position-15+1] <= 30'b0;
                        end else if(track6[trackline_position-15] & track6[trackline_position-5]) begin //far
                            msg <= far;
                            debug_led = 4'b0100;
                            score6 <= score6 + 50;
                            track6[trackline_position+5:trackline_position-25+1] <= 30'b0;
                        end else if (track6[trackline_position+5] & track6[trackline_position+15]) begin //far
                            msg <= far;
                            debug_led = 4'b0100;
                            score6 <= score6 + 50;
                            track6[trackline_position+25:trackline_position-5+1] <= 30'b0;
                        end else if(track6[trackline_position-25] & track6[trackline_position-10]) begin  //bad 
                            msg <= lost;
                            debug_led = 4'b0010;
                            score6 <= score6 + 20;
                            track6[trackline_position-5:trackline_position-30+1] <= 25'b0;
                        end
                        CountMsg <= 0;
                    end  
                end
            end
            else begin
                hold <= 0;
                CountHold <= 0;
                CountDown <= CountDown + 1;
                CountRead <= CountRead + 1;
            end

            if (CountMsg >= SpeedMsg) begin
                CountMsg <= 0;
                msg <= not_in_zone;
                debug_led = 4'b0001;
            end
            else begin
                CountMsg <= CountMsg + 1;
            end
        end
    end

    assign score = score1 + score2 + score3 + score4 + score5 + score6;

    assign track1_data = track1;
    assign track2_data = track2;
    assign track3_data = track3;
    assign track4_data = track4;
    assign track5_data = track5;
    assign track6_data = track6;

    blk_mem_gen_2 track_data1(OriginalClk, CurrentROMAddress, Data1);
    blk_mem_gen_4 track_data2(OriginalClk, CurrentROMAddress, Data2);

endmodule
