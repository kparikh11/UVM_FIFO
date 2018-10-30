

class Driver #(parameter DSIZE = 8);

    rand logic [DSIZE-1:0] wdata;
    virtual fifoPorts itf;
    mailbox WMbx, RMbx;
//constraint limit_data {wdata > 0;
//                       wdata < 15;}

    function new (virtual fifoPorts itf);
      this.itf  = itf;
      this.WMbx = WMbx;
      this.RMbx = RMbx;
    endfunction

// Enables FIFO write port, waits for 4 clock posedges and resets FIFO.
    task writeReset ();
      $display("%0t: INFO: Driver - writeRESET task", $time);
      itf.wrst_n <= 1'b0;
      itf.winc   <= 1'b0;
      repeat (4)
      begin
          @(posedge itf.wclk);		
      end
      itf.wrst_n <= 1'b1;
      $display("%0t: INFO: Driver: END - writeRESET task", $time);
    endtask
 
    task readReset ();
      $display("%0t: INFO: Driver - readRESET task", $time);
      this.itf.rrst_n = 1'b0;
      this.itf.rinc = 1'b0;
      repeat (4)
       @ (posedge itf.rclk)
      itf.rrst_n = 1'b1;
      $display("%0t: INFO: Driver: END readRESET task", $time);
    endtask

// FIFO write task, takes the class write data and assigns to interface wdata.
// It also takes as argument the number of writes to FIFO.
// Also it can put the write data in FIFO for future comparision with read data.
    task Write (input int putInMbx, input int writeNumber);
      int i=0;
      $display("%0t: INFO:Driver.Write task, Start Writing...writeNumber=%0d", $time, writeNumber);
      do
        begin   
         this.itf.winc = 1'b1;
         this.itf.wdata = this.wdata;
           if (putInMbx)
           begin
            this.WMbx.put(this.wdata);     
         end
           @(posedge itf.wclk)
           i++;
        end
      while (i < writeNumber); 
      this.itf.winc = 1'b0;
      $display("%0t: INFO:Driver.Write task, END Writing", $time);
    endtask

// Reads data from FIFO.
// It has an argument the number of reads i.e. how many times to read from the FIFO.
// Also it can put the read data in mailbox for comparision.
    task Read (input int putInMbx, input int readNumber);
      int i=0;
      $display("%0t: INFO:Driver.Read task, Start Reading...readNumber=%0d", 		$time, readNumber);
      do
        begin   
         this.itf.rinc = 1'b1;
          if (putInMbx)
            this.RMbx.put(this.itf.rdata);     
            @(posedge itf.rclk);
            i++;
        end
      while (i < readNumber); 
      this.itf.rinc = 1'b0;     
      $display("%0t: INFO:Driver.Read task: END Reading", $time);
    endtask

endclass