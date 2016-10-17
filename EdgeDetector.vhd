library ieee;
use ieee.std_logic_1164.all;

entity EdgeDetector is
	port (
		Clk_ik: in std_logic;
		Signal_i: in std_logic;
		Edge_o: out std_logic
	);
end entity;

architecture rising of EdgeDetector is

	signal History: std_logic := '0';

begin
	
	pDelay: process (Clk_ik) is begin
		if rising_edge(Clk_ik) then
			History <= Signal_i;
		end if;
	end process;
	
	Edge_o <= Signal_i and not History;

end architecture;

architecture falling of EdgeDetector is
	
	signal History: std_logic := '0';
	
begin
	
	pDelay: process (Clk_ik) is begin
		if rising_edge(Clk_ik) then
			History <= Signal_i;
		end if;
	end process;
	
	Edge_o <= not Signal_i and History;
	
end architecture;

architecture both of EdgeDetector is
	
	signal History: std_logic := '0';
	
begin
	
	pDelay: process (Clk_ik) is begin
		if rising_edge(Clk_ik) then
			History <= Signal_i;
		end if;
	end process;
	
	Edge_o <= Signal_i xor History;
	
end architecture;
