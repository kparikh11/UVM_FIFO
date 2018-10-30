module fifo_mem #(parameter DATASIZE = 8, parameter ADDRSIZE = 4) // // Memory data word width, Number of mem address bits
		   (input [DATASIZE-1:0] wdata,
		    input [ADDRSIZE-1:0] waddr, raddr,
		    input wclken, wfull, wclk,
        output [DATASIZE-1:0] rdata
);

localparam DEPTH = 1<<ADDRSIZE; //it is used get a value of multiplication somehow - can't remember math right now - pretty used one - check it out
reg [DATASIZE-1:0] mem [0:DEPTH-1];
assign rdata = mem[raddr];
 
always @(posedge wclk)
	if (wclken && !wfull) 
     mem[waddr] <= wdata;
     
endmodule