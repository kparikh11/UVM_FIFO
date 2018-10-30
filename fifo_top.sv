`timescale 1ns/10ps

module fifo_top #(parameter DSIZE = 8, parameter ADDRSIZE = 4) (fifoPorts.DUT itf) ;
     
//     fifo1    #(.DSIZE(DSIZE),.ASIZE(ADDRSIZE))   i0 (
//               .rdata (itf.rdata), 
//               .wfull (itf.wfull),
//               .rempty(itf.rempty),
//               .wdata (itf.wdata),
//               .winc  (itf.winc), 
//               .wclk  (itf.wclk), 
//               .wrst_n(itf.wrst_n),
//               .rinc  (itf.rinc), 
//               .rclk  (itf.rclk), 
//               .rrst_n(itf.rrst_n)
               
               
      fifo1 #(.DSIZE (DSIZE), .ASIZE(ADDRSIZE)) i0 (
            
            .wdata (itf.wdata), .winc (itf.winc), .wclk (itf.wclk), .wrst_n (itf.wrst_n), .rinc (itf.rinc), .rclk (itf.rclk),
            .rrst_n (itf.rrst_n), .rdata (itf.rdata), .wfull (itf.wfull), .rempty (itf.rempty)

 
);

endmodule