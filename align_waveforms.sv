`timescale 1ns/1ps

module tb();
  reg clk;
  reg rst;
  
  reg clk50;
  reg clk25;
  
  
  initial begin
    clk = 1'b0;
    rst = 1'b0;
    clk50 = 1'b0;
    clk25 = 1'b0;
    
  end
  
  always #5 clk = ~clk; 
  always begin
   #5;
   clk50 = 1'b1;
    #10
    clk50 = 1'b0;
    #5
    clk50 = 1'b1;
    
  end
   always begin
   #5;
   clk25 = 1'b1;
    #20
    clk25 = 1'b0;
    #15
    clk25 = 1'b1;
    
  end
  
   initial begin
    $dumpfile("dump.vcd");
    $dumpvars;
  end
 
 
  initial begin
    #200;
    $finish();
  end
  
endmodule
