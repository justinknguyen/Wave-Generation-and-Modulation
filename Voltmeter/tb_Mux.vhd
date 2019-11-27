library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
 

entity tb_Mux is
end tb_Mux;

architecture behaviour of tb_Mux is

	--define clock period
	constant clk_period: time := 20 ns; -- 50 MHz
	 
	--declare components 
	component MUX2TO1 is
		Port	(      
					A : in  std_logic_vector(11 downto 0);
					B : in  std_logic_vector(11 downto 0);
					S : in  std_logic;
					F : out std_logic_vector(11 downto 0)
				);
	end component;

	--declare signals
	signal	A  : STD_LOGIC_VECTOR (11 downto 0) := "100011000000";
	signal	B  : STD_LOGIC_VECTOR (11 downto 0) := "000110100100";
	signal	S  : STD_LOGIC;
	signal	F  : STD_LOGIC_VECTOR (11 downto 0);
	signal  clk : STD_LOGIC;
	

	--instantiate
	begin
	UUT: 	MUX2TO1 
	PORT MAP( 
		A => A,
		B => B,
		S => S,
		F => F	
		);
		
   --clock process
	clk_process: process
	begin
			clk <= '0';
			wait for clk_period/2;
			clk <= '1';
			wait for clk_period/2;
	end process; 
 	

	--stimulus process
	stim_process: process
	begin
	-- hold reset state for 100 ns. 
      wait for 100 ns;
		
			--stimulus
			S <= '0';
			wait for 50*clk_period;
			S <= '1';
			wait for 50*clk_period;
			
			
	end process;
							 
end behaviour;