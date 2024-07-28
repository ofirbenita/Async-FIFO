`timescale 1ns / 1ps



module Async_FIFO
  #(parameter DEPTH=8, DATA_WIDTH=8) 
  (
  input logic wclk, wrst_n,
  input logic rclk, rrst_n,
  input logic w_en, r_en,
  input logic [DATA_WIDTH-1:0] data_in,
  output logic [DATA_WIDTH-1:0] data_out,
  output logic full, empty
);
  
  localparam PTR_WIDTH = $clog2(DEPTH);
 
  logic [PTR_WIDTH:0] g_wptr_sync, g_rptr_sync;
  logic [PTR_WIDTH:0] b_wptr, b_rptr;
  logic [PTR_WIDTH:0] g_wptr, g_rptr;

  logic [PTR_WIDTH-1:0] waddr, raddr;

  synchronizer #(PTR_WIDTH) sync_wptr (rclk, rrst_n, g_wptr, g_wptr_sync); //write pointer to read clock domain
  synchronizer #(PTR_WIDTH) sync_rptr (wclk, wrst_n, g_rptr, g_rptr_sync); //read pointer to write clock domain 
  
  wptr_handler #(PTR_WIDTH) wptr_h(wclk, wrst_n, w_en,g_rptr_sync,b_wptr,g_wptr,full);
  rptr_handler #(PTR_WIDTH) rptr_h(rclk, rrst_n, r_en,g_wptr_sync,b_rptr,g_rptr,empty);
  fifo_mem fifom(wclk, w_en, rclk, r_en,b_wptr, b_rptr, data_in,full,empty, data_out);


    
endmodule



module synchronizer
#( parameter WIDTH=3)
(
input logic clk,
input logic rst_n,
input logic [WIDTH:0] d_in,
output logic [WIDTH:0] d_out

    );
logic [WIDTH:0] q1;
always_ff@(posedge clk) 
 begin
  if (~rst_n)
    begin
     q1<=0;
     d_out<=0;
    end
    else
     q1<=d_in;
     d_out<=q1;
 end
     
endmodule


module wptr_handler
 #(parameter PTR_WIDTH=3) //FIFO depth
  (
input logic wclk, wrst_n, w_en,
input logic [PTR_WIDTH:0] g_rptr_sync,
output logic [PTR_WIDTH:0] b_wptr, g_wptr,
output logic full
);

logic [PTR_WIDTH:0] b_wptr_next , g_wptr_next;
logic wfull;
always_ff@(posedge wclk or negedge wrst_n)
begin
  if(~wrst_n)
   begin
     b_wptr<=0;
     g_wptr<=0;
     wfull<=0;
   end
   else
     b_wptr<=b_wptr_next;
     g_wptr<=g_wptr_next;
     full<=wfull;
end

assign wfull = ( ~{g_wptr_next[PTR_WIDTH:PTR_WIDTH-1],g_wptr_next[PTR_WIDTH-2:0]} == g_rptr_sync[PTR_WIDTH:0]  );

assign b_wptr_next= b_wptr + ( ~wfull && w_en  ) ;

assign g_wptr_next = {b_wptr_next[PTR_WIDTH],b_wptr_next[PTR_WIDTH:1]^b_wptr_next[PTR_WIDTH-1:0]};

endmodule




module rptr_handler 
#(parameter PTR_WIDTH=3)
 (
  input logic rclk, rrst_n, r_en,
  input logic [PTR_WIDTH:0] g_wptr_sync,
  output logic [PTR_WIDTH:0] b_rptr, g_rptr,
  output logic empty
);

  logic [PTR_WIDTH:0] b_rptr_next;
  logic [PTR_WIDTH:0] g_rptr_next;
  
  logic rempty;
always_ff@(posedge rclk or negedge rrst_n)
begin
  if(~rrst_n)
   begin
     b_rptr<=0;
     g_rptr<=0;
     empty<=1;
   end
   else
     b_rptr<=b_rptr_next;
     g_rptr<=g_rptr_next;
     empty<=rempty ; 
end

assign rempty =  { g_rptr_next == g_wptr_sync };

assign b_rptr_next = b_rptr + {~rempty && r_en};
     
assign g_rptr_next = (b_rptr_next >>1)^b_rptr_next; //Another Way To XOR Gate

  
  endmodule



module fifo_mem #(parameter DEPTH=8, DATA_WIDTH=8, PTR_WIDTH=3) (
  input logic wclk, w_en, rclk, r_en,
  input logic [PTR_WIDTH:0] b_wptr, b_rptr,
  input logic [DATA_WIDTH-1:0] data_in,
  input logic full, empty,
  output logic [DATA_WIDTH-1:0] data_out
);
 logic [DATA_WIDTH-1:0] mem [PTR_WIDTH:0] ; 
 
 always_ff@(posedge wclk , posedge rclk)
 begin
   if(w_en && ~full)
      mem[b_wptr[PTR_WIDTH-1:0]]<=data_in;
   end   
   
   always_ff@(posedge wclk , posedge rclk)
 begin
   if(r_en && ~empty)
      data_out <= mem[b_rptr[PTR_WIDTH-1:0]];
   end  

endmodule























