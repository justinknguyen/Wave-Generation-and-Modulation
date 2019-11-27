library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
 
entity Voltmeter is
	 generic (register_count : integer := 2);
    Port ( clk                           : in  STD_LOGIC;
           reset                         : in  STD_LOGIC;
			  S									  : in  STD_LOGIC_VECTOR(0 downto 0);
			  distance_Switch					  : in  STD_LOGIC_VECTOR(0 downto 0);
           LEDR                          : out STD_LOGIC_VECTOR (9 downto 0);
           HEX0,HEX1,HEX2,HEX3,HEX4,HEX5 : out STD_LOGIC_VECTOR (7 downto 0);
			  distance_out						  : out STD_LOGIC_VECTOR (12 downto 0)
          );
end Voltmeter;

architecture Behavioral of Voltmeter is
type AR_q_outputs1 is array (0 to register_count) of STD_LOGIC_VECTOR (11 downto 0);	--Generic
type AR_q_outputs2 is array (0 to register_count) of STD_LOGIC_VECTOR (11 downto 0);	--Generic
type AR_response_valid_out_i is array (1 to 3) of STD_LOGIC_VECTOR(0 downto 0);
Signal q_outputs1	: 		AR_q_outputs1;
Signal q_outputs2	: 		AR_q_outputs2;
signal response_valid_out_i	:	Ar_response_valid_out_i;

Signal A, Num_Hex0, Num_Hex1, Num_Hex2, Num_Hex3, Num_Hex4, Num_Hex5 :	STD_LOGIC_VECTOR (3 downto 0):= (others=>'0');   
Signal DP_in																			:	STD_LOGIC_VECTOR (5 downto 0);
Signal ADC_read,rsp_data															:	STD_LOGIC_VECTOR (11 downto 0);
Signal voltage																			:	STD_LOGIC_VECTOR (12 downto 0);
Signal voltage_bcd																	:  STD_LOGIC_VECTOR (12 downto 0);
Signal distance						  												:  STD_LOGIC_VECTOR (12 downto 0);
Signal busy																				:  STD_LOGIC;
Signal bcd																				:  STD_LOGIC_VECTOR(15 DOWNTO 0);
Signal Q_temp1																			:  std_logic_vector(11 downto 0);
--Signal Q_temp2 : std_logic_vector(11 downto 0);

Component voltage2distance is
	 Port( clk            :  IN    STD_LOGIC;                                
			 reset          :  IN    STD_LOGIC;
			 distance_Switch:  IN	 STD_LOGIC_VECTOR(0 downto 0);
			 voltage        :  IN    STD_LOGIC_VECTOR(12 DOWNTO 0);                           
			 distance       :  OUT   STD_LOGIC_VECTOR(12 DOWNTO 0)
			);
End Component ;

Component MUX2TO1 is
	 Port( A : in  std_logic_vector(12 downto 0);
			 B : in  std_logic_vector(12 downto 0);
		    S : in  STD_LOGIC_VECTOR(0 downto 0);
		    F : out std_logic_vector(12 downto 0)
			);
End Component ;

Component SevenSegment is
    Port( Num_Hex0,Num_Hex1,Num_Hex2,Num_Hex3,Num_Hex4,Num_Hex5 : in  STD_LOGIC_VECTOR (3 downto 0);
          Hex0,Hex1,Hex2,Hex3,Hex4,Hex5                         : out STD_LOGIC_VECTOR (7 downto 0);
          DP_in                                                 : in  STD_LOGIC_VECTOR (5 downto 0)
			);
End Component ;

Component ADC_Conversion is --ADC_Conversion test_DE10_Lite
    Port( MAX10_CLK1_50      : in STD_LOGIC;
          response_valid_out : out STD_LOGIC;
          ADC_out            : out STD_LOGIC_VECTOR (11 downto 0)
         );
End Component ;

Component binary_bcd IS
   PORT(
      clk     : IN  STD_LOGIC;                      --system clock
      reset   : IN  STD_LOGIC;                      --active low asynchronus reset
      ena     : IN  STD_LOGIC;                      --latches in new binary number and starts conversion
      binary  : IN  STD_LOGIC_VECTOR(12 DOWNTO 0);  --binary number to convert
      busy    : OUT STD_LOGIC;                      --indicates conversion in progress
      bcd     : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)   --resulting BCD number
		);           
END Component;

Component registers is
   generic(bits : integer);
   port
     ( 
      clk       : in  std_logic;
      reset     : in  std_logic;
      enable    : in  std_logic;
      d_inputs  : in  std_logic_vector(bits-1 downto 0);
      q_outputs : out std_logic_vector(bits-1 downto 0)  
     );
END Component;

--Component averager is
--  port(
--    clk, reset : in std_logic;
--    Din : in  std_logic_vector(11 downto 0);
--    EN  : in  std_logic; -- response_valid_out
--    Q   : out std_logic_vector(11 downto 0)
--    );
--  end Component;
  
Component moving_averager is
	generic (sample_count  : integer);
	port (
			  clk    : in  std_logic;
			  reset  : in  std_logic;
			  EN     : in  std_logic;
			  Din    : in  std_logic_vector(11 downto 0);
			  Q      : out std_logic_vector(11 downto 0)
			);
