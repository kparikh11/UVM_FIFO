`include "interface.sv"
import fifo_params::*;

program automatic run (fifoPorts itf, input logic wclk, rclk);
  parameter ADDRSIZE = 4;
  initial begin
    $display ("<><><><><><><><><><><><><><><><> TEST PROGRAM STARTED AT %0t: ADDRSIZE = %0d", $time, ADDRSIZE);    
//  Testcase N1
    top.env = new(itf);
    $display ("<><><><><><><><><><><><><><><><> TEST N1 TESTING FIFO in sequential write/read mode", $time, ADDRSIZE);
    top.env.w_clkGen.clkGenerator("wclk",10);
    top.env.r_clkGen.clkGenerator("rclk",10);
    top.env.gen.InitDut();   
    top.env.gen.Write(1, .writeNumber(20));
    top.env.gen.Read (1, .readNumber(20));
    top.env.gen.compareData (20);
    repeat (5) @(posedge itf.wclk);
    top.env.w_clkGen.clkStop("wclk");
    top.env.r_clkGen.clkStop("rclk");
    top.env = null;

    
//  Testcase N2
    $display ("<><><><><><><><><><><><><><><><> TEST N2 TESTING FIFO in sequential write/read mode with different write/read freqs", $time, ADDRSIZE);    
    top.env = new(itf);    
    top.env.w_clkGen.clkGenerator("wclk",10);
    top.env.r_clkGen.clkGenerator("rclk",20);
    top.env.gen.InitDut();
    top.env.gen.Write(1, .writeNumber(10));
    top.env.gen.Read (1, .readNumber(10));
    top.env.gen.compareData (10);
    repeat (5) @(posedge itf.wclk);
    top.env.w_clkGen.clkStop("wclk");
    top.env.r_clkGen.clkStop("rclk");
    top.env = null;

// Testcase N3   
    $display ("<><><><><><><><><><><><><><><><> TEST N3 TESTING FIFO in parallel write/read mode", $time, ADDRSIZE);
    top.env = new(itf);    
    top.env.w_clkGen.clkGenerator("wclk",10);
    top.env.r_clkGen.clkGenerator("rclk",10);
    top.env.gen.InitDut();
    fork
    top.env.gen.Write(1, .writeNumber(10));
    join_none
    repeat (5) @(posedge itf.rclk);      
    top.env.gen.Read (1, .readNumber(10));
    @(posedge itf.rclk);
    fork
      forever begin
        @(posedge itf.rclk);
        top.env.gen.compareData (1);
      end
    join_none
    repeat (2) @(posedge itf.wclk);
    top.env.w_clkGen.clkStop("wclk");
    top.env.r_clkGen.clkStop("rclk");
    top.env = null;
    $display("<><><><><><><><><><><><><><><><> END OF TEST at %0t ", $time);

  end

  final
    $display("<><><><><><><><><><><><><><><><> END OF TEST at %0t ", $time);
endprogram