
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.ALL;


entity FIFO_memory is
port (
wdata : in STD_LOGIC_VECTOR (7 downto 0);
waddr : in STD_LOGIC_VECTOR (3 downto 0);
raddr : in STD_LOGIC_VECTOR (3 downto 0);
wclk : in STD_LOGIC;
rclk : in STD_LOGIC;
wclken : in STD_LOGIC;
rclken : in STD_LOGIC;
rdata : out STD_LOGIC_VECTOR (7 downto 0));

end FIFO_memory;

architecture Behavioral of FIFO_memory is
type memory is array (0 to 15) of std_logic_vector(7 downto 0 );
begin
process ( wclk,rclk)
variable mem : memory := (others => x"00");
variable w_index : integer range 0 to 15 := to_integer (unsigned(waddr));
variable r_index : integer range 0 to 15 := to_integer (unsigned(raddr));
begin
if wclken = '1' then 
mem(w_index) := wdata ;
end if;
if rclken ='1' then 
rdata <= mem(r_index);
end if;
end process;
end Behavioral;
