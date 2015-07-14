`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: TU Darmstadt, Fachgebiet PS
// Engineer: Leonhard Nobach
// 
// Create Date: 20.05.2015 16:57:28
// Design Name: 
// Module Name: TopLevelModule
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
//
// Additional Comments: TUD PS base platform for the NetFPGA SUME
// 
//////////////////////////////////////////////////////////////////////////////////


module TopLevelModule(

input FPGA_SYSCLK_N,
input FPGA_SYSCLK_P,

input ETH1_TX_P,
output ETH1_RX_P,
input ETH1_TX_N,
output ETH1_RX_N,
input ETH2_TX_P,
output ETH2_RX_P,
input ETH2_TX_N,
output ETH2_RX_N,
//output ETH3_TX_P,
//input ETH3_RX_P,
//output ETH3_TX_N,
//input ETH3_RX_N,
//output ETH4_TX_P,
//input ETH4_RX_P,
//output ETH4_TX_N,
//input ETH4_RX_N,

input SFP_CLK_P,    //Should be 156.25 MHz, according to the SUME master constraints and as required by the XAUI. So can we use it for the XAUI?
input SFP_CLK_N,

//SFP Specialties
output [1:0] ETH1_LED,
input ETH1_MOD_DETECT,
//inout [1:0] ETH1_RS,
input ETH1_RX_LOS,
output ETH1_TX_DISABLE,
input ETH1_TX_FAULT,

output [1:0] ETH2_LED,
input ETH2_MOD_DETECT,
//inout [1:0] ETH2_RS,
input ETH2_RX_LOS,
output ETH2_TX_DISABLE,
input ETH2_TX_FAULT,

//input [1:0] ETH3_LED,
input ETH3_MOD_DETECT,
//inout [1:0] ETH3_RS,
input ETH3_RX_LOS,
//output ETH3_TX_DISABLE,
input ETH3_TX_FAULT,

//input [1:0] ETH4_LED,
input ETH4_MOD_DETECT,
//inout [1:0] ETH4_RS,
input ETH4_RX_LOS,
//output ETH4_TX_DISABLE,
input ETH4_TX_FAULT,

input [0:0] BTN

    );
    
      wire clk156;  //Core clock
    
      wire reset;
      assign reset = BTN[0];    //TODO Better resetting!
    
      wire clk200;
      wire blink;
    
      //Input buffer for the FPGA Sysclk
      IBUFDS #(
            .CAPACITANCE("DONT_CARE"),
            .DIFF_TERM("FALSE"),
            .IBUF_DELAY_VALUE("0"),
            .IFD_DELAY_VALUE("AUTO"),
            .IOSTANDARD("DEFAULT")
            
            ) ibufds_fpga_sysclk (
            
            .O(clk200),
            .I(FPGA_SYSCLK_P),
            .IB(FPGA_SYSCLK_N)
      );
      
      //Drives the very slow blink clock
      blink_driver #(.REG_SIZE(25)) blink_driver_inst (
       .clk(clk156),
       .blink(blink),
       .reset(reset)
      );

      wire [535:0] pcs_pma_configuration_vector;     

      pcs_pma_conf pcs_pma_conf_inst (
          .pcs_pma_configuration_vector(pcs_pma_configuration_vector)
      );
      
      //Wires for shared logic
      
      wire eth_txusrclk;
      wire eth_txusrclk2;
      wire eth_gttxreset;
      wire eth_gtrxreset;
      wire eth_txuserrdy;
      wire eth_areset_clk156;
      wire eth_reset_couter_done;
      wire eth_qplllock;
      wire eth_qplloutclk;
      wire eth_qplloutrefclk;
      

      
      // ================ ETH 1 Logic ======
      
      //Wires for the network function
      
      wire eth1_s_axis_tx_tvalid;
      wire eth1_s_axis_tx_tready;

      wire [63:0] eth1_s_axis_tx_tdata;
      wire [7:0] eth1_s_axis_tx_tkeep;
      wire eth1_s_axis_tx_tlast;
      
      wire [7:0] eth1_pcspma_status;   //currently only for debugging
      wire [1:0] eth1_mac_status_vector;   //currently only for debugging
      wire [447:0] eth1_pcs_pma_status_vector;   //currently only for debugging
      
            
      wire [79:0] eth1_mac_tx_configuration_vector;
      wire [79:0] eth1_mac_rx_configuration_vector;

      wire [0:0] eth1_s_axis_tx_tuser;
      wire [7:0] eth1_tx_ifg_delay;
      
      wire eth1_tx_statistics_valid;
      wire eth1_rx_statistics_valid;
      
       axi_10g_ethernet_0 xge_layer_e1
              (.coreclk_out(clk156),                     //O!    a.k.a. "Core Clock"
//               .m_axis_rx_tXXXXXX                      //No Rx behavior, otherwise TODO
               .pcspma_status(eth1_pcspma_status),
               .refclk_n(SFP_CLK_N),                        //I Clock to drive the SFPs
               .refclk_p(SFP_CLK_P),                        //I Clock to drive the SFPs
               .dclk(clk156),                            //For backwards compat. we can use the same
               .reset(reset),
               .rx_statistics_valid(eth1_rx_statistics_valid),
               .rx_statistics_vector(),
               .rxn(ETH1_TX_N),                             //I
               .rxp(ETH1_TX_P),                             //I
               .s_axis_pause_tdata(16'b0),                       //TODO maybe tie this off.
               .s_axis_pause_tvalid(1'b0),          //Flow Ctrl
               .s_axis_tx_tdata(eth1_s_axis_tx_tdata),         //I AXIS XTx
               .s_axis_tx_tkeep(eth1_s_axis_tx_tkeep),         //I AXIS Tx
               .s_axis_tx_tlast(eth1_s_axis_tx_tlast),         //I AXIS Tx
               .s_axis_tx_tready(eth1_s_axis_tx_tready),       //O AXIS Tx
               .s_axis_tx_tuser(eth1_s_axis_tx_tuser),
               .s_axis_tx_tvalid(eth1_s_axis_tx_tvalid),       //I AXIS Tx
               .signal_detect(!ETH1_RX_LOS),                            //I PHY         TODO: MOD_DETECT nor LOS
               .tx_disable(ETH1_TX_DISABLE),                    //I PHY
               .tx_fault(ETH1_TX_FAULT),                        //I PHY
               .tx_ifg_delay(eth1_tx_ifg_delay),             //I AXIS Tx
               .tx_statistics_valid(eth1_tx_statistics_valid),
               .tx_statistics_vector(),
               .txn(ETH1_RX_N),
               .txp(ETH1_RX_P),
               
               .mac_tx_configuration_vector(eth1_mac_tx_configuration_vector),    //I
               .mac_rx_configuration_vector(eth1_mac_rx_configuration_vector),    //I
               .mac_status_vector(eth1_mac_status_vector),                        //I
               .pcs_pma_configuration_vector(pcs_pma_configuration_vector),   //I
               .pcs_pma_status_vector(eth1_pcs_pma_status_vector),

               
               .sim_speedup_control(1'b0), //should be tied off, but otherwise there comes an error in synthesis.
               .rx_axis_aresetn(1'b1),
               .tx_axis_aresetn(1'b1),
               
               .txusrclk_out(eth_txusrclk),
               .txusrclk2_out(eth_txusrclk2),
               .gttxreset_out(eth_gttxreset),
               .gtrxreset_out(eth_gtrxreset),
               .txuserrdy_out(eth_txuserrdy),
               .areset_datapathclk_out(eth_areset_clk156),
               .reset_counter_done_out(eth_reset_counter_done),
               .qplllock_out(eth_qplllock),
               .qplloutclk_out(eth_qplloutclk),
               .qplloutrefclk_out(eth_qplloutrefclk)
               
               );
               
       led_driver eth1_led_dr (
                .has_link(!(ETH1_MOD_DETECT | ETH1_RX_LOS | ETH1_TX_FAULT)),
                .on_frame_sent(eth1_tx_statistics_valid),
                .on_frame_received(eth1_rx_statistics_valid),
                .led(ETH1_LED),
                .blink(blink),
                .clk(clk156)
       );
      
      // ================ ETH 2 Logic ======
       
       //Wires for the network function
       

      wire eth2_s_axis_tx_tvalid;
      wire eth2_s_axis_tx_tready;

      wire [63:0] eth2_s_axis_tx_tdata;
      wire [7:0] eth2_s_axis_tx_tkeep;
      wire eth2_s_axis_tx_tlast;
      
      wire [7:0] eth2_pcspma_status;   //currently only for debugging
      wire [1:0] eth2_mac_status_vector;   //currently only for debugging
      wire [447:0] eth2_pcs_pma_status_vector;   //currently only for debugging
      
            
      wire [79:0] eth2_mac_tx_configuration_vector;
      wire [79:0] eth2_mac_rx_configuration_vector;

      wire [0:0] eth2_s_axis_tx_tuser;
      wire [7:0] eth2_tx_ifg_delay;

      wire eth2_tx_statistics_valid;
      wire eth2_rx_statistics_valid;
      
      
      wire [63:0] eth2_m_axis_rx_tdata;
      wire [7:0] eth2_m_axis_rx_tkeep;
      wire eth2_m_axis_rx_tlast;
      wire eth2_m_axis_rx_tuser;
      wire eth2_m_axis_rx_tvalid;
         
         axi_10g_ethernet_n xge_layer_e2 (
           
           .dclk(clk156),

           .areset_coreclk(eth_areset_clk156),
           .txusrclk(eth_txusrclk),
           .txusrclk2(eth_txusrclk2),
           .txuserrdy(eth_txuserrdy),
           .coreclk(clk156),
           .areset(reset),
           .gttxreset(eth_gttxreset),
           .gtrxreset(eth_gtrxreset),
           .qplllock(eth_qplllock),
           .qplloutclk(eth_qplloutclk),
           .qplloutrefclk(eth_qplloutrefclk),
           .reset_counter_done(eth_reset_counter_done),
           
           .rxp(ETH2_TX_P),
           .rxn(ETH2_TX_N),
           .txp(ETH2_RX_P),
           .txn(ETH2_RX_N),
           
           .signal_detect(!ETH2_RX_LOS),                            //I PHY         TODO: MODDEF0 nor LOS
           .tx_disable(ETH2_TX_DISABLE),                    //I PHY
           .tx_fault(ETH2_TX_FAULT),                        //I PHY
           
           .sim_speedup_control(1'b0), //should be tied off, but otherwise there comes an error in synthesis.
           .rx_axis_aresetn(1'b1),
           .tx_axis_aresetn(1'b1),
           
           .m_axis_rx_tdata(eth2_m_axis_rx_tdata),     //O AXIS Rx
           .m_axis_rx_tkeep(eth2_m_axis_rx_tkeep),     //O AXIS Rx
           .m_axis_rx_tlast(eth2_m_axis_rx_tlast),     //O AXIS Rx
           .m_axis_rx_tuser(eth2_m_axis_rx_tuser),     //O AXIS Rx
           .m_axis_rx_tvalid(eth2_m_axis_rx_tvalid),   //O AXIS Rx

           .s_axis_pause_tdata(16'b0),                       //TODO maybe tie this off.
           .s_axis_pause_tvalid(1'b0),          //Flow Ctrl
           .s_axis_tx_tdata(eth2_s_axis_tx_tdata),         //I AXIS XTx
           .s_axis_tx_tkeep(eth2_s_axis_tx_tkeep),         //I AXIS Tx
           .s_axis_tx_tlast(eth2_s_axis_tx_tlast),         //I AXIS Tx
           .s_axis_tx_tready(eth2_s_axis_tx_tready),       //O AXIS Tx
           .s_axis_tx_tuser(eth2_s_axis_tx_tuser),
           .s_axis_tx_tvalid(eth2_s_axis_tx_tvalid),       //I AXIS Tx
           
           .pcspma_status(eth2_pcspma_status),
           
           .tx_ifg_delay(eth2_tx_ifg_delay),             //I AXIS Tx
           
           .mac_tx_configuration_vector(eth2_mac_tx_configuration_vector),    //I
           .mac_rx_configuration_vector(eth2_mac_rx_configuration_vector),    //I
           .mac_status_vector(eth2_mac_status_vector),                        //I
           .pcs_pma_configuration_vector(pcs_pma_configuration_vector),       //I
           .pcs_pma_status_vector(eth2_pcs_pma_status_vector),
           
           .rx_statistics_valid(eth2_rx_statistics_valid),
           .tx_statistics_valid(eth2_tx_statistics_valid)
 
         );
         
       led_driver eth2_led_dr (
                  .has_link(!(ETH2_MOD_DETECT | ETH2_RX_LOS | ETH2_TX_FAULT)),
                  .on_frame_sent(eth2_tx_statistics_valid),
                  .on_frame_received(eth2_rx_statistics_valid),
                  .led(ETH2_LED),
                  .blink(blink),
                  .clk(clk156)
       );
       
       
       //Further interfaces may be instantiated from axi_10g_ethernet_n, as well as corresponding LED drivers.
       
         
         //======= Network Functions
         
         //Module of our future network function
         nf_pktgen nf_pktgen_eth1 (
         
             .clk156(clk156),
             .s_axis_tx_tvalid(eth1_s_axis_tx_tvalid),
             .s_axis_tx_tready(eth1_s_axis_tx_tready),
         
             .s_axis_tx_tdata(eth1_s_axis_tx_tdata),
             .s_axis_tx_tkeep(eth1_s_axis_tx_tkeep),
             .s_axis_tx_tlast(eth1_s_axis_tx_tlast),
             
             .mac_tx_configuration_vector(eth1_mac_tx_configuration_vector),
             .mac_rx_configuration_vector(eth1_mac_rx_configuration_vector),
             .mac_status_vector(eth1_mac_status_vector),
             .s_axis_tx_tuser(eth1_s_axis_tx_tuser),
             .tx_ifg_delay(eth1_tx_ifg_delay),    
             .reset(reset)
             
         );
         
         /*
         //A second packet generator on eth2
         nf_pktgen #(
             .SRC_MAC(48'h3ca9f457afde),
             .DST_MAC(48'h3ca9f457aade),
             .ETH_TYPE (16'h8864),      //PPPoE
             .PAYLOAD(64'hf000_b444_abcd_fefe)
             
         ) nf_pktgen_eth2 (
         
             .clk156(clk156),
             .s_axis_tx_tvalid(eth2_s_axis_tx_tvalid),
             .s_axis_tx_tready(eth2_s_axis_tx_tready),
         
             .s_axis_tx_tdata(eth2_s_axis_tx_tdata),
             .s_axis_tx_tkeep(eth2_s_axis_tx_tkeep),
             .s_axis_tx_tlast(eth2_s_axis_tx_tlast),
             
             .mac_tx_configuration_vector(eth2_mac_tx_configuration_vector),
             .mac_rx_configuration_vector(eth2_mac_rx_configuration_vector),
             .mac_status_vector(eth2_mac_status_vector),
             .s_axis_tx_tuser(eth2_s_axis_tx_tuser),
             .tx_ifg_delay(eth2_tx_ifg_delay),    
             .reset(reset)
             
         );
         */
         
         wire [383:0] debug_vector;
         
         nf_debug_vector nf_debug_vector_inst (
         
             .eth1_pcspma_status(eth1_pcspma_status),
             .eth1_mac_status_vector(eth1_mac_status_vector),
             .eth1_pcs_pma_status_vector(eth1_pcs_pma_status_vector),
             .eth1_board_signals({ETH1_MOD_DETECT,
             ETH1_RX_LOS,
             ETH1_TX_DISABLE,
             ETH1_TX_FAULT
             }),
             
             .eth2_pcspma_status(eth2_pcspma_status),
             .eth2_mac_status_vector(eth2_mac_status_vector),
             .eth2_pcs_pma_status_vector(eth2_pcs_pma_status_vector),
             .eth2_board_signals({ETH2_MOD_DETECT,
             ETH2_RX_LOS,
             ETH2_TX_DISABLE,
             ETH2_TX_FAULT
             }),
             
             .eth3_pcspma_status(0),
             .eth3_mac_status_vector(0),
             .eth3_pcs_pma_status_vector(0),
             .eth3_board_signals({ETH3_MOD_DETECT,
             ETH3_RX_LOS,
             1'b0,
             ETH3_TX_FAULT
             }),
             
             .eth4_pcspma_status(0),
             .eth4_mac_status_vector(0),
             .eth4_pcs_pma_status_vector(0),
             .eth4_board_signals({ETH4_MOD_DETECT,
             ETH4_RX_LOS,
             1'b0,
             ETH4_TX_FAULT
             }),
         
         
             .debug_vector(debug_vector)
            
         );
         
         nf_debug #(.SENDPULSE_REG_SIZE(27)) nf_debug_eth2 (
                  
              .clk156(clk156),
              .s_axis_tx_tvalid(eth2_s_axis_tx_tvalid),
              .s_axis_tx_tready(eth2_s_axis_tx_tready),
          
              .s_axis_tx_tdata(eth2_s_axis_tx_tdata),
              .s_axis_tx_tkeep(eth2_s_axis_tx_tkeep),
              .s_axis_tx_tlast(eth2_s_axis_tx_tlast),
              
              .mac_tx_configuration_vector(eth2_mac_tx_configuration_vector),
              .mac_rx_configuration_vector(eth2_mac_rx_configuration_vector),
              .mac_status_vector(eth2_mac_status_vector),
              .s_axis_tx_tuser(eth2_s_axis_tx_tuser),
              .tx_ifg_delay(eth2_tx_ifg_delay),
              
              .debug_vector(debug_vector),

              .m_axis_rx_tdata(eth2_m_axis_rx_tdata),
              .m_axis_rx_tkeep(eth2_m_axis_rx_tkeep),
              .m_axis_rx_tlast(eth2_m_axis_rx_tlast),
              .m_axis_rx_tuser(eth2_m_axis_rx_tuser),
              .m_axis_rx_tvalid(eth2_m_axis_rx_tvalid),
              
              .reset(reset)
                      
         );
         
         /*
         axis_tx_debug axis_tx_debug_inst(
          .clk(clk156),
          .trig_in(eth1_s_axis_tx_tvalid),
//          .trig_out(reset),
          .probe0(eth1_s_axis_tx_tdata),//64
          .probe1(eth1_s_axis_tx_tkeep),//8
          .probe2({eth1_s_axis_tx_tlast, eth1_s_axis_tx_tvalid, eth1_s_axis_tx_tready})//3
         );
         */
    
endmodule






















