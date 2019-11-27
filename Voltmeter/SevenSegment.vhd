-- --- Seven segment component
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity SevenSegment is
    Port ( DP_in                       										: in  STD_LOGIC_VECTOR (5 downto 0);
           Num_Hex0,Num_Hex1,Num_Hex2,Num_Hex3,Num_Hex4,Num_Hex5 		: in  STD_LOGIC_VECTOR (3 downto 0);
           Hex0,Hex1,Hex2,Hex3,Hex4,Hex5                         		: out STD_LOGIC_VECTOR (7 downto 0)
          );
end SevenSegment;


architecture Behavioral of SevenSegment is

--Note that component declaration comes after architecture and before begin (common source of error).
   Component SevenSegment_decoder is 
      port(  H     : out STD_LOGIC_VECTOR (7 downto 0);
             input : in  STD_LOGIC_VECTOR (3 downto 0);
             DP    : in  STD_LOGIC                               
          );                  
   end  Component;

type Hex_arr 	  is array(0 to 5) of std_logic_vector(7 downto 0);
type Num_Hex_arr is array(0 to 5) of std_logic_vector(3 downto 0);	
signal Hex 	     : Hex_arr;
signal Num_Hex   : Num_Hex_arr;

begin
--Note that port mapping begins after begin (common source of error).

Hex0 <= Hex(0);
Hex1 <= Hex(1);
Hex2 <= Hex(2);
Hex3 <= Hex(3);
Hex4 <= Hex(4);
Hex5 <= Hex(5);
Num_Hex(0) <= Num_Hex0;
Num_Hex(1) <= Num_Hex1;
Num_Hex(2) <= Num_Hex2;
Num_Hex(3) <= Num_Hex3;
Num_Hex(4) <= Num_Hex4;
Num_Hex(5) <= Num_Hex5;

	GEN: for i in 0 to 5 generate
	begin
		decoder: SevenSegment_decoder port map
													(H     => Hex(i),
													 input => Num_Hex(i),
													 DP    => DP_in(i)
													 );
	end generate GEN;                          
end Behavioral;