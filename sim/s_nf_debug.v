`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: TU Darmstadt, Fachgebiet PS
// Engineer: Leonhard Nobach
// 
// Create Date: 06/24/2015 11:22:36 AM
// Design Name: 
// Module Name: s_nf_debug
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Additional Comments: Testbench for the debugging network function
// 
//////////////////////////////////////////////////////////////////////////////////

module s_nf_debug(

    );
    
    reg clk156;
    reg reset;
    reg s_axis_tx_tready;
    wire s_axis_tx_tvalid;
    wire [63:0] s_axis_tx_tdata;
    wire [7:0] s_axis_tx_tkeep;
    wire s_axis_tx_tlast;
    
    reg [63:0] m_axis_rx_tdata;
    reg [7:0] m_axis_rx_tkeep = 0;
    reg m_axis_rx_tlast = 0;
    reg m_axis_rx_tuser = 0;
    reg m_axis_rx_tvalid = 0;
    
    nf_debug #(.SENDPULSE_REG_SIZE(10)) dut (
    .clk156(clk156),
    .reset(reset),
    .s_axis_tx_tvalid(s_axis_tx_tvalid),
    .s_axis_tx_tready(s_axis_tx_tready),
    .s_axis_tx_tdata(s_axis_tx_tdata),
    .s_axis_tx_tkeep(s_axis_tx_tkeep),
    .s_axis_tx_tlast(s_axis_tx_tlast),
    
    .debug_vector(384'hf00f_f00f_f000_face_cafe_d066_f00d),
    
    .m_axis_rx_tdata(m_axis_rx_tdata),
    .m_axis_rx_tkeep(m_axis_rx_tkeep),
    .m_axis_rx_tlast(m_axis_rx_tlast),
    .m_axis_rx_tuser(m_axis_rx_tuser),
    .m_axis_rx_tvalid(m_axis_rx_tvalid)
    
    
    );
    
    initial
    begin
        clk156 = 0;
        reset = 0;
        s_axis_tx_tready = 0;
        
        #10 reset = 1;
        #20 reset = 0;
        
        #100 m_axis_rx_tdata = 64'hf00f_0000_d066_f00d;
        m_axis_rx_tvalid = 1;
        m_axis_rx_tkeep = 8'hFF;
        #10 m_axis_rx_tdata = 64'hf00d_0001_f00d_f00d;
        #10 m_axis_rx_tdata = 64'hf00f_0002_d066_f00d;
        #10 m_axis_rx_tdata = 64'hf00f_0003_d066_f00d;
        #10 m_axis_rx_tvalid = 0;
        m_axis_rx_tkeep = 8'h00;
        
        
        #10 m_axis_rx_tdata = 64'hf00f_0004_d066_f00d;
        m_axis_rx_tvalid = 1;
        m_axis_rx_tkeep = 8'hFF;
        m_axis_rx_tlast = 1;
        m_axis_rx_tuser = 1;
        
        #10 m_axis_rx_tvalid = 0;
        m_axis_rx_tlast = 0;
        m_axis_rx_tuser = 0;
        
        
        
        #500 s_axis_tx_tready = 1;
        #60 s_axis_tx_tready = 0;
        
        
        
        
        
        
        #8000 m_axis_rx_tdata = 64'hf00f_0100_d066_f00d;
        m_axis_rx_tvalid = 1;
        m_axis_rx_tkeep = 8'hFF;
        #10 m_axis_rx_tdata = 64'hf00d_0101_f00d_f00d;
        #10 m_axis_rx_tdata = 64'hf00f_0102_d066_f00d;
        #10 m_axis_rx_tdata = 64'hf00f_0103_d066_f00d;
        #10 m_axis_rx_tvalid = 0;
        m_axis_rx_tkeep = 8'h00;
                
                
        #10 m_axis_rx_tdata = 64'hf00f_0104_d066_f00d;
        m_axis_rx_tvalid = 1;
        m_axis_rx_tkeep = 8'hFF;
        m_axis_rx_tlast = 1;
        m_axis_rx_tuser = 1;
                
        #10 m_axis_rx_tvalid = 0;
        m_axis_rx_tlast = 0;
        m_axis_rx_tuser = 0;
        
        
        
        
        
        
        #3000 s_axis_tx_tready = 1;
        #80 s_axis_tx_tready = 0;
        
    end
    
    always 
        #5  clk156 =  ! clk156;
    
endmodule
