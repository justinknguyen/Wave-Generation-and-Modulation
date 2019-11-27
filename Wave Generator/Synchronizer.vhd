library ieee;
use ieee.std_logic_1164.all;

entity Synchronizer is
	generic(	InputSyncRegisterCount : integer := 2;
				Bits	:	integer	:=	1
			);
	port(	clk		:	in  STD_LOGIC;
			reset		:	in  STD_LOGIC;
			input		:	in		std_logic_vector(Bits-1 downto 0);
			output	:	out	std_logic_vector(Bits-1 downto 0)
		);
	end entity;	

architecture rtl of Synchronizer is
	type AR_q_outputs is array (0 to InputSyncRegisterCount) of STD_LOGIC_VECTOR (Bits-1 downto 0);	--Generic
	Signal q_outputs	: 		AR_q_outputs;

	component registers is
		generic(bits : integer := 1);
		port(	clk       : in  std_logic;
				reset     : in  std_logic;
				enable    : in  std_logic;
				d_inputs  : in  std_logic_vector(bits-1 downto 0);
				q_outputs : out std_logic_vector(bits-1 downto 0)	
			);
	end component;

begin	
	q_outputs(0)	<=	input;
	
	syncgen	:	for i in 1 to InputSyncRegisterCount generate	--Generic
	begin
		sync	:	registers
					generic map(bits => Bits)
					port map(
								clk			=>	clk,
								reset			=>	reset,
								enable		=>	'1',
								d_inputs		=>	q_outputs(i-1),
								q_outputs	=>	q_outputs(i)
					);
	end generate syncgen;

	output	<=	q_outputs(q_outputs'length-1);
	
end;