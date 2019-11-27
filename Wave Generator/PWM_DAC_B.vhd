library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity PWM_DAC_B is
   Generic ( width : integer := 13);
   Port    ( reset      : in STD_LOGIC;
             clk        : in STD_LOGIC;
             duty_cycle : in STD_LOGIC_VECTOR (width-1 downto 0);
             pwm_out    : out STD_LOGIC
           );
end PWM_DAC_B;

architecture Behavioral of PWM_DAC_B is
   signal counter : unsigned (width-1 downto 0);
       
begin
   count : process(clk,reset)
   begin
       if( reset = '1') then
           counter <= (others => '0');
       elsif (rising_edge(clk)) then 
           counter <= counter + 1;
       end if;
   end process;
 
   compare : process(counter, duty_cycle)
   begin    
       if (counter < unsigned(duty_cycle)) then
           pwm_out <= '1';
       else 
           pwm_out <= '0';
       end if;
   end process;
  
end Behavioral;