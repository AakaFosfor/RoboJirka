library ieee;
use ieee.std_logic_1164.all;

entity Delay is
	generic (
		g_Width: integer := 1;
		g_Delay: integer := 5;
		g_AsyncRegUsed: string := "FALSE"
	);
	port (
		Clk_ik: in std_logic;
		Data_ib: in std_logic_vector(g_Width-1 downto 0);
		Data_ob: out std_logic_vector(g_Width-1 downto 0)
	);
end entity;

architecture syn of Delay is

	attribute ASYNC_REG: string;

	signal ShiftRegister: std_logic_vector((g_Width*(g_Delay+1))-1 downto g_Width-1) := (others => '0');

	attribute ASYNC_REG of ShiftRegister: signal is g_AsyncRegUsed;

begin

	gDelay: if g_Delay > 0 generate
		pDelay: process (Clk_ik) begin
			if rising_edge(Clk_ik) then
				for i in 1 to g_Delay loop
					if i = 1 then
						ShiftRegister((g_Width*(i+1))-1 downto g_Width*i) <= Data_ib;
					else
						ShiftRegister((g_Width*(i+1))-1 downto g_Width*i) <= ShiftRegister((g_Width*i)-1 downto g_Width*(i-1));
					end if;
				end loop;
			end if;
		end process pDelay;
	end generate gDelay;

	gOutputWithDelay: if g_Delay > 0 generate
		Data_ob <= ShiftRegister((g_Width*(g_Delay+1))-1 downto g_Width*g_Delay);
	end generate;
	
	gOutputWithoutDelay: if g_Delay = 0 generate
		Data_ob <= Data_ib;
	end generate;

end architecture;
