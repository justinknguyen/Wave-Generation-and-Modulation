library IEEE;							--R = 10kOhms 
use IEEE.STD_LOGIC_1164.ALL;		--C = 2.2nF
use IEEE.STD_LOGIC_UNSIGNED.ALL;	--Cut-off Frequency = 7,234.3Hz
use ieee.math_real.all;

entity wave_gen is
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
end wave_gen;

architecture Behavioral of wave_gen is
--***CONSTANTS***	
	constant up			:	STD_LOGIC	:= '1';
	constant down		:	STD_LOGIC	:= '0';
	constant up_b		:	STD_LOGIC	:= '1';
	constant down_b	:	STD_LOGIC	:= '0'; 	
	constant width		:	integer		:= 9;
	constant width_b  :	integer		:= 13;
	
	constant max_count	  : std_logic_vector(width-1 downto 0)   := (others => '1');
	constant zeros_count   : std_logic_vector(width-1 downto 0)   := (others => '0'); 
	constant max_count_b	  : std_logic_vector(width_b-1 downto 0) := (others => '1');
	constant zeros_count_b : std_logic_vector(width_b-1 downto 0) := (others => '0');

--***TYPES***
	type StateType is (S0,S1,S2);
	type StateType_b is (S0_b,S1_b,S2_b);

--***WAVE SIGNALS***
	signal wavesel											: STD_LOGIC_VECTOR(1 downto 0);
	signal CurrentState, NextState					: StateType;
	signal pwm_out_i, count_direction				: STD_LOGIC;
	signal duty_cycle, counter, Duty_Cycle_C2C	: STD_LOGIC_VECTOR(width-1 downto 0);
	signal pulse											: STD_LOGIC_VECTOR(23 downto 0);
	signal pulseFinal										: STD_LOGIC;
	signal ampFinal										: STD_LOGIC_VECTOR(8 downto 0) := "111111111";
	
	signal freqcount 			:  STD_LOGIC_VECTOR(4 downto 0) := "00000";
	signal ampcount  			:  STD_LOGIC_VECTOR(4 downto 0) := "11111";
	
	signal FreqVsAmpUpSP		:	STD_LOGIC_VECTOR(0 downto 0);
	signal FreqVsAmpDownSP	:	STD_LOGIC_VECTOR(0 downto 0);
	
	signal wavesel0			:  STD_LOGIC_VECTOR(0 downto 0);
	signal wavesel1			:	STD_LOGIC_VECTOR(0 downto 0);
	signal FreqVsAmpSel		:	STD_LOGIC_VECTOR(0 downto 0);	--	'0' = Frequency	'1' = Amplitude
	signal FreqVsAmpUp		:	STD_LOGIC_VECTOR(0 downto 0);
	signal FreqVsAmpDown		:	STD_LOGIC_VECTOR(0 downto 0);

--***BUZZER SIGNALS***
	signal distance_num		:  STD_LOGIC_VECTOR (12 downto 0);
	signal distance2duty		:  STD_LOGIC_VECTOR (12 downto 0);
	signal ampmod				:  STD_LOGIC_VECTOR(12 downto 0) := "1111111111111";
	signal freqmod          :  natural;
	signal freqFinal_b		:	STD_LOGIC;
	
	
	signal CurrentState_b, NextState_b		: StateType_b;
	signal pwm_out_b, count_direction_b		: STD_LOGIC;
	signal duty_cycle_b, counter_b			: STD_LOGIC_VECTOR(width_b-1 downto 0);
	signal pulse_b									: STD_LOGIC;
	
	signal FreqVsAmpMod			:	STD_LOGIC_VECTOR(0 downto 0); --[S8]   '0' = Frequency	'1' = Amplitude
	signal VoltageVsDistance	:  STD_LOGIC_VECTOR(0 downto 0); --[S1]   '0' = Distance	'1' = Voltage
	signal DistanceVsDistance	:  STD_LOGIC_VECTOR(0 downto 0); --[S2]   '0' = 4-33cm		'1' = 0-4cm
	
