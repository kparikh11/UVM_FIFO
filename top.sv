`include "env.sv"
 import fifo_params::*;

module top();

///////////////////////////////////////////////////// 
// Input/output interface instance                 // 
///////////////////////////////////////////////////// 
fifoPorts  #(DSIZE) itf();

///////////////////////////////////////////////////// 
// Envirometn instance                             // 
///////////////////////////////////////////////////// 
Environment env;

///////////////////////////////////////////////////// 
// Program block Testcase instance                 // 
///////////////////////////////////////////////////// 
run         r0 (itf.TB, wclk, rclk); 

///////////////////////////////////////////////////// 
// DUT instance and signal connection              // 
/////////////////////////////////////////////////////
fifo_top    i0 (itf.DUT);

endmodule