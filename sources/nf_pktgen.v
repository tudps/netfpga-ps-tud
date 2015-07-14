`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: TU Darmstadt, Fachgebiet PS
// Engineer: Leonhard Nobach
// 
// Create Date: 16.06.2015 14:05:53
// Design Name: 
// Module Name: nf_pktgen
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Additional Comments: Simple packet generator network function
// 
//////////////////////////////////////////////////////////////////////////////////




module nf_pktgen
#(

    parameter SRC_MAC = 48'h3ca9f457afde,
    parameter DST_MAC = 48'h3ca9f457aade,
    parameter ETH_TYPE = 16'h0800,      //IPv4
    parameter PAYLOAD = 64'hf00d_face_d066_f00d
    
    //We use Ethernet II

)(

    //Defined by the AXI Stream interface

    input clk156,

    //Tx
    output s_axis_tx_tvalid,
    input s_axis_tx_tready,
    
    output [63:0] s_axis_tx_tdata,
    output [7:0] s_axis_tx_tkeep,
    output s_axis_tx_tlast,
    output [0:0] s_axis_tx_tuser,
    
    output [7:0] tx_ifg_delay,
    
    //Configuration-defined
    
    output [79:0] mac_tx_configuration_vector,
    output [79:0] mac_rx_configuration_vector,
    input [1:0] mac_status_vector,
    
    
    //User-defined
    input reset
    
    );
    
    reg [25:0] c;      //Internal counter: 156,25MHz / 2^25 = 4,656 Hz: Packet sending frequency.
    reg [31:0] packet_c;
    
    wire [63:0] s_axis_tx_tdata_rev;
    
    assign tx_ifg_delay[7:0] = 8;//TODO is this right?
                                        
    assign {s_axis_tx_tdata[7:0],
                                            s_axis_tx_tdata[15:8],
                                            s_axis_tx_tdata[23:16],
                                            s_axis_tx_tdata[31:24],
                                            s_axis_tx_tdata[39:32],
                                            s_axis_tx_tdata[47:40],
                                            s_axis_tx_tdata[55:48],
                                            s_axis_tx_tdata[63:56]} = s_axis_tx_tdata_rev;    
    
    assign s_axis_tx_tuser = 1'b0;
    
    always @(posedge clk156)
    begin    
        if (reset) 
        begin
            c <= 26'b0;
            packet_c <= 32'b0;
        end
        
        if (c==4) packet_c <= packet_c+1;    
        if ((c==0) & s_axis_tx_tready | ! (c==0)) c <= c+1;

    end
    
        
        assign s_axis_tx_tdata_rev = (c==0)?{SRC_MAC,DST_MAC[47:32]}:
                                    (c==1)?{DST_MAC[31:0],ETH_TYPE,PAYLOAD[63:48]}:
                                    (c==2)?{PAYLOAD[47:0],packet_c[31:16]}:
                                    (c==3)?{packet_c[15:0],48'b0}:
                                    64'b0;
        assign s_axis_tx_tkeep = (c==0|c==1|c==2)?8'hFF:(c==3)?8'b011:8'b0;
        assign s_axis_tx_tlast = (c==3);
        assign s_axis_tx_tvalid = (c==0|c==1|c==2|c==3);
  
// For configuration of the vectors below, please consider http://www.xilinx.com/support/documentation/ip_documentation/axi_10g_ethernet/v2_0/pg157-axi-10g-ethernet.pdf , Page 30: "10G Ethernet MAC Configuration and Status Signals"
        
    //Tx Configuration
    assign mac_tx_configuration_vector [79:32] = SRC_MAC;  
    assign mac_tx_configuration_vector [30:16] = 1518;
    assign mac_tx_configuration_vector [14] = 0; 
    assign mac_tx_configuration_vector [10] = 0; 
    assign mac_tx_configuration_vector [9] = 0;            
    assign mac_tx_configuration_vector [8] = 0;            
    assign mac_tx_configuration_vector [7] = 0;            
    assign mac_tx_configuration_vector [5] = 0;             
    assign mac_tx_configuration_vector [4] = 1;             
    assign mac_tx_configuration_vector [3] = 0;             
    assign mac_tx_configuration_vector [2] = 1;            
    assign mac_tx_configuration_vector [1] = 1;             
    assign mac_tx_configuration_vector [0] = 0;            
    
    
    //Tx Configuration
    assign mac_rx_configuration_vector [79:32] = SRC_MAC; 
    assign mac_rx_configuration_vector [30:16] = 1518;     
    assign mac_rx_configuration_vector [14] = 0;           
    assign mac_rx_configuration_vector [10] = 0;           
    assign mac_rx_configuration_vector [9] = 1;             
    assign mac_rx_configuration_vector [8] = 1;            
    assign mac_rx_configuration_vector [7] = 0;             
    assign mac_rx_configuration_vector [5] = 0;            
    assign mac_rx_configuration_vector [4] = 1;            
    assign mac_rx_configuration_vector [3] = 0;             
    assign mac_rx_configuration_vector [2] = 1;
    assign mac_rx_configuration_vector [1] = 1;
    assign mac_rx_configuration_vector [0] = 0;
    
    
    
    
    //Unused bits to 0
    assign mac_tx_configuration_vector [31] = 1'b0;
    assign mac_tx_configuration_vector [15] = 1'b0;
    assign mac_tx_configuration_vector [13:11] = 3'b0;
    assign mac_tx_configuration_vector [6] = 1'b0; 

    assign mac_rx_configuration_vector [31] = 1'b0;
    assign mac_rx_configuration_vector [15] = 1'b0;
    assign mac_rx_configuration_vector [13:11] = 3'b0;
    assign mac_rx_configuration_vector [6] = 1'b0; 
    
    
    
endmodule














