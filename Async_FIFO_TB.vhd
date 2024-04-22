
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.ALL;



entity Async_FIFO_TB is
end Async_FIFO_TB;

architecture Behavioral of Async_FIFO_TB is
component  Async_FIFO is
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

end component ;

 signal wdata :  STD_LOGIC_VECTOR (7 downto 0):= (others => '0') ;
 signal wen :  STD_LOGIC := '0' ;
 signal wclk :  STD_LOGIC:= '0';
 signal rclk :  STD_LOGIC:= '0';
 signal wrst :  STD_LOGIC:= '0';
 signal rrst :  STD_LOGIC:= '0';
 signal ren :  STD_LOGIC:= '0';
 signal rdata :  STD_LOGIC_VECTOR (7 downto 0):= (others => '0');
 signal wfull :  STD_LOGIC:= '0';
 signal rempty :  STD_LOGIC:= '0';

begin

test : Async_FIFO port map (wdata=>wdata,wen=>wen,wclk=>wclk,rclk=>rclk,wrst=>wrst,rrst=>rrst,ren=>ren,rdata=>rdata,wfull=>wfull,rempty=>rempty);


process
begin
wclk<='1';
wait for 10ns;
wclk<='0';
wait for 10ns;
end process;

process
begin
rclk<='1';
wait for 20ns;
rclk<='0';
wait for 20ns;
end process;


process
begin
wdata <= x"00";
wrst<='1';
rrst<='1';
wen<='1';
ren<='1';
wait for 40ns;
--rst check
wrst<='0';
rrst<='0';
wen<='0';
ren<='0';
wait for 40ns;
--enable check

for i in 0 to 6 loop 
wen<='1';
wrst<='0';
wdata<=std_logic_vector(unsigned(wdata)+1);
wait for 20ns ;
end loop;
wen <= '0';
wait for 20 ns;
for i in 0 to 6 loop 
ren<='1';
rrst<='0';
wait for 40ns ;
end loop;
--empty flag sholud be 1 because fifo is empty

wrst<='1';
rrst<='1';
wdata <= x"00";
wait for 40ns;

for i in 0 to 15 loop 

wen<='1';
wrst<='0';
wdata<=std_logic_vector(unsigned(wdata)+1);
wait for 20ns ;
end loop;
--flag full should be 1 because fifo is full
wait ;
end process;






















end Behavioral;
