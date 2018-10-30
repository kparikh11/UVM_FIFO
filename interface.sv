interface fifoPorts #(parameter DSIZE = 8);
	logic wclk;
	logic rclk ;
	logic [DSIZE-1:0] rdata;
	logic wfull;
	logic rempty;
	logic [DSIZE-1:0] wdata;
	logic winc, wrst_n;
	logic rinc, rrst_n;

	modport TB ( output wdata, winc, wrst_n, rinc, rrst_n, wclk, rclk,
               input rdata, wfull, rempty);
				
	modport DUT ( output rdata, wfull, rempty,
                input wclk, wdata, rclk, winc, wrst_n, rinc, rrst_n);
	
    ERROR_FULL0_ON_WRESET:
        assert property (@(posedge wclk)
        (!wrst_n |->
        (wfull==0)));
    
    ERROR_EMPTY1_ON_RRESET:
        assert property (@(posedge rclk)
        (!rrst_n |->
        (rempty==1))); 
                
    endinterface