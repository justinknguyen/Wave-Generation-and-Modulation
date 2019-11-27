library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
use ieee.math_real.all;

entity comparator is
	port( 
			clk     	   : in  std_logic;
			reset   	   : in  std_logic;
			enableup  	: in  std_logic_vector(0 downto 0);
			enabledown	: in	std_logic_vector(0 downto 0);
			sel			: in  std_logic_vector(0 downto 0);
			countfreq 	: out std_logic_vector(4 downto 0);
			countamp		: out std_logic_vector(4 downto 0)
    );
end entity;

architecture behaviour of comparator is
	--	Signals
	signal intfreq : unsigned(4 downto 0);
	signal intamp : unsigned(4 downto 0);

Begin

freq : process (clk, sel, reset, enableup, enabledown, intfreq)
begin
	if rising_edge(clk) then
		if(reset = '1') then
			intfreq	<= "00000";
			
		elsif(sel(0) = '0') then --Freq
			if (enableup(0) = '1') then
				if (intfreq < "10110") then
					intfreq <= intfreq + 1;
				end if;
			end if;
			
			if (enabledown(0) = '1') then
				if(intfreq > "00000") then
					intfreq <= intfreq - 1;
				end if;
			end if;
		end if;
	end if;
end process;

amp : process (clk, sel, reset, enableup, enabledown, intamp)
begin
	if rising_edge(clk) then
		if(reset = '1') then
			intamp	<= "11111";

		elsif(sel(0) = '1') then --Amp
			if (enableup(0) = '1') then
				if (intamp < "11111") then
					intamp <= intamp + 1;
				end if;
			end if;
		
			if (enabledown(0) = '1') then
				if (intamp > "00000") then
					intamp <= intamp - 1;
				end if;
			end if;
		end if;
	end if;
end process;
	
countfreq	<= std_logic_vector(intfreq);
countamp		<= std_logic_vector(intamp);

end behaviour;