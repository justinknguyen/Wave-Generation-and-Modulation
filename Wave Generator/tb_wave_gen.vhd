library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
 

entity tb_wave_gen is
end tb_wave_gen;

architecture behaviour of tb_wave_gen is

	--define clock period
	constant clk_period: time := 20 ns; -- 50 MHz
	 
	--declare components 
	component wave_gen is
		Port (	clk						:	in  STD_LOGIC;
					reset					 	:	in  STD_LOGIC;							 --[S0]
					wavesel0US			 	:	in  STD_LOGIC_VECTOR(0 downto 0); --[S3]
					wavesel1US			 	:	in  STD_LOGIC_VECTOR(0 downto 0); --[S4]
					FreqVsAmpSelUS		 	:	in  STD_LOGIC_VECTOR(0 downto 0); --[S9]   '0' = Frequency	'1' = Amplitude
					FreqVsAmpUpUS		 	:	in  STD_LOGIC_VECTOR(0 downto 0); --[K0]   Increase
					FreqVsAmpDownUS	  	:	in  STD_LOGIC_VECTOR(0 downto 0); --[K1]   Decrease
					FreqVsAmpModUS		  	:	in	 STD_LOGIC_VECTOR(0 downto 0); --[S8]   '0' = Frequency	'1' = Amplitude
					VoltageVsDistanceUS 	:  in	 STD_LOGIC_VECTOR(0 downto 0); --[S1]   '0' = Distance	'1' = Voltage
					DistanceVsDistanceUS	:  in  STD_LOGIC_VECTOR(0 downto 0); --[S2]   '0' = 4-33cm		'1' = 0-4cm
					PWM_OUT			     	:	out STD_LOGIC;
					BUZZ_OUT			     	:	out STD_LOGIC;
					LEDR                          : out STD_LOGIC_VECTOR (9 downto 0);
					HEX0,HEX1,HEX2,HEX3,HEX4,HEX5 : out STD_LOGIC_VECTOR (7 downto 0)
          );
	end component;
	

	--declare signals
	signal	clk                           : STD_LOGIC;
	signal	reset                         : STD_LOGIC;
	signal	wavesel0			 				   : STD_LOGIC_VECTOR(0 downto 0); 
	signal	wavesel1			 					: STD_LOGIC_VECTOR(0 downto 0); 
	signal	FreqVsAmpSel		 				: STD_LOGIC_VECTOR(0 downto 0); 
	signal	FreqVsAmpUp		 					: STD_LOGIC_VECTOR(0 downto 0); 
	signal	FreqVsAmpDown	  					: STD_LOGIC_VECTOR(0 downto 0); 
	signal	FreqVsAmpMod	  					: STD_LOGIC_VECTOR(0 downto 0); 
	signal	VoltageVsDistance					: STD_LOGIC_VECTOR(0 downto 0); 
	signal	DistanceVsDistance				: STD_LOGIC_VECTOR(0 downto 0); 
	signal	PWM_OUT			     				: STD_LOGIC;
	signal	BUZZ_OUT			     				: STD_LOGIC;
	signal	LEDR                          : STD_LOGIC_VECTOR (9 downto 0);
	signal	HEX0,HEX1,HEX2,HEX3,HEX4,HEX5 : STD_LOGIC_VECTOR (7 downto 0);
	

	--instantiate
	begin
	UUT: 	wave_gen 
	PORT MAP( 
					clk						=> clk,
					reset					 	=> reset,					
					wavesel0US			 	=> wavesel0,
					wavesel1US			 	=> wavesel1,
					FreqVsAmpSelUS		 	=> FreqVsAmpSel,
					FreqVsAmpUpUS		 	=> FreqVsAmpUp,
					FreqVsAmpDownUS	  	=> FreqVsAmpDown,
					FreqVsAmpModUS		  	=> FreqVsAmpMod,
					VoltageVsDistanceUS 	=> VoltageVsDistance,
					DistanceVsDistanceUS	=> DistanceVsDistance,
					PWM_OUT			     	=> PWM_OUT,
					BUZZ_OUT			     	=> BUZZ_OUT,
					LEDR                 => LEDR,
					HEX0 			  			=> HEX0,
					HEX1 			  			=> HEX1,
					HEX2 			  			=> HEX2,
					HEX3 			  			=> HEX3,
					HEX4 			  			=> HEX4,
					HEX5 			  			=> HEX5
				);
	
	--clock process
	clk_process: process
	begin
			clk <= '0';
			wait for clk_period/2;
			clk <= '1';
			wait for clk_period/2;
	end process; 
	
	--reset process
	reset_process: process
	begin
			--hold reset state for 100 ns
			reset <= '0';
			wait for 5*clk_period;
			reset <= '1';
			wait for 5*clk_period;
			reset <= '0';
			wait;	
	end process;
	
	--wave select process
	wavesel_process: process
	begin
			wavesel0(0) <= '0';
			wavesel1(0) <= '0';
			wait for 100*clk_period;
			wavesel0(0) <= '1';
			wavesel1(0) <= '0';
			wait for 100*clk_period;
			wavesel0(0) <= '0';
			wavesel1(0) <= '1';
			wait for 100*clk_period;
	end process;
	
	--Freq or Amp select process
	FreqVsAmpSel_process: process
	begin
			FreqVsAmpSel(0) <= '0';
			wait for 50*clk_period;
			FreqVsAmpSel(0) <= '1';
			wait for 50*clk_period;
	end process;
	
	--Up or Down process
	UpVsDown_process: process
	begin
			FreqVsAmpUp(0) <= '0';
			wait for 2*clk_period;
			FreqVsAmpUp(0) <= '1';
			wait for 5*clk_period;
			FreqVsAmpUp(0) <= '0';
			wait for 2*clk_period;
			FreqVsAmpUp(0) <= '1';
			wait for 5*clk_period;
		
			FreqVsAmpDown(0) <= '0';
			wait for 2*clk_period;
			FreqVsAmpDown(0) <= '1';
			wait for 5*clk_period;
			FreqVsAmpDown(0) <= '0';
			wait for 2*clk_period;
			FreqVsAmpDown(0) <= '1';
			wait for 5*clk_period;
	end process;
	
	--Freq or Amp Mod select process
	FreqVsAmpMod_process: process
	begin
			FreqVsAmpMod(0) <= '0';
			wait for 50*clk_period;
			FreqVsAmpMod(0) <= '1';
			wait for 50*clk_period;
	end process;
	
	--Volt or Dist select process
	VoltVsDist_process: process
	begin
			VoltageVsDistance(0) <= '0';
			wait for 50*clk_period;
			VoltageVsDistance(0) <= '1';
			wait for 50*clk_period;
	end process;
	
	--Dist or Dist select process
	DistVsDist_process: process
	begin
			DistanceVsDistance(0) <= '0';
			wait for 100*clk_period;
	end process;
						 
end behaviour;