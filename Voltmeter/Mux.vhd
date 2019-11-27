library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity MUX2TO1 is
port ( A : in  std_logic_vector(12 downto 0);
		 B : in  std_logic_vector(12 downto 0);
		 S : in  STD_LOGIC_VECTOR(0 downto 0);
		 F : out std_logic_vector(12 downto 0)
	   );
end MUX2TO1;

architecture BEHAVIOUR of MUX2TO1 is 
	begin
		with S(0) select
			F <= A when '1',	--Averaged
				  B when others;
end BEHAVIOUR;	