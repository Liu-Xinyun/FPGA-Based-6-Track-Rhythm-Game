`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/06/27 22:36:38
// Design Name: 
// Module Name: music_display
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


module music_display(
    input	clk,
    input [3:0] game_state,					
    output	beep,				//蜂鸣器输出
    output  sd
    );	
    reg	beep_r;	
    reg [7:0] state;				//乐谱状态机
    reg [16:0] count, count1;
    reg [26:0] count2, count3;  
    assign sd=1'b1; 

    parameter beginning = 0;
    parameter ingame = 1;
    parameter halt = 2;
    parameter ending = 3;

    parameter trackline_width = 3;
    parameter trackline_position = 440;
    parameter tap_width = 20;

    parameter SpeedDown = 330000;
    parameter delay = SpeedDown * (trackline_position + tap_width * 2);

    parameter  //(C大调)
				L_7 = 18'd101216,    //低音7
				M_1 = 18'd95602,	//中音1
				M_2 = 18'd85179,    //中音2
				M_3 = 18'd75873,	//中音3
				M_4 = 18'd71633,    //中音4
				M_5 = 18'd63776,    //中音5
				M_6 = 18'd56818,    //中音6
				M_7 = 18'd50607,    //中音7
				H_1 = 18'd47801,   
				H_2 = 18'd42553,
			    PAUSE = 18'd100; 

    reg [31:0] CountDelay = 0;
    always @(posedge clk) begin
        if (game_state == beginning) begin
            CountDelay <= 0;
        end else if (game_state == ingame & CountDelay <= delay) begin
            CountDelay <= CountDelay + 1;
        end
    end
								
    assign beep = beep_r;			
    always@(posedge clk) begin
        count <= count + 1'b1;		
        if(count == count1) begin	
            count <= 17'h0;			
            beep_r <= !beep_r;		//实际上每个周期分别包括等时长的高电位和低电位，一高一低反复循环，形成不同频率的声音
        end
    end

    always @(posedge clk) begin
        if (game_state == beginning | CountDelay < delay) begin
            count1 <= 0;
            count2 <= 0;
            count3 <= 0;
            state <= 0;
        end
        else if (game_state == ingame) begin
            case(state)//大不自多
                8'D0:begin count1 = M_3;count3=48000000;end
                8'D1:begin count1 = PAUSE;count3=2000000;end
                8'D2:begin count1 = M_3;count3=48000000;end
                8'D3:begin count1 = PAUSE;count3=2000000;end
                8'D4:begin count1 = M_3;count3=50000000;end
                8'D5:begin count1 = M_5;count3=100000000;end
                8'D6:begin count1 = M_1;count3=50000000;end
                8'D7:begin count1 = M_2;count3=100000000;end
                8'D8:begin count1 = M_4;count3=50000000;end
                8'D9:begin count1 = M_3;count3=100000000;end
                8'D10:begin count1 = M_5;count3=50000000;end
                8'D11:begin count1 = M_6;count3=50000000;end
                8'D12:begin count1 = M_5;count3=50000000;end
                8'D13:begin count1 = M_4;count3=50000000;end
                8'D14:begin count1 = M_6;count3=100000000;end
                8'D15:begin count1 = PAUSE;count3=50000000;end
                8'D16:begin count1 = M_6;count3=50000000;end
                8'D17:begin count1 = M_7;count3=50000000;end
                8'D18:begin count1 = M_6;count3=50000000;end
                8'D19:begin count1 = M_5;count3=98000000;end
                8'D20:begin count1 = PAUSE;count3=2000000;end
                8'D21:begin count1 = M_5;count3=50000000;end
                8'D22:begin count1 = H_1;count3=100000000;end
                8'D23:begin count1 = M_7;count3=25000000;end
                8'D24:begin count1 = M_6;count3=25000000;end
                8'D25:begin count1 = M_5;count3=75000000;end
                8'D26:begin count1 = M_4;count3=25000000;end
                8'D27:begin count1 = M_3;count3=50000000;end
                8'D28:begin count1 = M_6;count3=50000000;end
                8'D29:begin count1 = M_2;count3=50000000;end
                8'D30:begin count1 = M_3;count3=50000000;end
                8'D31:begin count1 = M_2;count3=100000000;end
                8'D32:begin count1 = PAUSE;count3=50000000;end
                8'D33:begin count1 = M_3;count3=50000000;end
                8'D34:begin count1 = M_3;count3=50000000;end
                8'D35:begin count1 = M_6;count3=48000000;end
                8'D36:begin count1 = PAUSE;count3=2000000;end
                8'D37:begin count1 = M_6;count3=75000000;end
                8'D38:begin count1 = M_5;count3=23000000;end
                8'D39:begin count1 = PAUSE;count3=2000000;end
                8'D40:begin count1 = M_5;count3=48000000;end
                8'D41:begin count1 = PAUSE;count3=2000000;end
                8'D42:begin count1 = M_5;count3=48000000;end
                8'D43:begin count1 = PAUSE;count3=2000000;end
                8'D44:begin count1 = M_5;count3=50000000;end
                8'D45:begin count1 = H_1;count3=50000000;end
                8'D46:begin count1 = M_7;count3=98000000;end
                8'D47:begin count1 = PAUSE;count3=2000000;end
                8'D48:begin count1 = M_7;count3=25000000;end
                8'D49:begin count1 = H_1;count3=25000000;end
                8'D50:begin count1 = H_2;count3=25000000;end
                8'D51:begin count1 = H_1;count3=25000000;end
                8'D52:begin count1 = M_7;count3=25000000;end
                8'D53:begin count1 = M_6;count3=25000000;end
                8'D54:begin count1 = M_5;count3=50000000;end
                8'D55:begin count1 = M_2;count3=50000000;end
                8'D56:begin count1 = M_6;count3=50000000;end
                8'D57:begin count1 = L_7;count3=50000000;end
                8'D58:begin count1 = M_1;count3=100000000;end
                8'D59:begin count1 = M_3;count3=48000000;end
                8'D60:begin count1 = PAUSE;count3=2000000;end
                8'D61:begin count1 = M_3;count3=48000000;end
                8'D62:begin count1 = PAUSE;count3=2000000;end
                8'D63:begin count1 = M_3;count3=50000000;end
                8'D64:begin count1 = M_5;count3=100000000;end
                8'D65:begin count1 = M_1;count3=50000000;end
                8'D66:begin count1 = M_2;count3=100000000;end
                8'D67:begin count1 = M_4;count3=50000000;end
                8'D68:begin count1 = M_3;count3=98000000;end
                8'D69:begin count1 = PAUSE;count3=2000000;end
                8'D70:begin count1 = M_3;count3=48000000;end
                8'D71:begin count1 = PAUSE;count3=2000000;end
                8'D72:begin count1 = M_3;count3=48000000;end
                8'D73:begin count1 = PAUSE;count3=2000000;end
                8'D74:begin count1 = M_3;count3=50000000;end
                8'D75:begin count1 = M_6;count3=100000000;end
                8'D76:begin count1 = M_4;count3=23000000;end
                8'D77:begin count1 = PAUSE;count3=2000000;end
                8'D78:begin count1 = M_4;count3=25000000;end
                8'D79:begin count1 = M_2;count3=100000000;end
                8'D80:begin count1 = M_1;count3=50000000;end
                8'D81:begin count1 = M_2;count3=100000000;end
                8'D82:begin count1 = PAUSE;count3=50000000;end
                8'D83:begin count1 = M_6;count3=48000000;end
                8'D84:begin count1 = PAUSE;count3=2000000;end
                8'D85:begin count1 = M_6;count3=50000000;end
                8'D86:begin count1 = M_7;count3=50000000;end
                8'D87:begin count1 = H_1;count3=100000000;end
                8'D88:begin count1 = M_7;count3=25000000;end
                8'D89:begin count1 = M_6;count3=25000000;end
                8'D90:begin count1 = M_5;count3=100000000;end
                8'D91:begin count1 = M_4;count3=50000000;end
                8'D92:begin count1 = M_3;count3=100000000;end
                8'D93:begin count1 = M_1;count3=50000000;end
                8'D94:begin count1 = M_6;count3=23000000;end
                8'D95:begin count1 = PAUSE;count3=2000000;end
                8'D96:begin count1 = M_6;count3=23000000;end
                8'D97:begin count1 = PAUSE;count3=2000000;end
                8'D98:begin count1 = M_6;count3=50000000;end
                8'D99:begin count1 = M_2;count3=50000000;end
                8'D100:begin count1 = M_5;count3=23000000;end
                8'D101:begin count1 = PAUSE;count3=2000000;end
                8'D102:begin count1 = M_5;count3=23000000;end
                8'D103:begin count1 = PAUSE;count3=2000000;end
                8'D104:begin count1 = M_5;count3=50000000;end
                8'D105:begin count1 = M_1;count3=50000000;end
                8'D106:begin count1 = M_4;count3=23000000;end
                8'D107:begin count1 = PAUSE;count3=2000000;end
                8'D108:begin count1 = M_4;count3=23000000;end
                8'D109:begin count1 = PAUSE;count3=2000000;end
                8'D110:begin count1 = M_4;count3=50000000;end
                8'D111:begin count1 = M_5;count3=50000000;end
                8'D112:begin count1 = M_3;count3=25000000;end
                8'D113:begin count1 = M_2;count3=23000000;end
                8'D114:begin count1 = PAUSE;count3=2000000;end
                8'D115:begin count1 = M_2;count3=50000000;end
                8'D116:begin count1 = M_1;count3=50000000;end
                8'D117:begin count1 = M_2;count3=50000000;end
                8'D118:begin count1 = M_3;count3=50000000;end
                8'D119:begin count1 = M_5;count3=50000000;end
                8'D120:begin count1 = M_4;count3=50000000;end
                8'D121:begin count1 = M_3;count3=25000000;end
                8'D122:begin count1 = M_4;count3=25000000;end
                8'D123:begin count1 = M_5;count3=50000000;end
                8'D124:begin count1 = M_6;count3=50000000;end
                8'D125:begin count1 = M_7;count3=25000000;end
                8'D126:begin count1 = H_1;count3=25000000;end
                8'D127:begin count1 = H_2;count3=25000000;end
                8'D128:begin count1 = H_1;count3=25000000;end
                8'D129:begin count1 = M_7;count3=25000000;end
                8'D130:begin count1 = M_6;count3=25000000;end
                8'D131:begin count1 = M_5;count3=50000000;end
                8'D132:begin count1 = M_2;count3=50000000;end
                8'D133:begin count1 = M_6;count3=50000000;end
                8'D134:begin count1 = L_7;count3=50000000;end
                8'D135:begin count1 = M_1;count3=100000000;end
                8'D136:begin count1 = PAUSE;count3=50000000;end     
                default: count1 = 16'h0;
            endcase
            if(count2 < count3)            
                count2 <= count2 + 1'b1;
            else begin
                count2 = 26'd0;
                if(state == 8'd136) 
                    state = 8'd0;
                else
                    state = state + 1'b1;
            end
        end 
    end
endmodule