--***WAVE COMPONENTS***	 
	component PWM_DAC is
		Generic ( width : integer := 9);
			Port (  
					 reset 		: in STD_LOGIC;
                clk 			: in STD_LOGIC;
                duty_cycle : in STD_LOGIC_VECTOR(width-1 downto 0);
                pwm_out 	: out STD_LOGIC
              );
	end component;
	  
	component clock_divider is
		Port (
					  clk     	: in  STD_LOGIC;
					  reset     : in  STD_LOGIC;
					  enable    : in  STD_LOGIC;
					  freq		: out STD_LOGIC_VECTOR(23 downto 0)
				);
	end component;
	
	component Count2Cycle is
		generic ( width : integer := 9);
		port( clk            :  IN    STD_LOGIC;                                
				reset          :  IN    STD_LOGIC;
				Counter      	:  IN    STD_LOGIC_VECTOR(width-1 DOWNTO 0);                           
				DutyCycle      :  OUT   STD_LOGIC_VECTOR(width-1 DOWNTO 0)
			);
	end component ;
	
	component SinglePulse is
		port( clk       : in  std_logic;
				reset     : in  std_logic;
				enable    : in  std_logic;
				signalin	 : in  std_logic_vector(0 downto 0);
				signalout : out std_logic_vector(0 downto 0)
			);
	end component;
	
	component comparator is
		port( clk     	   : in  std_logic;
				reset   	   : in  std_logic;
				enableup  	: in  std_logic_vector(0 downto 0);
				enabledown	: in	std_logic_vector(0 downto 0);
				sel			: in  std_logic_vector(0 downto 0);
				countfreq 	: out std_logic_vector(4 downto 0);
				countamp		: out std_logic_vector(4 downto 0)
		);
	end component;
	
	component Selector is
		port(	pulse			:	in		STD_LOGIC_VECTOR(23 downto 0);
				freqcount	:	in		STD_LOGIC_VECTOR(4 downto 0);
				ampcount		:	in		STD_LOGIC_VECTOR(4 downto 0);
				pulseFinal	:	out	STD_LOGIC;
				ampFinal		:	out	std_logic_vector(8 downto 0)
		);
	end component;	

	component Synchronizer is
		generic(	InputSyncRegisterCount : integer := 2;
					Bits	:	integer	:=	1
				);
		port(	clk		:	in  STD_LOGIC;
				reset		:	in  STD_LOGIC;
				input		:	in		std_logic_vector(Bits-1 downto 0);
				output	:	out	std_logic_vector(Bits-1 downto 0)
			);
	end component;

	
--***BUZZER COMPONENTS***	
	component PWM_DAC_B is
		Generic ( width : integer := 13);
			Port (  
					 reset 		: in STD_LOGIC;
                clk 			: in STD_LOGIC;
                duty_cycle : in STD_LOGIC_VECTOR(width-1 downto 0);
                pwm_out 	: out STD_LOGIC
              );
	end component;
	
	component voltmeter is
		generic (register_count : integer := 2);
		port ( clk                           : in  STD_LOGIC;
             reset                         : in  STD_LOGIC;
			    S									    : in  STD_LOGIC_VECTOR(0 downto 0);
			    distance_Switch					 : in  STD_LOGIC_VECTOR(0 downto 0);
             LEDR                          : out STD_LOGIC_VECTOR (9 downto 0);
             HEX0,HEX1,HEX2,HEX3,HEX4,HEX5 : out STD_LOGIC_VECTOR (7 downto 0);
				 distance_out						 : out STD_LOGIC_VECTOR (12 downto 0)
            );
	end component;
	
	component distance2clkdivisor is
		port ( 
            clk            :  IN    STD_LOGIC;                                
				reset          :  IN    STD_LOGIC; 
				distance       :  IN    STD_LOGIC_VECTOR(12 DOWNTO 0);                           
				divisor        :  OUT   natural
            );
	end component;
	
	component distance2cycle is
		port ( 
            clk            :  IN    STD_LOGIC;                                
				reset          :  IN    STD_LOGIC; 
				distance       :  IN    STD_LOGIC_VECTOR(12 DOWNTO 0);                           
				cycle        	:  OUT   STD_LOGIC_VECTOR(12 DOWNTO 0)
            );
	end component;

	component downcounterS is
	       
		port(	clk    : in  STD_LOGIC; -- clock to be divided
				reset  : in  STD_LOGIC; -- active-high reset
				enable : in  STD_LOGIC; -- active-high enable
				period : in  natural;
				zero   : out STD_LOGIC
         );
	end component;
	
