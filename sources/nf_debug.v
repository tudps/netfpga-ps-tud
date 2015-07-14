`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: TU Darmstadt, Fachgebiet PS
// Engineer: Leonhard Nobach
// 
// Create Date: 06/24/2015 10:10:31 AM
// Design Name: 
// Module Name: nf_debug
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Additional Comments: Network function for debug information about the state of the cores
// 
//////////////////////////////////////////////////////////////////////////////////



module nf_debug
#(

    parameter SRC_MAC = 48'h0000_0000_d333_b006,
    parameter DST_MAC = 48'h0000_0000_d333_b006,
    parameter ETH_TYPE = 16'h1337,
    parameter SENDPULSE_REG_SIZE = 26//MUST be > 5!
    
    //We use Ethernet II

)(

    input [383:0] debug_vector,

    //Defined by the AXI Stream interface

    input clk156,
    
    //Rx
    input [63:0] m_axis_rx_tdata,
    input [7:0] m_axis_rx_tkeep,
    input m_axis_rx_tlast,
    input m_axis_rx_tuser,
    input m_axis_rx_tvalid,
    
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
    
    //Registers required to receive a packet
    reg [15:0] rcv_c = 0;
    reg pkt_valid = 0;
    reg [14:0] pkts_received = 0;
    
    reg [63:0] pkt0 = 64'b0;
    reg [63:0] pkt1 = 64'b0;
    reg [63:0] pkt2 = 64'b0;
    
    reg [383:0] debug_vector_hold;
    
    //Registers required to send a packet
    reg [SENDPULSE_REG_SIZE-1:0] c;      //Internal counter: 156,25MHz / 2^25 = 4,656 Hz: Packet sending frequency.
    reg [31:0] packet_c;
    
    wire [63:0] s_axis_tx_tdata_rev;
    wire [63:0] m_axis_rx_tdata_rev;
    
    //Transmit wires
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

    
    //Receive wires         
    assign m_axis_rx_tdata_rev = {m_axis_rx_tdata[7:0],
                                  m_axis_rx_tdata[15:8],
                                  m_axis_rx_tdata[23:16],
                                  m_axis_rx_tdata[31:24],
                                  m_axis_rx_tdata[39:32],
                                  m_axis_rx_tdata[47:40],
                                  m_axis_rx_tdata[55:48],
                                  m_axis_rx_tdata[63:56]};

    
    always @(posedge clk156)
    begin
    
        debug_vector_hold <= debug_vector;
    
        if (reset) 
        begin
                rcv_c <= 16'b0;
                pkts_received <= 32'b0;
                pkt_valid <= 1'b0;
        end
    
        //Receive packets
        if (m_axis_rx_tvalid)
        begin
          rcv_c <= rcv_c + 1;
          if (rcv_c == 0) pkt0 <= m_axis_rx_tdata_rev;
          if (rcv_c == 1) pkt1 <= m_axis_rx_tdata_rev;
          if (rcv_c == 2) pkt2 <= m_axis_rx_tdata_rev;
        end
        
        if (m_axis_rx_tlast)
        begin
          rcv_c <= 0;
          pkt_valid <= m_axis_rx_tuser;
          pkts_received <= pkts_received + 1;
        end
        
        
    
        //Sending counter
        if (reset) 
        begin
            c <= 0;
            packet_c <= 32'b0;
        end
        
        if (c==4) packet_c <= packet_c+1;    
        if ((c==0) & s_axis_tx_tready | ! (c==0)) c <= c+1;

    end
    
        
        assign s_axis_tx_tdata_rev = (c==0)?{SRC_MAC,DST_MAC[47:32]}:
                                    (c==1)?{DST_MAC[31:0],ETH_TYPE,pkt_valid,pkts_received}:
                                    (c==2)?pkt0:
                                    (c==3)?pkt1:
                                    (c==4)?pkt2:
                                    (c==5)?debug_vector_hold[383:320]:
                                    (c==6)?debug_vector_hold[319:256]:
                                    (c==7)?debug_vector_hold[255:192]:
                                    (c==8)?debug_vector_hold[191:128]:
                                    (c==9)?debug_vector_hold[127:64]:
                                    (c==10)?debug_vector_hold[63:0]:
                                    64'b0;
        assign s_axis_tx_tkeep = (c>=0 && c<=10)?8'hFF:8'b0;
        assign s_axis_tx_tlast = (c==10);
        assign s_axis_tx_tvalid = (c>=0 && c<=10);
  
        
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
