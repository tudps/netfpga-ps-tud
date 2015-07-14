`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: TU Darmstadt, Fachgebiet PS
// Engineer: Leonhard Nobach
// 
// Create Date: 06/24/2015 10:56:45 AM
// Design Name: 
// Module Name: nf_debug_vector
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Additional Comments: Bundles a debug vector from various input ports of the platform
// 
//////////////////////////////////////////////////////////////////////////////////


module nf_debug_vector(

    input [7:0] eth1_pcspma_status,
    input [1:0] eth1_mac_status_vector,
    input [447:0] eth1_pcs_pma_status_vector,
    input [3:0] eth1_board_signals,
    
    input [7:0] eth2_pcspma_status,
    input [1:0] eth2_mac_status_vector,
    input [447:0] eth2_pcs_pma_status_vector,
    input [3:0] eth2_board_signals,

    input [7:0] eth3_pcspma_status,
    input [1:0] eth3_mac_status_vector,
    input [447:0] eth3_pcs_pma_status_vector,
    input [3:0] eth3_board_signals,
    
    input [7:0] eth4_pcspma_status,
    input [1:0] eth4_mac_status_vector,
    input [447:0] eth4_pcs_pma_status_vector,
    input [3:0] eth4_board_signals,
    
    output [383:0] debug_vector //4*12 Byte = 4*96 Bit = 384 Bit

    );
    
assign debug_vector = {

    //1
    eth1_board_signals, //4 Bit
    eth1_mac_status_vector, //2 Bit
    2'b0,

    //2
    eth1_pcspma_status,//8 Bit

    //3
    eth1_pcs_pma_status_vector[15],
    eth1_pcs_pma_status_vector[18],
    eth1_pcs_pma_status_vector[23],
    eth1_pcs_pma_status_vector[32],
    eth1_pcs_pma_status_vector[40],
    eth1_pcs_pma_status_vector[42],
    eth1_pcs_pma_status_vector[43],
    eth1_pcs_pma_status_vector[44],
    
    //4
    eth1_pcs_pma_status_vector[45],
    eth1_pcs_pma_status_vector[47],
    eth1_pcs_pma_status_vector[48],
    5'b0,
    
    //5+6
    eth1_pcs_pma_status_vector[207:192],//16 Bit
    
    //7
    eth1_pcs_pma_status_vector[223],
    eth1_pcs_pma_status_vector[226],
    eth1_pcs_pma_status_vector[231],
    eth1_pcs_pma_status_vector[240],
    eth1_pcs_pma_status_vector[250],
    eth1_pcs_pma_status_vector[251],
    eth1_pcs_pma_status_vector[255],
    eth1_pcs_pma_status_vector[256],
    
    //8
    eth1_pcs_pma_status_vector[257],
    eth1_pcs_pma_status_vector[258],
    eth1_pcs_pma_status_vector[268],
    5'b0,
    
    //9
    eth1_pcs_pma_status_vector[279:272],//8 Bit
    
    //10
    eth1_pcs_pma_status_vector[285:280],//6 Bit
    eth1_pcs_pma_status_vector[286],
    eth1_pcs_pma_status_vector[287],
    
    //11+12
    eth1_pcs_pma_status_vector[303:288],//16 Bit
    
    
    
    //1
    eth2_board_signals, //4 Bit
    eth2_mac_status_vector, //2 Bit
    2'b0,

    //2
    eth2_pcspma_status,//8 Bit
    
    eth2_pcs_pma_status_vector[15],
    eth2_pcs_pma_status_vector[18],
    eth2_pcs_pma_status_vector[23],
    eth2_pcs_pma_status_vector[32],
    eth2_pcs_pma_status_vector[40],
    eth2_pcs_pma_status_vector[42],
    eth2_pcs_pma_status_vector[43],
    eth2_pcs_pma_status_vector[44],
    
    eth2_pcs_pma_status_vector[45],
    eth2_pcs_pma_status_vector[47],
    eth2_pcs_pma_status_vector[48],
    5'b0,
    
    eth2_pcs_pma_status_vector[207:192],//16 Bit
    
    eth2_pcs_pma_status_vector[223],
    eth2_pcs_pma_status_vector[226],
    eth2_pcs_pma_status_vector[231],
    eth2_pcs_pma_status_vector[240],
    eth2_pcs_pma_status_vector[250],
    eth2_pcs_pma_status_vector[251],
    eth2_pcs_pma_status_vector[255],
    eth2_pcs_pma_status_vector[256],
    
    eth2_pcs_pma_status_vector[257],
    eth2_pcs_pma_status_vector[258],
    eth2_pcs_pma_status_vector[268],
    5'b0,
    
    eth2_pcs_pma_status_vector[279:272],//8 Bit
    
    eth2_pcs_pma_status_vector[285:280],//6 Bit
    eth2_pcs_pma_status_vector[286],
    eth2_pcs_pma_status_vector[287],
    
    eth2_pcs_pma_status_vector[303:288],//16 Bit
    
    
    
    eth3_board_signals, //4 Bit
    eth3_mac_status_vector, //2 Bit
    2'b0,

    eth3_pcspma_status,//8 Bit

    eth3_pcs_pma_status_vector[15],
    eth3_pcs_pma_status_vector[18],
    eth3_pcs_pma_status_vector[23],
    eth3_pcs_pma_status_vector[32],
    eth3_pcs_pma_status_vector[40],
    eth3_pcs_pma_status_vector[42],
    eth3_pcs_pma_status_vector[43],
    eth3_pcs_pma_status_vector[44],
    
    eth3_pcs_pma_status_vector[45],
    eth3_pcs_pma_status_vector[47],
    eth3_pcs_pma_status_vector[48],
    5'b0,
    
    eth3_pcs_pma_status_vector[207:192],//16 Bit
    
    eth3_pcs_pma_status_vector[223],
    eth3_pcs_pma_status_vector[226],
    eth3_pcs_pma_status_vector[231],
    eth3_pcs_pma_status_vector[240],
    eth3_pcs_pma_status_vector[250],
    eth3_pcs_pma_status_vector[251],
    eth3_pcs_pma_status_vector[255],
    eth3_pcs_pma_status_vector[256],
    
    eth3_pcs_pma_status_vector[257],
    eth3_pcs_pma_status_vector[258],
    eth3_pcs_pma_status_vector[268],
    5'b0,
    
    eth3_pcs_pma_status_vector[279:272],//8 Bit
    
    eth3_pcs_pma_status_vector[285:280],//6 Bit
    eth3_pcs_pma_status_vector[286],
    eth3_pcs_pma_status_vector[287],
    
    eth3_pcs_pma_status_vector[303:288],//16 Bit
    
    
    eth4_board_signals, //4 Bit
    eth4_mac_status_vector, //2 Bit
    2'b0,

    eth4_pcspma_status,//8 Bit

    eth4_pcs_pma_status_vector[15],
    eth4_pcs_pma_status_vector[18],
    eth4_pcs_pma_status_vector[23],
    eth4_pcs_pma_status_vector[32],
    eth4_pcs_pma_status_vector[40],
    eth4_pcs_pma_status_vector[42],
    eth4_pcs_pma_status_vector[43],
    eth4_pcs_pma_status_vector[44],
    
    eth4_pcs_pma_status_vector[45],
    eth4_pcs_pma_status_vector[47],
    eth4_pcs_pma_status_vector[48],
    5'b0,
    
    eth4_pcs_pma_status_vector[207:192],//16 Bit
    
    eth4_pcs_pma_status_vector[223],
    eth4_pcs_pma_status_vector[226],
    eth4_pcs_pma_status_vector[231],
    eth4_pcs_pma_status_vector[240],
    eth4_pcs_pma_status_vector[250],
    eth4_pcs_pma_status_vector[251],
    eth4_pcs_pma_status_vector[255],
    eth4_pcs_pma_status_vector[256],
    
    eth4_pcs_pma_status_vector[257],
    eth4_pcs_pma_status_vector[258],
    eth4_pcs_pma_status_vector[268],
    5'b0,
    
    eth4_pcs_pma_status_vector[279:272],//8 Bit
    
    eth4_pcs_pma_status_vector[285:280],//6 Bit
    eth4_pcs_pma_status_vector[286],
    eth4_pcs_pma_status_vector[287],
    
    eth4_pcs_pma_status_vector[303:288]//16 Bit


}; 
    
endmodule