begin

wavesel(0) <= wavesel0(0);
wavesel(1) <= wavesel1(0);

--***WAVE INSTANTIATIONS***
	pwm : PWM_DAC 
		generic map (width => 9)
		port map (	reset => reset,
						clk => clk,
						duty_cycle => duty_cycle,
						pwm_out => pwm_out_i
					 );
		  
	clk_div : clock_divider
		port map (	clk			=> clk,
						reset			=> reset,
						enable		=> '1',
						freq			=> pulse
					 );

	C2C : 	Count2Cycle
		generic map (width => 9)
		port map(	clk 			=> clk,
						reset 		=> reset,
						Counter 		=> counter,
						DutyCycle 	=> Duty_Cycle_C2C
					);
					
	SPUp	:	SinglePulse
		port map( 	clk			=>	clk,
						reset			=>	reset,
						enable		=>	'1',
						signalin		=>	FreqVsAmpUp,
						signalout	=>	FreqVsAmpUpSP
					);

	SPDown	:	SinglePulse
		port map(	clk			=>	clk,
						reset			=>	reset,
						enable		=>	'1',
						signalin		=>	FreqVsAmpDown,
						signalout	=>	FreqVsAmpDownSP
					);

	compare	:	comparator
		port map(	clk     	   => clk,
						reset   	   => reset,
						enableup  	=>	FreqVsAmpUpSP,
						enabledown	=>	FreqVsAmpDownSP,
						sel			=>	FreqVsAmpSel,
						countfreq 	=> freqcount,
						countamp		=> ampcount
					);

	sel	:	Selector
		port map(
						pulse			=>	pulse,
						freqcount	=>	freqcount,
						ampcount		=>	ampcount,
						pulseFinal	=>	pulseFinal,
						ampFinal		=>	ampFinal
					);

		
	sync0	:	Synchronizer
		generic map(	InputSyncRegisterCount => 2,
							Bits	=>	1
						)
		port map(	clk		=>	clk,
						reset		=>	reset,
						input		=>	wavesel0US,
						output	=>	wavesel0
					);
		
	sync1	:	Synchronizer
		generic map(	InputSyncRegisterCount => 2,
							Bits	=>	1
						)
		port map(	clk		=>	clk,
						reset		=>	reset,
						input		=>	wavesel1US,
						output	=>	wavesel1
					);
		
	sync2	:	Synchronizer
		generic map(	InputSyncRegisterCount => 2,
							Bits	=>	1
						)
		port map(	clk		=>	clk,
						reset		=>	reset,
						input		=>	FreqVsAmpSelUS,
						output	=>	FreqVsAmpSel
					);
	
	sync3	:	Synchronizer
		generic map(	InputSyncRegisterCount => 2,
							Bits	=>	1
						)
		port map(	clk		=>	clk,
						reset		=>	reset,
						input		=>	FreqVsAmpUpUS,
						output	=>	FreqVsAmpUp
					);	
		
	sync4	:	Synchronizer
		generic map(	InputSyncRegisterCount => 2,
							Bits	=>	1
						)
		port map(	clk		=>	clk,
						reset		=>	reset,
						input		=>	FreqVsAmpDownUS,
						output	=>	FreqVsAmpDown
					);
	
	
