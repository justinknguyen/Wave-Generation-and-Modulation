library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.math_real.ceil;
use IEEE.math_real.log2;

entity downcounterS is
    PORT ( clk    : in  STD_LOGIC; -- clock to be divided
           reset  : in  STD_LOGIC; -- active-high reset
           enable : in  STD_LOGIC; -- active-high enable
			  period : in	natural;
           zero   : out STD_LOGIC
         );
end downcounterS;

architecture Behavioral of downcounterS is
  signal current_count : natural;
BEGIN
   count: process(clk) begin
     if (rising_edge(clk)) then 
       if (reset = '1') then 
          current_count <= 0 ;
          zero          <= '0';
       elsif (enable = '1') then 
          if (current_count = 0) then
            current_count <= period - 1;
            zero          <= '1';
          else 
            current_count <= current_count - 1;
            zero          <= '0';
          end if;
       else 
          zero <= '0';
       end if;
     end if;
   end process;
END Behavioral;