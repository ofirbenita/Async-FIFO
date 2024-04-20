
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.ALL;



entity R_PTR is


port (
rq2_wptr : in STD_LOGIC_VECTOR (4 downto 0);
ren : in STD_LOGIC;
rclk : in STD_LOGIC;
rrst : in STD_LOGIC;
rempty : buffer STD_LOGIC;
raddr : out STD_LOGIC_VECTOR (3 downto 0);
rptr : out STD_LOGIC_VECTOR (4 downto 0));

end R_PTR;

architecture Behavioral of R_PTR is
signal r_bin,r_binext,r_gnext : std_logic_vector ( 4 downto 0 ) ;
signal rempty_sync,rempty_value : std_logic;
signal plus : unsigned ( 0 downto 0 ) ;

begin
plus <= "1" when ( ren = not rempty_sync ) 
else "0" ;
rempty <=rempty_sync;
raddr<= r_bin ( 3 downto 0 );
r_binext <= std_logic_vector( unsigned(r_bin)+1);
r_gnext <= r_binext xor ( '0' & r_binext(4 downto 1) );
rempty_value <= '1' when rq2_wptr = r_bin 
else '0' ;
process ( rclk , rrst )
begin 
  if rrst ='1' then 
  r_bin <= (others => '0' );
  rptr <= (others => '0' );
  end if;
  if rising_edge (rclk) then 
    if ren ='1' then 
  r_bin <= r_binext ;
  rptr<=r_gnext;
  rempty_sync <= rempty_value;
    end if;
 end if;
end process;  
end Behavioral;
