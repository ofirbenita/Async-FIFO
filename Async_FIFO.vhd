
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity Async_FIFO is
port ( 
 wdata : in STD_LOGIC_VECTOR (7 downto 0);
 wen : in STD_LOGIC;
 wclk : in STD_LOGIC;
 rclk : in STD_LOGIC;
 wrst : in STD_LOGIC;
 rrst : in STD_LOGIC;
 ren : in STD_LOGIC;
 rdata : out STD_LOGIC_VECTOR (7 downto 0);
 wfull : buffer STD_LOGIC;
 rempty : buffer STD_LOGIC);

end Async_FIFO;

architecture Behavioral of Async_FIFO is
component FIFO_memory is
port (
wdata : in STD_LOGIC_VECTOR (7 downto 0);
waddr : in STD_LOGIC_VECTOR (3 downto 0);
raddr : in STD_LOGIC_VECTOR (3 downto 0);
wclk : in STD_LOGIC;
rclk : in STD_LOGIC;
wclken : in STD_LOGIC;
rclken : in STD_LOGIC;
rdata : out STD_LOGIC_VECTOR (7 downto 0));

end component;

component W_PTR is


port (
 wq2_rptr : in STD_LOGIC_VECTOR (4 downto 0);
 wen : in STD_LOGIC;
 wclk : in STD_LOGIC;
 wrst : in STD_LOGIC;
 wfull : buffer STD_LOGIC;
 waddr : out STD_LOGIC_VECTOR (3 downto 0);
 wptr : out STD_LOGIC_VECTOR (4 downto 0));

end component;

 component R_PTR is


port (
rq2_wptr : in STD_LOGIC_VECTOR (4 downto 0);
ren : in STD_LOGIC;
rclk : in STD_LOGIC;
rrst : in STD_LOGIC;
rempty : buffer STD_LOGIC;
raddr : out STD_LOGIC_VECTOR (3 downto 0);
rptr : out STD_LOGIC_VECTOR (4 downto 0));

end component ;


component sync_wr2rd is
port ( 
wptr : in STD_LOGIC_VECTOR (4 downto 0);
rq2_wptr : out STD_LOGIC_VECTOR (4 downto 0);
rclk : in STD_LOGIC;
rrst : in STD_LOGIC);

end component ;

component sync_rd2wr is
port (
rptr : in STD_LOGIC_VECTOR (4 downto 0);
wq2_rptr : out STD_LOGIC_VECTOR (4 downto 0);
wclk : in STD_LOGIC;
wrst : in STD_LOGIC);

end component ;
 signal waddr_sig :  STD_LOGIC_VECTOR (3 downto 0);
 signal wptr_sig :  STD_LOGIC_VECTOR (4 downto 0);
 signal raddr_sig :  STD_LOGIC_VECTOR (3 downto 0);
 signal rptr_sig :  STD_LOGIC_VECTOR (4 downto 0);
 signal wq2_rptr_sig :  STD_LOGIC_VECTOR (4 downto 0);
 signal rq2_wptr_sig :  STD_LOGIC_VECTOR (4 downto 0);
 signal wclken_sig :std_logic ;
 signal rclken_sig :std_logic ;



begin

write_ptr : w_ptr port map ( wen=>wen,wclk=>wclk,wrst=>wrst,wfull=>wfull,waddr=>waddr_sig,wptr=>wptr_sig,wq2_rptr=>wq2_rptr_sig);
read_ptr : r_ptr port map ( ren=>ren,rclk=>rclk,rrst=>rrst,rempty=>rempty,raddr=>raddr_sig,rptr=>rptr_sig,rq2_wptr=>rq2_wptr_sig);
sync_write_to_read : sync_wr2rd port map (wptr=>wptr_sig,rclk=>rclk,rrst=>rrst,rq2_wptr=>rq2_wptr_sig);
sync_read_to_write : sync_rd2wr port map (rptr=>rptr_sig,wclk=>wclk,wrst=>wrst,wq2_rptr=>wq2_rptr_sig);
memory : fifo_memory port map (wdata=>wdata,waddr=>waddr_sig,raddr=>raddr_sig,rclk=>rclk,wclk=>wclk,wclken=>wclken_sig,rclken=>rclken_sig,rdata=>rdata );
wclken_sig <= wen and not (wfull) ;
rclken_sig <= ren and not (rempty) ;





end Behavioral;
