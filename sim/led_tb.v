`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: TU Darmstadt, Fachgebiet PS
// Engineer: Leonhard Nobach
// 
// Create Date: 06/23/2015 03:12:56 PM
// Design Name: 
// Module Name: led_tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Additional Comments: Testbench for the LED driver
// 
//////////////////////////////////////////////////////////////////////////////////


module led_tb();

reg clk = 1'b0;
reg has_link = 1'b0;
reg frame_sent = 1'b0;
wire [1:0] led;

wire blink;

blink_driver #(.REG_SIZE(5)) dut1 (
 .clk(clk),
 .blink(blink),
 .reset(1'b0)
);

led_driver dut2 (
 .has_link(has_link),
 .on_frame_sent(frame_sent),
 .on_frame_received(1'b0),
 .led(led),
 .blink(blink),
 .clk(clk)
);


initial
begin

#150 has_link = 1;

#37 frame_sent = 1;
#1 frame_sent = 0;

#37 frame_sent = 1;
#1 frame_sent = 0;

#37 frame_sent = 1;
#1 frame_sent = 0;

#100 frame_sent = 1;
#3 frame_sent = 0;

#20 frame_sent = 1;
#2 frame_sent = 0;

#32 frame_sent = 1;
#45 frame_sent = 0;

#3 frame_sent = 1;
#1 frame_sent = 0;

#150 has_link = 0;

#37 frame_sent = 1;
#1 frame_sent = 0;

#150 has_link = 1;

#20 frame_sent = 1;
#2 frame_sent = 0;

#32 frame_sent = 1;
#45 frame_sent = 0;

#3 frame_sent = 1;
#1 frame_sent = 0;

end

    
always #1 clk = ~clk;   


endmodule
