library ieee;
use ieee.std_logic_1164.all;
use ieee.math_real.all;
use ieee.numeric_std.all;

entity tb_moving_averager is
end tb_moving_averager;

architecture test of tb_moving_averager is
	--define clock period
	constant clk_period: time := 20 ns; -- 50 MHz
	 
	--declare components 
	component moving_averager is
		generic (sample_count	:	integer	:=	2);
		port (
				clk	:	in  std_logic;
				reset	:	in  std_logic;
				EN		:	in  std_logic;
				Din	:	in  std_logic_vector(11 downto 0);
				Q		:	out std_logic_vector(11 downto 0)
		);
	end component moving_averager;
	
	--declare signals
	signal	clk	:	std_logic;
	signal	reset	:	std_logic;
	signal	EN		:	std_logic;
	signal	Din	:	std_logic_vector(11 downto 0);
	signal	Q		:	std_logic_vector(11 downto 0);
	
	--instantiate
	begin
	DUT: 	moving_averager
	PORT MAP(
				clk	=>	clk,
				reset	=>	reset,
				EN		=>	EN,
				Din	=>	Din,
				Q		=>	Q
	);
	
	--clock process
	clk_process	:	process
	begin
			clk <= '0';
			wait for clk_period/2;
			clk <= '1';
			wait for clk_period/2;
	end process clk_process;
	
	--reset process
	reset_process	:	process
	begin
			reset <= '0';
			wait for 5*clk_period;
			reset <= '1';
			wait for 5*clk_period;
			reset <= '0';
			wait;			
	end process reset_process;
	
	--EN process
	EN_process	:	process
	begin
			EN	<=	'0';
			wait for 100*clk_period;
			En	<=	'1';
			wait;
	end process EN_process;
	
	--Din process
	Din_process	:	process
	begin
			Din	<=	"000000000000";
				wait for clk_period;
			Din	<=	"111111111111";
				wait for clk_period;
	end process Din_process;
end architecture test;