--***BUZZER INSTANTIATIONS***	
	voltage : voltmeter
		generic map (register_count => 2)
		port map( clk 	 			  => clk,
					 reset 			  => reset,
					 S	     			  => VoltageVsDistance,
					 distance_Switch => DistanceVsDistance,
					 LEDR 			  => LEDR,
					 HEX0 			  => HEX0,
					 HEX1 			  => HEX1,
					 HEX2 			  => HEX2,
					 HEX3 			  => HEX3,
					 HEX4 			  => HEX4,
					 HEX5 			  => HEX5,
					 distance_out	  => distance_num
					);
					
	D2D : distance2clkdivisor --Freq
		port map( clk 		 => clk,
					 reset 	 => reset,
					 distance => distance_num,
					 divisor  => freqmod
					);
					
	D2C : distance2cycle	--Amp
		port map( clk 		 => clk,
					 reset    => reset,
					 distance => distance_num,
					 cycle    => distance2duty
					);
	
	dc_b : downcounterS
		port map(  clk    => clk,
					  reset  => reset,
					  enable => '1',
					  period => freqmod,
					  zero   => pulse_b
					);
					
	pwm2 : PWM_DAC_B 
		generic map (width => 13)
		port map (
						reset 		=> reset,
						clk 			=> clk,
						duty_cycle  => duty_cycle_b,
						pwm_out 		=> pwm_out_b
					 );

	syncb0	:	Synchronizer
		generic map(	InputSyncRegisterCount => 2,
							Bits	=>	1
						)
		port map(	clk		=>	clk,
						reset		=>	reset,
						input		=>	FreqVsAmpModUS,
						output	=>	FreqVsAmpMod
					);
	
	syncb1	:	Synchronizer
		generic map(	InputSyncRegisterCount => 2,
							Bits	=>	1
						)
		port map(	clk		=>	clk,
						reset		=>	reset,
						input		=>	VoltageVsDistanceUS,
						output	=>	VoltageVsDistance
					);
	
	syncb2	:	Synchronizer
		generic map(	InputSyncRegisterCount => 2,
							Bits	=>	1
						)
		port map(	clk		=>	clk,
						reset		=>	reset,
						input		=>	DistanceVsDistanceUS,
						output	=>	DistanceVsDistance
					);	 

