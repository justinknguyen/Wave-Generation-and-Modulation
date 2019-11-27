library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity SinglePulse is
	port( 
			clk       : in  std_logic;
			reset     : in  std_logic;
			enable    : in  std_logic;
			signalin	 : in  std_logic_vector(0 downto 0);
			signalout : out std_logic_vector(0 downto 0)	
    );
end entity;

architecture behaviour of SinglePulse is
	--	Signals
	signal int	:	std_logic_vector(0 downto 0);

	--	Components
	Component registers is
		generic(bits : integer := 1);
		port(	clk       : in  std_logic;
				reset     : in  std_logic;
				enable    : in  std_logic;
				d_inputs  : in  std_logic_vector(bits-1 downto 0);
				q_outputs : out std_logic_vector(bits-1 downto 0)
			);
	END Component;

Begin

	Reg	:	registers
		generic map(bits => 1)
		port map(	clk			=>	clk,
						reset			=>	reset,
						enable		=>	enable,
						d_inputs		=>	signalin,
						q_outputs	=>	int
						);

signalout	<=	signalin and not(int);
	
end behaviour;