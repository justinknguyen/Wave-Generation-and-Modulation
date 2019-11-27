library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
 

entity tb_voltmeter is
end tb_voltmeter;

architecture behaviour of tb_voltmeter is

	--define clock period
	constant clk_period: time := 20 ns; -- 50 MHz
	 
	--declare components 
	component Voltmeter is
		Port	(      
					clk                           : in  STD_LOGIC;
					reset                         : in  STD_LOGIC;
					S									   : in  STD_LOGIC;
					LEDR                          : out STD_LOGIC_VECTOR (9 downto 0);
					HEX0,HEX1,HEX2,HEX3,HEX4,HEX5 : out STD_LOGIC_VECTOR (7 downto 0)
				);
	end component;
	

	--declare signals
	signal	clk                           : STD_LOGIC;
	signal	reset                         : STD_LOGIC;
	signal	S  									: STD_LOGIC;
	signal	LEDR                          : STD_LOGIC_VECTOR (9 downto 0);
	signal	HEX0,HEX1,HEX2,HEX3,HEX4,HEX5 : STD_LOGIC_VECTOR (7 downto 0);
	

	--instantiate
	begin
	UUT: 	Voltmeter 
	PORT MAP( 
		clk 	=> clk,
		reset => reset,
		S => S,
		LEDR  => LEDR,
		HEX0  => HEX0,
		HEX1  => HEX1,
		HEX2  => HEX2,
		HEX3  => HEX3,
		HEX4  => HEX4,
		HEX5  => HEX5	
		);
	
	--clock process
	clk_process: process
	begin
			clk <= '0';
			wait for clk_period/2;
			clk <= '1';
			wait for clk_period/2;
	end process; 
	
	--mux process
	mux_process: process
	begin
			S <= '0';
			wait for 50*clk_period;
			S <= '1';
			wait for 50*clk_period;
	end process;


	--stimulus process
	stim_process: process
	begin
			--hold reset state for 100 ns
			reset <= '0';
			wait for 5*clk_period;
			reset <= '1';
			wait for 5*clk_period;
			reset <= '0';
			wait;
			
			--stimulus
			
			
	end process;
			
							 
end behaviour;
