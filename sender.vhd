LIBRARY ieee;
USE ieee.std_logic_1164.all;
use ieee.numeric_std.all;

ENTITY sender IS
	PORT(
		position			: IN unsigned(15 downto 0);
		data_out			: OUT STD_LOGIC;
		sck				: IN STD_LOGIC;
		data_read		: IN STD_LOGIC
		);
END ENTITY;

ARCHITECTURE logic OF sender IS
	SIGNAL position_latch	: STD_LOGIC_VECTOR(15 downto 0);
BEGIN
	
	--posilani dat
	PROCESS(sck, data_read, position)
	BEGIN
		IF(data_read = '0') THEN
			position_latch <= std_logic_vector(position);
		ELSIF(rising_edge(sck)) THEN
			data_out <= position_latch(15);
			position_latch <= position_latch(14 downto 0) & '0';
		END IF;
	END PROCESS;

END ARCHITECTURE;