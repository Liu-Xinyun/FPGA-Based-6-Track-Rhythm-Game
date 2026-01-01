`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/06/28 15:26:00
// Design Name: 
// Module Name: debounce
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


module debounce(
    input clk, bounce,
    output reg signal
    );

    parameter NDELAY = 650000;
    reg [19:0] count = 0;
    reg xnew = 0;

    always @(posedge clk) begin
        if (bounce != xnew) begin
            xnew <= bounce;
            count <= 0;
        end
        else if (count == NDELAY) signal <= xnew;
        else count <= count + 1;
    end

endmodule