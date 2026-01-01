`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/06/29 07:45:23
// Design Name: 
// Module Name: uart_tx
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


module uart_tx(
	input 			sys_clk,	//100M系统时钟
	input 			sys_rst_n,	//系统复位
	input	[0:79] 	uart_data,	//发送的8位置数据
	input			uart_tx_en,	//发送使能信号
	output reg 		uart_txd,	//串口发送数据线
    output reg      tx_flag    //发送标志位
);
 
parameter 	SYS_CLK_FRE=100_000_000;    //100M系统时钟 
parameter 	BPS=9600;                 //波特率115200bps，可更改
localparam	BPS_CNT=SYS_CLK_FRE/BPS;   //传输一位数据所需要的时钟个数
 
reg	uart_tx_en_d0;			//寄存1拍
reg uart_tx_en_d1;			//寄存2拍
//reg tx_flag;				//发送标志位
reg [0:79]  uart_data_reg;	//发送数据寄存器
reg [15:0] clk_cnt;			//时钟计数器
reg [7:0]  tx_cnt;			//发送个数计数器
 
wire pos_uart_en_txd;		//使能信号的上升沿
//捕捉使能端的上升沿信号，用来标志输出开始传输
assign pos_uart_en_txd= uart_tx_en_d0 && (~uart_tx_en_d1);
 
always @(posedge sys_clk)begin
	uart_tx_en_d0<=uart_tx_en;
	uart_tx_en_d1<=uart_tx_en_d0;
end
//捕获到使能端的上升沿信号，拉高传输开始标志位，并在第9个数据（终止位）的传输过程正中（数据比较稳定）再将传输开始标志位拉低，标志传输结束
always @(posedge sys_clk)begin
	if(pos_uart_en_txd)begin
		uart_data_reg<=uart_data;
		tx_flag<=1'b1;
	end
	else if((tx_cnt==8'd99) && (clk_cnt==BPS_CNT/2))begin//在第9个数据（终止位）的传输过程正中（数据比较稳定）再将传输开始标志位拉低，标志传输结束
		tx_flag<=1'b0;
		uart_data_reg<=79'd0;
	end
	else begin
		uart_data_reg<=uart_data_reg;
		tx_flag<=tx_flag;	
	end
end
//时钟每计数一个BPS_CNT（传输一位数据所需要的时钟个数），即将数据计数器加1，并清零时钟计数器
always @(posedge sys_clk)begin
	if(tx_flag) begin
		if(clk_cnt<BPS_CNT-1)begin
			clk_cnt<=clk_cnt+1'b1;
			tx_cnt <=tx_cnt;
		end
		else begin
			clk_cnt<=16'd0;
			tx_cnt <=tx_cnt+1'b1;
		end
	end
	else begin
		clk_cnt<=16'd0;
		tx_cnt<=8'd0;
	end
end
//在每个数据的传输过程正中（数据比较稳定）将数据寄存器的数据赋值给数据线
always @(posedge sys_clk)begin
	if(tx_flag)
		case(tx_cnt%10)
			8'd0:	uart_txd<=1'b0;
			8'd1:	uart_txd<=uart_data_reg[tx_cnt/10*8+7];
			8'd2:	uart_txd<=uart_data_reg[tx_cnt/10*8+6];
			8'd3:	uart_txd<=uart_data_reg[tx_cnt/10*8+5];
			8'd4:	uart_txd<=uart_data_reg[tx_cnt/10*8+4];
			8'd5:	uart_txd<=uart_data_reg[tx_cnt/10*8+3];
			8'd6:	uart_txd<=uart_data_reg[tx_cnt/10*8+2];
			8'd7:	uart_txd<=uart_data_reg[tx_cnt/10*8+1];
			8'd8:	uart_txd<=uart_data_reg[tx_cnt/10*8];
			8'd9:	uart_txd<=1'b1;			
			default:;
		endcase
	else 	
		uart_txd<=1'b1;
end
endmodule

