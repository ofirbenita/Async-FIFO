`timescale 1ns / 1ps


module async_fifo_TB;

  parameter DATA_WIDTH = 8;

  logic [DATA_WIDTH-1:0] data_out;
  logic full;
  logic empty;
  logic [DATA_WIDTH-1:0] data_in;
  logic w_en, wclk, wrst_n;
  logic r_en, rclk, rrst_n;

  // Queue to push data_in
  logic [DATA_WIDTH-1:0] wdata_q[$], wdata;

  Async_FIFO as_fifo (wclk, wrst_n,rclk, rrst_n,w_en,r_en,data_in,data_out,full,empty);
  
initial begin 
wclk = 0 ; 
w_en = 0 ; 
wrst_n = 0 ; 
#100;
 forever begin
  #50 wclk=~wclk  ;
  end
 end
 
 initial begin 
rclk = 0 ; 
r_en = 0 ; 
rrst_n = 0 ; 
#100;
 forever begin
  #100 rclk=~rclk  ;
  end
 end
  
initial begin
  data_in=0;
#200;
data_in=1;
w_en=1;
wrst_n = 1;
rrst_n=1;
#100;
data_in=2;
#100;
data_in=3;
#100;
data_in=4;
#100;
data_in=5;
#100;
data_in=6;
#100;
data_in=7;
#100;
  data_in=8;
#100;
  data_in=9; //full flag
#100;
  r_en=1;
  #2000; 
 end
  endmodule