library ieee;
use ieee.std_logic_1164.all;

entity registersNG is
port( 
	  clk       : in  std_logic;
	  reset     : in  std_logic;
	  enable    : in  std_logic;
     d_inputs  : in  std_logic;
	  q_outputs : out std_logic
    );
end entity;

architecture rtl of registersNG is
begin

   process (clk, reset)
   begin
      if reset = '1' then
		   q_outputs <= '0';
		elsif (rising_edge(clk)) then
		   if (enable = '1') then
            q_outputs <= d_inputs;
			end if;
      end if;
   end process;

end;
