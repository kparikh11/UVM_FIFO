`include "driver.sv"
`include "scoreboard.sv"
 import fifo_params::*;

class Generator;
    
    Driver     #(DSIZE) drv;
    Scorebaord #(DSIZE) scrBrd;
    mailbox    WMbx, RMbx;
    virtual    fifoPorts itf;
    int        rw_counter;



    function new (Driver #(DSIZE) drv,Scorebaord #(DSIZE) scrBrd,virtual fifoPorts itf,  mailbox WMbx, RMbx);
      this.drv    = drv;
      this.scrBrd = scrBrd;
      this.itf    = itf;
      this.WMbx   = WMbx;
      this.RMbx   = RMbx;
    endfunction

// Initialization before write operation
    task InitDut ();
      $display("\n%0t: INFO: Generator.Config: Starting DUT Configuration...", $time);
      fork
        drv.writeReset();
        drv.readReset();
        monitor_full_empty();
      join
      $display("%0t: INFO: Generator.Config: END Write Configuration\n",$time);
    endtask

// This is high level task.
// It randomizes the driver data and order driver to write into DUT.
// It also can control how many  times driver should write data into dut.
    task Write (input int putInMbx = 1, input int writeNumber=1);
      int i=0;
      $display("%0t: INFO:Generator.Write task, \t Number of Write Data:%0d", $time, writeNumber);
        @ (negedge itf.wclk)
            drv.randomize();
      fork
        do 
          begin
          @ (negedge itf.wclk)
            begin
              drv.randomize(); 
            end
          i++;
          end
        while (i<writeNumber);
        drv.Write(putInMbx, writeNumber);
      join
      $display("%0t: Generator: Finished Writing\n",$time);
    endtask

    task Read (input int putInMbx = 1, input int readNumber=1);
      $display("%0t: INFO:Generator.Read task, \t Number of Read Data:%0d", $time, readNumber);
      drv.Read(putInMbx, readNumber);
      $display("%0t: Generator: Finished Reading\n",$time);
    endtask

// This task compares the write and read data.
    task compareData (input int runTimes=1);
      $display("\n%0t: INFO: Generator.comapreData task, \t Number of Run Times:%d", $time, runTimes);
      scrBrd.printMbxContent(this.WMbx, "WMbx data : ");
      scrBrd.printMbxContent(this.RMbx, "RMbx data : ");
      repeat (runTimes)
      scrBrd.compareData();
      $display("\n%0t: INFO: Generator: Finished Data Comparing\n",$time);
    endtask



// This task verfies FIFO full/empty signals
    task monitor_full_empty();
      fork
        gen_full();
        gen_empty();
        chk_full();
        chk_empty();
      join_none
    endtask

    task gen_full();
         forever begin 
         @(posedge this.itf.wclk)
            if (~this.itf.wrst_n)
                this.rw_counter = 0;
            else 
                if (this.itf.winc && !this.itf.wfull)
                    this.rw_counter++;
         end
    endtask

    task gen_empty();
         forever begin
         @(posedge this.itf.rclk)
            if (~this.itf.rrst_n)
                this.rw_counter = 0;
            else 
                if (this.itf.rinc && !this.itf.rempty)
                    this.rw_counter--;  
         end
    endtask

    task chk_full();
      forever begin
        @(posedge this.itf.wclk)
    //       $display("%0t: Generator:******************************************************* rw_counter = %0d" ,$time,  this.rw_counter);
            if (this.rw_counter > DEPTH -1)
                begin
                $display("%0t: Generator:******* FIFO is FULL rw_counter = %0d" ,$time,  this.rw_counter);
                @(posedge this.itf.wclk);
                if (!this.itf.wfull )
                  $display("ERROR: wfull is not asserted");
                end
      end
      
    endtask
 
    task chk_empty();
      forever begin
        @(posedge this.itf.rclk)
            if (this.rw_counter == 0)
                begin
                $display("%0t: Generator:******* FIFO is EMPTY rw_counter = %0d ",$time, this.rw_counter); 
                @(posedge this.itf.rclk);
                if (!this.itf.rempty )
                $display("ERROR: rempty is not asserted");
                end
      end
    endtask

endclass