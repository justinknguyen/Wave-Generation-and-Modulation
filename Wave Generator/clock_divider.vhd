-- This is example code that uses the downcounter module to create the signals 
-- to drive the 7-segment displays for a countdown timer. This code is 
-- provided to you to show an example of how to use the downcounter module, 
-- if it is of use to your project.

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.math_real.ceil;
use IEEE.math_real.log2;

entity clock_divider is
    PORT ( clk			: in  STD_LOGIC;
           reset		: in  STD_LOGIC;
           enable		: in  STD_LOGIC;
			  freq		: out STD_LOGIC_VECTOR(23 downto 0)
           );
end clock_divider;

architecture Behavioral of clock_divider is
	-- Internal Signals
	signal ifreq1000000	: STD_LOGIC;
	signal ifreq500000	: STD_LOGIC;
	signal ifreq250000	: STD_LOGIC;
	signal ifreq125000	: STD_LOGIC;
	signal ifreq62500		: STD_LOGIC;
	signal ifreq31250		: STD_LOGIC;
	signal ifreq15625		: STD_LOGIC;
	signal ifreq7813		: STD_LOGIC;
	signal ifreq3906		: STD_LOGIC;
	signal ifreq1953		: STD_LOGIC;
	signal ifreq977		: STD_LOGIC;
	signal ifreq488		: STD_LOGIC;
	signal ifreq333333	: STD_LOGIC;
	signal ifreq111111	: STD_LOGIC;
	signal ifreq37037		: STD_LOGIC;
	signal ifreq12346		: STD_LOGIC;
	signal ifreq4115		: STD_LOGIC;
	signal ifreq1372		: STD_LOGIC;
	signal ifreq457		: STD_LOGIC;
	signal ifreq200000	: STD_LOGIC;
	signal ifreq40000		: STD_LOGIC;
	signal ifreq8000		: STD_LOGIC;
	signal ifreq1600		: STD_LOGIC;
	signal ifreqbuz		: STD_loGiC;

	-- Components Declarations
	component downcounter is
		Generic ( period  : natural := 1000); -- number to count
      PORT (  clk    : in  STD_LOGIC;
              reset  : in  STD_LOGIC;
              enable : in  STD_LOGIC;
              zero   : out STD_LOGIC;
              value  : out STD_LOGIC_VECTOR(integer(ceil(log2(real(period)))) - 1 downto 0)
           );
	end component;

BEGIN
   freq1000000counter: downcounter	--[0] 1000000
		generic map(period => 50) 
		PORT MAP (
						clk    => clk,
						reset  => reset,
						enable => enable,
						zero   => ifreq1000000,
						value  => open
					);
-- 2 Multiples
	freq500000counter: downcounter	--[1] 500000
		generic map(period => 2) 
		PORT MAP (
						clk    => clk,
						reset  => reset,
						enable => ifreq1000000,
						zero   => ifreq500000,
						value  => open
					);
   
	freq250000counter: downcounter	--[2] 250000
		generic map(period => 2)
		PORT MAP (
						clk    => clk,
						reset  => reset,
						enable => ifreq500000,
						zero   => ifreq250000,
						value  => open
					);
	
	freq125000counter: downcounter	--[3] 125000
		generic map(period => 2) 
		PORT MAP (
						clk    => clk,
						reset  => reset,
						enable => ifreq250000,
						zero   => ifreq125000,
						value  => open
					);
	
	freq62500counter: downcounter	--[4] 62500
		generic map(period => 2) 
		PORT MAP (
						clk    => clk,
						reset  => reset,
						enable => ifreq125000,
						zero   => ifreq62500,
						value  => open
					);
	
	freq31250counter: downcounter	--[5] 31250
		generic map(period => 2)
		PORT MAP (
						clk    => clk,
						reset  => reset,
						enable => ifreq62500,
						zero   => ifreq31250,
						value  => open
					);

	freq15625counter: downcounter	--[6] 15625
		generic map(period => 2)
		PORT MAP (
						clk    => clk,
						reset  => reset,
						enable => ifreq31250,
						zero   => ifreq15625,
						value  => open
					);
				
	freq7813counter: downcounter	--[7] 7813
		generic map(period => 2)
		PORT MAP (
						clk    => clk,
						reset  => reset,
						enable => ifreq15625,
						zero   => ifreq7813,
						value  => open
					);
				
	freq3906counter: downcounter	--[8] 3906
		generic map(period => 2)
		PORT MAP (
						clk    => clk,
						reset  => reset,
						enable => ifreq7813,
						zero   => ifreq3906,
						value  => open
					);
		
	freq1953counter: downcounter	--[9] 1953
		generic map(period => 2)
		PORT MAP (
						clk    => clk,
						reset  => reset,
						enable => ifreq3906,
						zero   => ifreq1953,
						value  => open
					);
		
	freq977counter: downcounter	--[10] 977
		generic map(period => 2)
		PORT MAP (
						clk    => clk,
						reset  => reset,
						enable => ifreq1953,
						zero   => ifreq977,
						value  => open
					);

	freq488counter: downcounter	--[11] 488
		generic map(period => 2)
		PORT MAP (
						clk    => clk,
						reset  => reset,
						enable => ifreq977,
						zero   => ifreq488,
						value  => open
					);
