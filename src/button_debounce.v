`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/06/28 15:34:13
// Design Name: 
// Module Name: button_debounce
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


module button_debounce(
    input clk, button_in,
    output reg light
    );
        
    reg button, btemp;
    
    always @(posedge clk) begin
        {button,btemp} <= {btemp,button_in};
    end

    wire bpressed;
    debounce d1(.clk(clk), .bounce(button), .signal(bpressed));

    reg old_bpressed;

    always @(posedge clk) begin
        if (old_bpressed == 0 && bpressed == 1) light <= 1;
        else light <= 0;

        old_bpressed <= bpressed;
    end
endmodule
