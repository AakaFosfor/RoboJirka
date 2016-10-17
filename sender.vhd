LIBRARY ieee;
USE ieee.std_logic_1164.all;
use ieee.numeric_std.all;

ENTITY sender IS
	generic (
		g_PositionWidth: integer
	);
	PORT(
		Clk_ik: in std_logic;
		position			: IN unsigned(g_PositionWidth-1 downto 0);
		data_out			: OUT STD_LOGIC;
		sck				: IN STD_LOGIC;
		data_read		: IN STD_LOGIC
		);
END ENTITY;

ARCHITECTURE logic OF sender IS
	SIGNAL position_latch	: STD_LOGIC_VECTOR(g_PositionWidth-1 downto 0);
	signal SckSynced, DataReadSynced: std_logic;
	signal SckEdge: std_logic;
BEGIN

	-- input signals synchronization (they are coming from different clock domain!)
	cSyncer: entity work.Delay(syn)
		generic map (
			g_Width => 2,
			g_Delay => 3,
			g_AsyncRegUsed => "TRUE"
		)
		port map (
			Clk_ik => Clk_ik,
			Data_ib(0) => sck,
			Data_ib(1) => data_read,
			Data_ob(0) => SckSynced,
			Data_ob(1) => DataReadSynced
		);
	
	pPositionLatch: process (Clk_ik) is begin
		if rising_edge(Clk_ik) then
			if DataReadSynced = '0' then
				position_latch <= std_logic_vector(position);
			end if;
		end if;
	end process;
	
	cSckEdgeGenerator: entity work.EdgeDetector(rising)
		port map (
			Clk_ik => Clk_ik,
			Signal_i => SckSynced,
			Edge_o => SckEdge
		);
	
	pSendingData: process (Clk_ik) is begin
		if rising_edge(Clk_ik) then
			if SckEdge = '1' then
				data_out <= position_latch(g_PositionWidth-1);
				position_latch <= position_latch(g_PositionWidth-2 downto 0) & '0';
			end if;
		end if;
	end if;
	
END ARCHITECTURE;