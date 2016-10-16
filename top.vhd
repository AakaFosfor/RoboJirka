library ieee;
use ieee.std_logic_1164.all;

entity top is
	port(
		Clk50_ik: in std_logic;
		-- encoder input
		EncA_i: in std_logic;
		EncB_i: in std_logic;
		Reset_ir: in std_logic;
		-- upstream interface
		Sck_ik: in std_logic;
		Read_i: in std_logic;
		Data_o: out std_logic;
		-- debug
		Leds_ob: out std_logic_vector(3 downto 1)
	);
end entity;

architecture rtl of top is

	signal ClkDivided_kb: std_logic_vector(11 downto 0);
	signal Position_b: std_logic_vector(15 downto 0);

begin

	cDivider: entity work.divider
		port map (
			clk_in => Clk50_ik,
			clk_out => ClkDivided_kb
		);
	
	cEncoder: entity work.decoder(logic)
		port map (
			clk => ClkDivided_k(10),
			reset => Reset_ir,
			encoder_a => EncA_i,
			encoder_b => EncB_i,
			position => Position_b
		);
	
	cSender: entity work.sender(logic)
		port map (
			position => Position_b,
			data_out => Data_o,
			sck => Sck_ik,
			data_read => Data_o
		);

	Leds_ob <= Position_b(4 downto 2);

end architecture;
