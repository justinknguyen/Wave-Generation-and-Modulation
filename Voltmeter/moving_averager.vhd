--SOURCE: https://stackoverflow.com/questions/38897085/vhdl-moving-average-simulation-synthesis-result-differ-vivado

library ieee;
use ieee.std_logic_1164.all;
use ieee.math_real.all;
use ieee.numeric_std.all;


entity moving_averager is
	generic (
				  sample_count          : integer := 512
				);
	port (
			  clk                       : in  std_logic;
			  reset                     : in  std_logic;
			  EN                 		 : in  std_logic;
			  Din                       : in  std_logic_vector(11 downto 0);
			  Q                         : out std_logic_vector(11 downto 0)
			);
end moving_averager;


architecture rtl of moving_averager is

    type     sample_buff_t    is array (1 to sample_count) of std_logic_vector(11 downto 0);
    signal   sample_buffer  : sample_buff_t;
    signal   sum            : std_logic_vector(sample_count-1 downto 0);
	 constant wid_shift      : integer := integer(ceil(log2(real(sample_count))));
    signal   avg_interm_s   : std_logic_vector(sample_count-1 downto 0);

begin

    process (clk, reset) begin
        if reset='1' then
            sample_buffer <= (others => Din);
            sum <= std_logic_vector(unsigned(resize(unsigned(Din), sum'length))  sll wid_shift) ;
				
        elsif rising_edge(clk) then
			if EN='1' then
					sample_buffer <= Din & sample_buffer(1 to sample_count-1);
					sum <= std_logic_vector(unsigned(sum) + unsigned(Din) - unsigned(sample_buffer(sample_count)));
			end if;
				
        end if;
    end process;

    avg_interm_s <= std_logic_vector((unsigned(sum) srl wid_shift));
    Q <= avg_interm_s(11 downto 0);
	 
end rtl;