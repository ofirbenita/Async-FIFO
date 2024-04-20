
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;



entity sync_wr2rd is
port ( 
wptr : in STD_LOGIC_VECTOR (4 downto 0);
rq2_wptr : out STD_LOGIC_VECTOR (4 downto 0);
rclk : in STD_LOGIC;
rrst : in STD_LOGIC);

end sync_wr2rd;

architecture Behavioral of sync_wr2rd is
signal rq1_wptr :  STD_LOGIC_VECTOR (4 downto 0);

begin

process(rclk,rrst)
begin 
if rrst = '1' then 
rq2_wptr <= ( others => '0');
rq1_wptr <= ( others => '0');
elsif rising_edge (rclk) then 
rq1_wptr <= wptr;
rq2_wptr <= rq1_wptr;
end if;
end process;
end Behavioral;