-- 3 Multiples
	freq333333counter: downcounter	--[12] 333333
		generic map(period => 3)
		PORT MAP (
						clk    => clk,
						reset  => reset,
						enable => ifreq1000000,
						zero   => ifreq333333,
						value  => open
					);
	
	freq111111counter: downcounter	--[13] 111111
		generic map(period => 3)
		PORT MAP (
						clk    => clk,
						reset  => reset,
						enable => ifreq333333,
						zero   => ifreq111111,
						value  => open
					);
	
	freq37037counter: downcounter	--[14] 37037
		generic map(period => 3)
		PORT MAP (
						clk    => clk,
						reset  => reset,
						enable => ifreq111111,
						zero   => ifreq37037,
						value  => open
					);
	
	freq12346counter: downcounter	--[15] 12346
		generic map(period => 3)
		PORT MAP (
						clk    => clk,
						reset  => reset,
						enable => ifreq37037,
						zero   => ifreq12346,
						value  => open
					);
	
	freq4115counter: downcounter	--[16] 4115
		generic map(period => 3)
		PORT MAP (
						clk    => clk,
						reset  => reset,
						enable => ifreq12346,
						zero   => ifreq4115,
						value  => open
					);
	
	freq1372counter: downcounter	--[17] 1372
		generic map(period => 3)
		PORT MAP (
						clk    => clk,
						reset  => reset,
						enable => ifreq4115,
						zero   => ifreq1372,
						value  => open
					);
	
	freq457counter: downcounter	--[18] 457
		generic map(period => 3)
		PORT MAP (
						clk    => clk,
						reset  => reset,
						enable => ifreq1372,
						zero   => ifreq457,
						value  => open
					);
-- 5 Multiples
	freq200000counter: downcounter	--[19] 200000
		generic map(period => 5)
		PORT MAP (
						clk    => clk,
						reset  => reset,
						enable => ifreq1000000,
						zero   => ifreq200000,
						value  => open
					);
	
	freq40000counter: downcounter	--[20] 40000
		generic map(period => 5)
		PORT MAP (
						clk    => clk,
						reset  => reset,
						enable => ifreq200000,
						zero   => ifreq40000,
						value  => open
					);
				
	freq8000counter: downcounter	--[21] 8000
		generic map(period => 5)
		PORT MAP (
						clk    => clk,
						reset  => reset,
						enable => ifreq40000,
						zero   => ifreq8000,
						value  => open
					);
				
	freq1600counter: downcounter	--[22] 1600
		generic map(period => 5)
		PORT MAP (
						clk    => clk,
						reset  => reset,
						enable => ifreq8000,
						zero   => ifreq1600,
						value  => open
					);

	freqbuzcounter: downcounter	--[23] 1000000
		generic map(period => 6) 
		PORT MAP (
						clk    => clk,
						reset  => reset,
						enable => enable,
						zero   => ifreqbuz,
						value  => open
					);
	
	freq(0)	<=	ifreq457;
	freq(1)	<=	ifreq488;
	freq(2)	<=	ifreq977;
	freq(3)	<=	ifreq1372;
	freq(4)	<=	ifreq1600;
	freq(5)	<=	ifreq1953;
	freq(6)	<=	ifreq3906;
	freq(7)	<=	ifreq4115;
	freq(8)	<=	ifreq7813;
	freq(9)	<=	ifreq8000;
	freq(10)	<=	ifreq12346;
	freq(11)	<=	ifreq15625;
	freq(12)	<=	ifreq31250;
	freq(13)	<=	ifreq37037;
	freq(14)	<=	ifreq40000;
	freq(15)	<=	ifreq62500;
	freq(16)	<=	ifreq111111;
	freq(17)	<=	ifreq125000;
	freq(18)	<=	ifreq200000;
	freq(19)	<=	ifreq250000;
	freq(20)	<=	ifreq333333;
	freq(21)	<=	ifreq500000;
	freq(22)	<=	ifreq1000000;
	freq(23) <= ifreqbuz;
	
END Behavioral;