`include "interface.sv"
`include "gen.sv"
`include "clkGen.sv"
`include "driver.sv"

 import fifo_params::*;

class Environment;
  virtual fifoPorts itf;
  Generator      gen;
  clockGenerator w_clkGen,r_clkGen; 
  Driver         #(DSIZE) drv;
  Scorebaord     #(DSIZE) scrBrd;
  mailbox        wmbx, rmbx;

    function new(virtual fifoPorts itf);  
      this.itf  = itf;
      w_clkGen  = new(itf);
      r_clkGen  = new(itf);
      wmbx      = new();
      rmbx      = new();
      drv       = new(itf, wmbx, rmbx);
      scrBrd    = new(wmbx, rmbx);
      gen       = new(drv,scrBrd, itf, wmbx, rmbx);
    endfunction

endclass