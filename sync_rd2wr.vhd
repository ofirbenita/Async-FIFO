

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity sync_rd2wr is
port (
rptr : in STD_LOGIC_VECTOR (4 downto 0);
wq2_rptr : out STD_LOGIC_VECTOR (4 downto 0);
wclk : in STD_LOGIC;
wrst : in STD_LOGIC);

end sync_rd2wr;

architecture Behavioral of sync_rd2wr is
signal wq1_wptr :  STD_LOGIC_VECTOR (4 downto 0);

begin

process(wclk,wrst)
begin 
if wrst = '1' then 
wq2_rptr <= ( others => '0');
wq1_wptr <= ( others => '0');
elsif rising_edge (wclk) then 
wq1_wptr <= rptr;
wq2_rptr <= wq1_wptr;
end if;
end process;

end Behavioral;
