library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

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
	
	constant c_ClkDividedPosition: integer := 10;
	constant c_PositionWidth: integer := 32;

	signal ClkDivided_b: std_logic_vector(11 downto 0);
	signal Position_b: unsigned(c_PositionWidth-1 downto 0);
	signal Enable: std_logic;

begin

	cDivider: entity work.divider
		port map (
			clk_in => Clk50_ik,
			clk_out => ClkDivided_b
		);
	
	cEnableGenerator: entity work.EdgeDetector(rising)
		port map (
			Clk_ik => Clk50_ik,
			Signal_i => ClkDivided_b(c_ClkDividedPosition),
			Edge_o => Enable
		);
	
	cDecoder: entity work.decoder(logic)
		generic map (
			g_PositionWidth => c_PositionWidth
		)
		port map (
			clk => Clk50_ik,
			Enable_i => Enable,
			reset => Reset_ir,
			encoder_a => EncA_i,
			encoder_b => EncB_i,
			position => Position_b
		);
	
	cSender: entity work.sender(logic)
		generic map (
			g_PositionWidth => c_PositionWidth
		)
		port map (
			Clk_ik => Clk50_ik,
			position => Position_b,
			data_out => Data_o,
			sck => Sck_ik,
			data_read => Data_o
		);

	Leds_ob <= std_logic_vector(Position_b(4 downto 2));

end architecture;
