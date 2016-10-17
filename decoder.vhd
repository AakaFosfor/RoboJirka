LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY decoder IS
	PORT(
		clk			: IN	STD_LOGIC;
		encoder_A	: IN	STD_LOGIC;
		encoder_B	: IN	STD_LOGIC;
		position	: OUT unsigned(15 downto 0) := (OTHERS => '0');
		reset		: IN	STD_LOGIC
	);
END decoder;

ARCHITECTURE logic OF decoder IS
	SIGNAL A			: STD_LOGIC_VECTOR(3 downto 0);
	SIGNAL B			: STD_LOGIC_VECTOR(3 downto 0);
	SIGNAL count		: unsigned(15 downto 0) := (OTHERS => '0');
	SIGNAL pulse		: STD_LOGIC;
	SIGNAL dir		: STD_LOGIC;
BEGIN
	--synchronizace pulzu s hodinama
	PROCESS(clk)
	BEGIN
		IF(rising_edge(clk)) THEN
			A <= A(2 downto 0) & encoder_A;
			B <= B(2 downto 0) & encoder_B;
		END IF;
	END PROCESS;

	pulse <= A(3) XOR A(2) XOR B(3) XOR B(2);
	dir <= A(3) XOR B(2);

	--pocitani pulzu
	PROCESS(pulse, dir, reset)
	BEGIN
		IF(reset = '0') THEN
			count <= to_unsigned(0, count'length);
		ELSIF(rising_edge(pulse)) THEN
			IF(dir = '1') THEN
				count <= count + '1';
			ELSE
				count <= count - '1';
			END IF;
		END IF;
	END PROCESS;

	position <= count;

END logic;