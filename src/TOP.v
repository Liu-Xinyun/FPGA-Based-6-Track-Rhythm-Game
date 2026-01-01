`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/05/30 10:34:45
// Design Name: 
// Module Name: TOP
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


module TOP(
    // EGO1 时钟 P17
    input clk,
    // EGO1 复位 P15 （低电平有效）
    input reset,
    input key_reset,
    // 按钮
    input button_beginning,
    input button_ingame,
    input button_halt,
    input [1:0] choice,
    // 测试
    output [3:0] debug_led,
    output [7:0] keyboard_led,
    // 键盘
    input key_clk,
    input key_data,			    
    // 数码管
    output [11:0] seg1_out,
    output [11:0] seg2_out,
    // VGA
    output [3:0] R,
    output [3:0] G, 
    output [3:0] B, 
    output HSync,   
    output VSync,
    // 音频
    // output	beep,   //蜂鸣器输出
    // output  sd   
    output uart_txd
    );

    parameter beginning = 0;
    parameter ingame = 1;
    parameter halt = 2;
    parameter ending = 3;

    wire [9:0] XPosition;
    wire [9:0] YPosition;

    wire [479:0] track1_data;
    wire [479:0] track2_data;
    wire [479:0] track3_data;
    wire [479:0] track4_data;
    wire [479:0] track5_data;
    wire [479:0] track6_data;

    wire [15:0] Layer_beginning;
    wire [15:0] Layer0;
    wire [15:0] Layer1;
    wire [15:0] Layer2;

    wire [11:0] Data;
    wire [31:0] score;

    wire key_state;
    wire [3:0] key_ascii;

    wire [3:0] game_state;
    wire [2:0] msg;

    // 状态机
    FSM               FSM               (clk, reset, button_beginning, button_ingame, button_halt, game_state);

    // 键盘输入
    keyboard          keyboard          (clk, key_reset, key_clk, key_data, key_state, key_ascii);
    // 键盘调试灯
    assign keyboard_led[0] = (key_ascii == 0);
    assign keyboard_led[1] = (key_ascii == 1);
    assign keyboard_led[2] = (key_ascii == 2);
    assign keyboard_led[3] = (key_ascii == 3);
    assign keyboard_led[4] = (key_ascii == 4);
    assign keyboard_led[5] = (key_ascii == 5);
    assign keyboard_led[6] = (key_ascii == 6);
    assign keyboard_led[7] = (game_state == ingame);

    // 轨道控制
    track_control     track_control     (clk, XPosition, YPosition, key_state, key_ascii, game_state, choice, msg, score, debug_led, track1_data, track2_data, track3_data,
                                                                                                                             track4_data, track5_data, track6_data);

    // 生成图层
    beginning_render  beginning_render  (clk, XPosition, YPosition, Layer_beginning);
    background_render background_render (clk, XPosition, YPosition, key_state, key_ascii, msg, Layer0);
    line_render       line_render       (clk, XPosition, YPosition, Layer1);
    key_render        key_render        (clk, XPosition, YPosition, track1_data, track2_data, track3_data,
                                                                    track4_data, track5_data, track6_data, Layer2); 

    layer_mixer       layer_mixer       (Layer_beginning, Layer0, Layer1, Layer2, game_state, Data);

    // VGA 输出
    VGA_display       VGA_display       (clk, Data, R, G, B, HSync, VSync, XPosition, YPosition);

    // 音频输出
    // music_display     music_display     (clk, game_state, beep, sd);
    DFP DFP(clk, reset, game_state, choice, uart_txd);

    // 数码管输出
    display_score     display_score     (score, clk, reset, seg1_out, seg2_out);

endmodule
