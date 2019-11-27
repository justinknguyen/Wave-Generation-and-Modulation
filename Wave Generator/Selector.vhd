library ieee;
use ieee.std_logic_1164.all;

entity Selector is
	port(
			pulse			:	in		STD_LOGIC_VECTOR(23 downto 0);
			freqcount	:	in		STD_LOGIC_VECTOR(4 downto 0);
			ampcount		:	in		STD_LOGIC_VECTOR(4 downto 0);
			pulseFinal	:	out	STD_LOGIC;
			ampFinal		:	out	std_logic_vector(8 downto 0)
		);
	end entity;	

architecture rtl of Selector is
begin
	freq_selector : process(freqcount, pulse)
		begin
			case freqcount is
				when "00000"	=>
					pulseFinal	<=	pulse(0);
				when "00001"	=>
					pulseFinal	<=	pulse(1);
				when "00010"	=>
					pulseFinal	<=	pulse(2);
				when "00011"	=>
					pulseFinal	<=	pulse(3);
				when "00100"	=>
					pulseFinal	<=	pulse(4);
				when "00101"	=>
					pulseFinal	<=	pulse(5);
				when "00110"	=>
					pulseFinal	<=	pulse(6);
				when "00111"	=>
					pulseFinal	<=	pulse(7);
				when "01000"	=>
					pulseFinal	<=	pulse(8);
				when "01001"	=>
					pulseFinal	<=	pulse(9);
				when "01010"	=>
					pulseFinal	<=	pulse(10);
				when "01011"	=>
					pulseFinal	<=	pulse(11);
				when "01100"	=>
					pulseFinal	<=	pulse(12);
				when "01101"	=>
					pulseFinal	<=	pulse(13);
				when "01110"	=>
					pulseFinal	<=	pulse(14);
				when "01111"	=>
					pulseFinal	<=	pulse(15);
				when "10000"	=>
					pulseFinal	<=	pulse(16);
				when "10001"	=>
					pulseFinal	<=	pulse(17);
				when "10010"	=>
					pulseFinal	<=	pulse(18);
				when "10011"	=>
					pulseFinal	<=	pulse(19);
				when "10100"	=>
					pulseFinal	<=	pulse(20);
				when "10101"	=>
					pulseFinal	<=	pulse(21);
				when "10110"	=>
					pulseFinal	<=	pulse(22);
				when others	=>
					pulseFinal	<=	pulse(0);
				end case;
	end process;
	
	amp_selector : process(ampcount)
		begin
			case ampcount is
				when "00000"	=>
					ampFinal	<=	"000000001";
				when "00001"	=>
					ampFinal	<=	"000010001";
				when "00010"	=>
					ampFinal	<=	"000100001";
				when "00011"	=>
					ampFinal	<=	"000110010";
				when "00100"	=>
					ampFinal	<=	"001000010";
				when "00101"	=>
					ampFinal	<=	"001010011";
				when "00110"	=>
					ampFinal	<=	"001100011";
				when "00111"	=>
					ampFinal	<=	"001110100";
				when "01000"	=>
					ampFinal	<=	"010000100";
				when "01001"	=>
					ampFinal	<=	"010010101";
				when "01010"	=>
					ampFinal	<=	"010100101";
				when "01011"	=>
					ampFinal	<=	"010110101";
				when "01100"	=>
					ampFinal	<=	"011000110";
				when "01101"	=>
					ampFinal	<=	"011010110";
				when "01110"	=>
					ampFinal	<=	"011100111";
				when "01111"	=>
					ampFinal	<=	"011110111";
				when "10000"	=>
					ampFinal	<=	"100001000";
				when "10001"	=>
					ampFinal	<=	"100011000";
				when "10010"	=>
					ampFinal	<=	"100101001";
				when "10011"	=>
					ampFinal	<=	"100111001";
				when "10100"	=>
					ampFinal	<=	"101001010";
				when "10101"	=>
					ampFinal	<=	"101011010";
				when "10110"	=>
					ampFinal	<=	"101101010";
				when "10111"	=>
					ampFinal	<=	"101111011";
				when "11000"	=>
					ampFinal	<=	"110001011";
				when "11001"	=>
					ampFinal	<=	"110011100";
				when "11010"	=>
					ampFinal	<=	"110101100";
				when "11011"	=>
					ampFinal	<=	"110111101";
				when "11100"	=>
					ampFinal	<=	"111001101";
				when "11101"	=>
					ampFinal	<=	"111011110";
				when "11110"	=>
					ampFinal	<=	"111101110";
				when "11111"	=>
					ampFinal	<=	"111111111";
				when others	=>
					ampFinal	<=	"111111111";
				end case;
	end process;
end;