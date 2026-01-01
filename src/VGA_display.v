`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/06/02 19:43:17
// Design Name: 
// Module Name: VGA_display
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


module VGA_display(
    input OriginalClk,      // EGO1 时钟 100MHz.
    input [11:0] Data,      // 数据输入
    output reg [3:0] R = 0, // Red 信号
    output reg [3:0] G = 0, // Green 信号
    output reg [3:0] B = 0, // Blue 信号
    output reg HSync = 0,   // 水平同步信号
    output reg VSync = 0,   // 垂直同步信号
    output reg [9:0] XPosition = 0,
    output reg [9:0] YPosition = 0
    );
    
    
    //This is a Prescaler, divide 100MHz into 25MHz.
    //Prescaler Begin.

    wire Clk;
    clk_div_33MHz clk_div_33MHz(OriginalClk, reset, Clk);

    // reg [1:0] Prescaler = 0;
    // wire Clk;
    // always@(posedge OriginalClk)
    // begin
    //     Prescaler <= Prescaler + 1;
    // end
    
    // assign Clk = Prescaler[1];

    //Prescaler End.
    
    //分辨率为 640*480
    //parameter define
    // parameter   H_SYNC    =   10'd95  ,   //行同步
    //             H_FRONT   =   10'd45   ,  //行时序前沿
    //             H_VALID   =   10'd640 ,   //行有效数据
    //             H_BACK    =   10'd20  ,   //行时序后沿
    //             H_TOTAL   =   10'd800 ;   //行扫描周期
    // parameter   V_SYNC    =   10'd2   ,   //场同步
    //             V_FRONT   =   10'd32   ,  //场时序前沿
    //             V_VALID   =   10'd480 ,   //场有效数据
    //             V_BACK    =   10'd14  ,   //场时序后沿
    //             V_TOTAL   =   10'd528 ;   //场扫描周期

    //分辨率为 800*480
    //parameter define
    parameter   H_SYNC    =   11'd30  ,   //行同步
                H_FRONT   =   11'd210  ,  //行时序前沿
                H_VALID   =   11'd800 ,   //行有效数据
                H_BACK    =   11'd16  ,   //行时序后沿
                H_TOTAL   =   11'd1056 ;  //行扫描周期
    parameter   V_SYNC    =   11'd13   ,  //场同步
                V_FRONT   =   11'd22   ,  //场时序前沿
                V_VALID   =   11'd480 ,   //场有效数据
                V_BACK    =   11'd10  ,   //场时序后沿
                V_TOTAL   =   11'd525 ;   //场扫描周期

    reg [10:0] XCount = 0;
    reg [10:0] YCount = 0;
    
    always@(posedge Clk)
    begin
        if(XCount == H_TOTAL - 1)       XCount <= 0;
        else                            XCount <= XCount + 1;
    end
    
    always@(posedge Clk) 
    begin
        if(YCount == V_TOTAL - 1)       YCount <= 0;
        else if(XCount == H_TOTAL - 1)  YCount <= YCount + 1;
    end
    
    always@(posedge Clk)
    begin
        if(XCount == H_SYNC)            HSync <= 1;
        else if(XCount == H_TOTAL - 1)  HSync <= 0;
    end
    
    always@(posedge Clk)
    begin
        if(YCount == V_SYNC)            VSync <= 1;
        else if(YCount == V_TOTAL - 1)  VSync <= 0;
    end
    
    
    wire IsInDisplayTime;
    assign IsInDisplayTime = (XCount >= H_SYNC + H_FRONT) 
                            && (XCount <= H_SYNC + H_FRONT + H_VALID) 
                            && (YCount >= V_SYNC + V_FRONT) 
                            && (YCount <= V_SYNC + V_FRONT + V_VALID);
    
    always@(posedge Clk)
    begin
        if(IsInDisplayTime)         {R[3:0], G[3:0], B[3:0]} <= Data[11:0];
        else                        {R[3:0], G[3:0], B[3:0]} <= 0;
    end
    
    
    always@(*)
    begin
        XPosition <= XCount - (H_SYNC + H_FRONT);
        YPosition <= YCount - (V_SYNC + V_FRONT);
    end
    
endmodule
