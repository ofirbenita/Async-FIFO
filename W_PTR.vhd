
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.ALL;

entity W_PTR is


port (
 wq2_rptr : in STD_LOGIC_VECTOR (4 downto 0);
 wen : in STD_LOGIC;
 wclk : in STD_LOGIC;
 wrst : in STD_LOGIC;
 wfull : buffer STD_LOGIC;
 waddr : out STD_LOGIC_VECTOR (3 downto 0);
 wptr : out STD_LOGIC_VECTOR (4 downto 0));

end W_PTR;

architecture Behavioral of W_PTR is
signal w_bin,w_binext,w_gnext : std_logic_vector(4 downto 0);
signal wfull_sync,wfull_value : std_logic;
signal plus : unsigned(0 downto 0 ) ;
begin
plus <= "1" when ( wen = not wfull_sync ) 
else "0" ;
wfull <= wfull_sync;
waddr <= w_bin (3 downto 0 );
w_binext<=std_logic_vector ( unsigned(w_bin) + plus ) ;
w_gnext <= w_binext xor ( '0' & w_binext (4 downto 1) ) ;
wfull_value <= '1' when ((wq2_rptr(4)=not(w_gnext(4))) and (wq2_rptr(3)=not(w_gnext(3))) and (wq2_rptr(2 downto 0)= w_gnext(2 downto 0))  ) 
else '0';


process ( wclk , wrst )
begin 
  if wrst ='1' then 
   w_bin<= (others => '0');
   wptr <= (others => '0');
   wfull_sync <= '0';
   end if;
   if rising_edge (wclk) then 
     if wrst = '0' and wfull_sync ='0' then
   w_bin <= w_binext;
   wptr<=w_gnext;
   wfull_sync<=wfull_value ;
    end if;
  end if;
 end process; 
end Behavioral;
