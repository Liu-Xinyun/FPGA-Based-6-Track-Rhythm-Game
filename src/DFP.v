`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/06/29 07:45:23
// Design Name: 
// Module Name: DFP
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


module DFP(
    input clk,
    input reset,
    input [3:0] game_state,
    input [1:0] choice,
    output uart_txd
    );

    parameter beginning = 0;
    parameter ingame = 1;
    parameter halt = 2;
    parameter ending = 3;

    reg [0:79] uart_data;
    reg uart_tx_en;
    reg [1:0]cnt; 
    
    uart_tx u1(
	.sys_clk(clk),	//100M系统时钟
	.sys_rst_n(reset),	//系统复位
	.uart_data(uart_data),	//发送的8位置数据
	.uart_tx_en(uart_tx_en),	//发送使能信号
	.uart_txd(uart_txd),	//串口发送数据线
    .tx_flag(DFPflag)    //发送标志位
);

    wire BeginningToIngame;
    wire IngametoHalt;
    wire HaltToIngame;
    wire AnyToBeginning;

    reg [3:0] last_state;
    reg [3:0] cur_state;

    assign BeginningToIngame = (cur_state == ingame) & (last_state == beginning);
    assign IngametoHalt = (cur_state == halt) & (last_state == ingame);
    assign HaltToIngame = (cur_state == ingame) & (last_state == halt);
    assign AnyToBeginning = (cur_state == beginning) & (last_state != beginning);

    always @(posedge clk) begin
        last_state <= cur_state;
        cur_state <= game_state;
    end

    always@(posedge clk)
    begin
        if (BeginningToIngame) begin
            case (choice)
                2'b10: uart_data<={8'h7E,8'hFF,8'h06,8'h03,8'h00,8'h00,8'h03,8'hFE,8'hF5,8'hEF};
                2'b01: uart_data<={8'h7E,8'hFF,8'h06,8'h03,8'h00,8'h00,8'h04,8'hFE,8'hF4,8'hEF}; 
                default: uart_data<=80'd0;
            endcase
            uart_tx_en<=1'b1;
            cnt<=2'd1;
        end
        else if(HaltToIngame)
        begin
            case (choice)
                2'b10: uart_data<={8'h7E,8'hFF,8'h06,8'h0D,8'h00,8'h00,8'h00,8'hFE,8'hEE,8'hEF};
                2'b01: uart_data<={8'h7E,8'hFF,8'h06,8'h0D,8'h00,8'h00,8'h00,8'hFE,8'hEE,8'hEF};
                default: uart_data<=80'd0;
            endcase
            uart_tx_en<=1'b1;
            cnt<=2'd1;
        end
        else if(IngametoHalt)
        begin
            case (choice)
                2'b10: uart_data<={8'h7E,8'hFF,8'h06,8'h0E,8'h00,8'h00,8'h00,8'hFE,8'hED,8'hEF};
                2'b01: uart_data<={8'h7E,8'hFF,8'h06,8'h0E,8'h00,8'h00,8'h00,8'hFE,8'hED,8'hEF};
                default: uart_data<=80'd0;
            endcase
            uart_tx_en<=1'b1;
            cnt<=2'd1;
        end
        else if (AnyToBeginning) 
        begin
            uart_data<={8'h7E,8'hFF,8'h06,8'h0E,8'h00,8'h00,8'h00,8'hFE,8'hED,8'hEF};
            uart_tx_en<=1'b1;
            cnt<=2'd1;
        end
        else
        begin
            if(cnt==2'd1)
            begin
                uart_data<=uart_data;
                uart_tx_en<=uart_tx_en;
                cnt<=2'd0;
            end
            else
            begin
                uart_data<=80'd0;
                uart_tx_en<=1'b0;
                cnt<=2'd0;
            end
        end

               // uart_data<={8'h7E,8'hFF,8'h06,8'h06,8'h00,8'h00,8'h0F,8'hFE,8'hE6,8'hEF};         
        end
endmodule