END Component;

begin

	blank_error_decimal : process(bcd, S)
	begin
	DP_in(5 downto 4) <= "00";
	DP_in(3) <= S(0); --voltage
	DP_in(2) <= NOT S(0); --distance
	DP_in(1 downto 0) <= "00";
	
		if (S(0)='0') then --distance
			if to_integer(unsigned(distance)) > 3300 then
					Num_Hex0 <= "1011";	--error
					Num_Hex1 <= "0000";
					Num_Hex2 <= "1011";
					Num_Hex3 <= "1011";
					Num_Hex4 <= "1010"; 
					Num_Hex5 <= "1111";  -- blank this display
					DP_in(2) <= '0';		
			else
				Num_Hex0 <= bcd(3  downto  0); 
				Num_Hex1 <= bcd(7  downto  4);
				Num_Hex2 <= bcd(11 downto  8);
				Num_Hex4 <= "1111";  -- blank this display
				Num_Hex5 <= "1111";  -- blank this display 
				if (bcd(15 downto 12) = "0000") then --blank 0
					Num_Hex3 <= "1111";	-- blank this display
				else
					Num_Hex3 <= bcd(15 downto 12);
				end if;
			end if;
		elsif (S(0)='1') then --voltage
			Num_Hex0 <= bcd(3  downto  0); 
			Num_Hex1 <= bcd(7  downto  4);
			Num_Hex2 <= bcd(11 downto  8);
			Num_Hex3 <= bcd(15 downto 12);
			Num_Hex4 <= "1111";  -- blank this display
			Num_Hex5 <= "1111";  -- blank this display 
		end if;
	end process;
	  
	


v2d : 	voltage2distance
			port map(
						clk 				 => clk,
						reset 			 => reset,
						distance_Switch => distance_Switch,
						voltage 			 => voltage,
						distance 		 => distance
						);
	
	
mux :		MUX2TO1
			port map(
						A => voltage,
						B => distance,
						S => S,
						F => voltage_bcd
						);
						
--ave :    averager
--         port map(
--                  clk       => clk,
--                  reset     => reset,
--                  Din       => q_outputs_2,
--                  EN        => response_valid_out_i3(0),
--                  Q         => Q_temp1
--                  );
  
movave: moving_averager
		  generic map (sample_count   => 512)
		  port map (
						clk     => clk,
						reset   => reset,
						EN      => response_valid_out_i(3)(0),
						Din     => q_outputs1(register_count),
						Q       => Q_temp1
					  );
   
q_outputs1(0)	<=	ADC_read;
q_outputs2(0)(0)	<=	response_valid_out_i(1)(0);
response_valid_out_i(3)(0)	<=	q_outputs2(q_outputs2'length-1)(0);
syncgen1	:	for i in 1 to register_count generate	--Generic
	begin
		sync	:	registers
					generic map(bits => 12)
					port map(
								clk			=>	clk,
								reset			=>	reset,
								enable		=>	'1',
								d_inputs		=>	q_outputs1(i-1),
								q_outputs	=>	q_outputs1(i)
					);
	end generate syncgen1;
	
syncgen2	:	for i in 1 to register_count generate	--Generic
	begin
		sync	:	registers
					generic map(bits => 12)
					port map(
								clk			=>	clk,
								reset			=>	reset,
								enable		=>	'1',
								d_inputs		=>	q_outputs2(i-1),
								q_outputs	=>	q_outputs2(i)
					);
	end generate syncgen2;
                
SevenSegment_ins: SevenSegment  
                  PORT MAP( Num_Hex0 => Num_Hex0,
                            Num_Hex1 => Num_Hex1,
                            Num_Hex2 => Num_Hex2,
                            Num_Hex3 => Num_Hex3,
                            Num_Hex4 => Num_Hex4,
                            Num_Hex5 => Num_Hex5,
                            Hex0     => Hex0,
                            Hex1     => Hex1,
                            Hex2     => Hex2,
                            Hex3     => Hex3,
                            Hex4     => Hex4,
                            Hex5     => Hex5,
                            DP_in	 => DP_in
                          );
                                     
ADC_Conversion_ins: 	ADC_Conversion  PORT MAP( --ADC_Conversion test_DE10_Lite
															MAX10_CLK1_50			=>			clk,
															response_valid_out   =>       response_valid_out_i(1)(0), -- added this line
															ADC_out					=>			ADC_read
															);
 
LEDR(9 downto 0) <= Q_temp1(11 downto 2); -- gives visual display of upper binary bits to the LEDs on board

-- in line below, can change the scaling factor (i.e. 2500), to calibrate the voltage reading to a reference voltmeter
voltage <= std_logic_vector(resize(unsigned(Q_temp1)*2500*2/4096,voltage'length));  -- Converting ADC_read a 12 bit binary to voltage readable numbers

distance_out <= distance;

binary_bcd_ins: binary_bcd                               
   PORT MAP(
      clk      => clk,                          
      reset    => reset,                                 
      ena      => '1',                           
      binary   => voltage_bcd,    
      busy     => busy,                         
      bcd      => bcd         
      );
end Behavioral;