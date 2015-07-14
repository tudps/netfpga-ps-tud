`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: TU Darmstadt, Fachgebiet PS
// Engineer: Leonhard Nobach
//
// Create Date: 06/23/2015 03:01:35 PM
// Design Name: 
// Module Name: blink_driver
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
//
// Additional Comments: Creates a very slow blink clock that is used by LED drivers
// 
//////////////////////////////////////////////////////////////////////////////////


module blink_driver #(

    parameter REG_SIZE = 25
    
    //200 MHz / 2^25 = 5,96 Hz > Blink frequency

 )(
    input clk,
    output blink,
    input reset
);
    
reg[REG_SIZE-1:0] c = 0;

always @(posedge clk) c <= reset?0:c+1;

assign blink = c[REG_SIZE-1];



    
endmodule


















