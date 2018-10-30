`timescale 1ns/1ps

package fifo_params;
  parameter DSIZE = 8;
  parameter ADDRSIZE = 4;
  parameter DEPTH = 1<<ADDRSIZE;
endpackage : fifo_params