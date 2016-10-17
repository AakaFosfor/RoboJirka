LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY decoder IS
	generic (
		g_PositionWidth: integer
	);
	PORT(
		clk			: IN	STD_LOGIC;
		Enable_i: in std_logic;
		encoder_A	: IN	STD_LOGIC;
		encoder_B	: IN	STD_LOGIC;
		position	: OUT unsigned(g_PositionWidth-1 downto 0) := (OTHERS => '0');
		reset		: IN	STD_LOGIC
	);
END decoder;

ARCHITECTURE logic OF decoder IS
	SIGNAL A			: STD_LOGIC_VECTOR(3 downto 0);
	SIGNAL B			: STD_LOGIC_VECTOR(3 downto 0);
	SIGNAL count		: unsigned(g_PositionWidth-1 downto 0) := to_unsigned(0, g_PositionWidth);
	SIGNAL pulse		: STD_LOGIC;
	SIGNAL dir		: STD_LOGIC;
	signal CountEnable: std_logic;
BEGIN
	--synchronizace pulzu s hodinama
	PROCESS(clk)
	BEGIN
		IF(rising_edge(clk)) THEN
			if Enable_i = '1' then
				A <= A(2 downto 0) & encoder_A;
				B <= B(2 downto 0) & encoder_B;
			end if;
		END IF;
	END PROCESS;

	pulse <= A(3) XOR A(2) XOR B(3) XOR B(2);
	dir <= A(3) XOR B(2);
	
	CountEnable <= Enable_i and pulse;

	--pocitani pulzu
	PROCESS(clk, reset)
	BEGIN
		IF(reset = '0') THEN
			count <= to_unsigned(0, count'length);
		ELSIF(rising_edge(clk)) THEN
			if CountEnable = '1' then
				IF(dir = '1') THEN
					count <= count + '1';
				ELSE
					count <= count - '1';
				END IF;
			end if;
		END IF;
	END PROCESS;

	position <= count;

END logic;