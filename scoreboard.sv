

class Scorebaord #(parameter DSIZE = 8);

    mailbox WMbx, RMbx;
    bit[DSIZE-1:0] wdata, rdata;

    function new ( mailbox WMbx, RMbx);
     this.WMbx = WMbx;
     this.RMbx = RMbx;
    endfunction

// This is just helping task to get access to mailbox data.
// It just prints the mailbox content in the screen.
// It does not delete the mailbox content.
    task printMbxContent (input mailbox mbx, string message);
      int mbxElements;
      bit[DSIZE-1:0] mbxData;
      byte q[$];
      mbxElements = mbx.num();
      for (int i=0; i<mbxElements; i++) begin
        mbx.get(mbxData);
        q.push_back(mbxData);
      end
      $write ("%s ", message);
      foreach (q[i]) begin
        $write("%b ", q[i]);
        mbx.put(q[i]);
      end
      $display(" ");
    endtask

// Compares the write data with the read data
    task compareData;
      $display("\n  %0t: INFO: Scoreboard.Compare task, Start Comparing...", $time);
      WMbx.get(this.wdata);
      RMbx.get(this.rdata);
      if (wdata == rdata)
       $display ("  %0t: INFO: Scoreboard: P A S S: Read and Write data are the SAME: %b==%b", $time, this.rdata,this.wdata );
      else
         $display ("  %0t: INFO: Scoreboard: <><><> F A I L: Read and Write data are Different: (R)%b==(W)%b", $time, this.rdata,this.wdata );
    endtask

endclass