--***WAVE LOGIC***
	count : process(clk, reset, pulseFinal)
		begin
		if (rising_edge(clk)) then
			if(reset = '1') then
				counter <= (others => '0');
			elsif (pulseFinal = '1') then
					if(count_direction = up) then
						counter <= counter + '1';
					else
						counter <= counter - '1';
					end if;                                                           
			end if;
		end if;
	end process;
	
	COMB : process(CurrentState, counter)
    begin
	 case wavesel is
	 
		when "00" => --Square
		
					case CurrentState is
						when S0 =>
							 NextState <= S1;
							 duty_cycle <= (others => '0');
							 count_direction <= up;
						when S1 => --Up [Square]
							 duty_cycle <= ampFinal;
							 count_direction <= up;               
		--                if max = '1' then
							 if counter = max_count then
								  NextState <= S2;
							 else
								  NextState <= S1;
							 end if;
						when  S2 => --Down [Square]
							 duty_cycle <= zeros_count;
		                count_direction <= down;            
		                if counter = zeros_count then
		                    NextState <= S1;
		                else
		                    NextState <= S2;
							end if;            
						when others =>
							 NextState <= S0;
							 duty_cycle <= (others => '0');
							 count_direction <= up;                    
				  end case;

		when "01" => --Sawtooth
		
					case CurrentState is
						when S0 =>
							 NextState <= S1;
							 duty_cycle <= (others => '0');
							 count_direction <= up;
						when S1 => --Up [Sawtooth]
							 duty_cycle <= Duty_Cycle_C2C;
							 count_direction <= up;               
		--                if max = '1' then
							 if counter = max_count then
								  NextState <= S2;
							 else
								  NextState <= S1;
							 end if;
						when  S2 => --Down [Sawtooth]       
							 duty_cycle <= zeros_count;
							 NextState <= S1;           
						when others =>
							 NextState <= S0;
							 duty_cycle <= (others => '0');
							 count_direction <= up;                    
				  end case;

		when "10" => --Triangle
	
				  case CurrentState is
						when S0 =>
							 NextState <= S1;
							 duty_cycle <= (others => '0');
							 count_direction <= up;
						when S1 => --Up [Triangle]
							 duty_cycle <= Duty_Cycle_C2C;
							 count_direction <= up;               
		--                if max = '1' then
							 if counter = max_count then
								  NextState <= S2;
							 else
								  NextState <= S1;
							 end if;         
		            when  S2 => --Down [Triangle]
		               duty_cycle <= Duty_Cycle_C2C;
		               count_direction <= down;            
		               if counter = zeros_count then
		                   NextState <= S1;
		                else
		                    NextState <= S2;
							end if;
						when others =>
							 NextState <= S0;
							 duty_cycle <= (others => '0');
							 count_direction <= up;                    
				  end case; 

		 when others =>		  
				  duty_cycle <= (others => '0');

	 end case;
	 end process COMB;

    SEQ: process(clk, reset)
    begin
    if rising_edge(clk) then
		if(reset = '1') then
         CurrentState <= S0;
		else
         CurrentState <= NextState;
      end if;
	 end if;
    end process SEQ;            
        	  
    PWM_OUT <= pwm_out_i;
	 
	 
--***BUZZER LOGIC***
	count_b	:	process(clk, reset, pulse(23), pulse_b)
	begin
	if (rising_edge(clk)) then
		if (reset='1') then
			counter_b <= (others => '0'); 
			ampmod <= (others => '1');
			
		elsif (FreqVsAmpMod(0) ='0') then --Freq 
			ampmod <= (others => '1');
			if (pulse_b = '1') then
					if(count_direction_b = up_b) then
						counter_b <= counter_b + '1';
					else
						counter_b <= counter_b - '1';
					end if;                                                           
			end if;
		
		elsif (FreqVsAmpMod(0)	='1') then --Amp
			ampmod <= distance2duty;
			if (pulse(23) = '1') then
					if(count_direction_b = up_b) then
						counter_b <= counter_b + '1';
					else
						counter_b <= counter_b - '1';
					end if;                                                           
			end if;
		end if;
	end if;
	end process count_b;
	
	COMB_b : process(CurrentState_b, counter_b)
   begin
			case CurrentState_b is
				when S0_b =>
					 NextState_b <= S1_b;
					 duty_cycle_b <= (others => '0');
					 count_direction_b <= up_b;
				when S1_b => --Up [Square]
					 duty_cycle_b <= ampmod;
					 count_direction_b <= up_b;               
--                if max = '1' then
					 if counter_b = max_count_b then
						  NextState_b <= S2_b;
					 else
						  NextState_b <= S1_b;
					 end if;
				when  S2_b => --Down [Square]
					 duty_cycle_b <= (others => '0');
					 count_direction_b <= down_b;            
					 if counter_b = zeros_count_b then
						  NextState_b <= S1_b;
					 else
						  NextState_b <= S2_b;
					end if;            
				when others =>
					 NextState_b <= S0_b;
					 duty_cycle_b <= (others => '0');
					 count_direction_b <= up_b;                    
		  end case;
   end process COMB_b; 
		 
   SEQ_b : process(clk, reset)
   begin
   if rising_edge(clk) then
		if(reset = '1') then
         CurrentState_b <= S0_b;
		else
         CurrentState_b <= NextState_b;
      end if;
	end if;
   end process SEQ_b;

	BUZZ_OUT <= pwm_out_b;

end Behavioral;