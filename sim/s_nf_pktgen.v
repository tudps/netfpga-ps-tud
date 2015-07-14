`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: TU Darmstadt, Fachgebiet PS
// Engineer: Leonhard Nobach
// 
// Create Date: 16.06.2015 21:24:10
// Design Name: 
// Module Name: s_nf_pktgen
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Additional Comments: Testbench for the packet generator network function
// 
//////////////////////////////////////////////////////////////////////////////////

/*
    input clk156,
output s_axis_tx_tvalid,
input s_axis_tx_tready,

output s_axis_tx_tdata[63:0],
output s_axis_tx_tkeep[7:0],
output s_axis_tx_tlast,

output tx_ifg_delay[7:0],

*/

module s_nf_pktgen(

    );
    
    reg clk156;
    reg reset;
    reg s_axis_tx_tready;
    wire s_axis_tx_tvalid;
    wire [63:0] s_axis_tx_tdata;
    wire [7:0] s_axis_tx_tkeep;
    wire s_axis_tx_tlast;
    
    nf_pktgen dut(
    .clk156(clk156),
    .reset(reset),
    .s_axis_tx_tvalid(s_axis_tx_tvalid),
    .s_axis_tx_tready(s_axis_tx_tready),
    .s_axis_tx_tdata(s_axis_tx_tdata),
    .s_axis_tx_tkeep(s_axis_tx_tkeep),
    .s_axis_tx_tlast(s_axis_tx_tlast)
    );
    
    initial
    begin
        clk156 = 0;
        reset = 0;
        s_axis_tx_tready = 0;
        
        #10 reset = 1;
        #20 reset = 0;
        
        #100 s_axis_tx_tready = 1;
        #60 s_axis_tx_tready = 0;
        
        #43000000 s_axis_tx_tready =1;
        #60 s_axis_tx_tready = 0;
        
    end
    
    always 
        #5  clk156 =  ! clk156;
    
endmodule






