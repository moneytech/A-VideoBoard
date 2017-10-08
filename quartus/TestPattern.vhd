library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;

entity TestPattern is	
	port (
		-- external oscillator
		CLK50 : in std_logic;
				
		-- digital YPbPr output
		Y: out std_logic_vector(5 downto 0);
		Pb: out std_logic_vector(4 downto 0);
		Pr: out std_logic_vector(4 downto 0)
	);	
end entity;


architecture immediate of TestPattern is
	
   component PLL is
	PORT
	(
		inclk0		: IN STD_LOGIC  := '0';
		c0		: OUT STD_LOGIC 
	);
	end component;

	signal CLK224 : std_logic;
	signal CLK8 : std_logic;
	

begin		
	-- internally create a high frequency to derive everything else from
	highfrequency: PLL port map ( CLK50, CLK224 );

	-- generate a 8Mhz pixel clock from 224Mhz (divide by 28)
	process (CLK224) 
	variable cnt: integer range 0 to 13 := 0;
	variable out_clk : std_logic := '0';
	begin
		if rising_edge(CLK224) then
			if cnt<13 then
				cnt := cnt+1;
			else
				cnt := 0;
				out_clk := not out_clk;
			end if;
		end if;	
		CLK8 <= out_clk;
	end process;
	
--
--	-- generate the calibration signal
--	process (CLK8) 
--	variable cnt: integer range 0 to 31 := 0;
--	variable sync: std_logic := '0';
--	variable lum: integer range 0 to 15 := 0;
--	begin
--		if rising_edge(CLK8) then
--			if cnt<31 then 
--				cnt := cnt+1;
--			else
--				cnt := 0;
--			end if;
--			lum := 0;
--			sync := '1';
--			if cnt<=15 then
--				lum := cnt;
--			end if;
--			if (cnt>=20 and cnt<25) or (cnt=26 or cnt=28) then
--				sync := '0';
--			end if;
--		end if;
--		
--		CSYNC <= sync;
--		Y  <= std_logic_vector(to_unsigned(lum,4));
----		Pb <= "0000";
----		Pr <= "0000";	
--	end process;

	-- generate a test image
	process (CLK8) 
	
  	type T_ataripalette is array (0 to 255) of integer range 0 to 65535;
   constant ataripalette : T_ataripalette := (
        16#4e10#,16#5a10#,16#6610#,16#7210#,16#7e10#,16#8a10#,16#9610#,16#a210#,16#ae10#,16#ba10#,16#c610#,16#d210#,16#de10#,16#ea10#,16#f610#,16#fe10#,
        16#5dd2#,16#65b2#,16#6d93#,16#7574#,16#7d55#,16#8556#,16#8d37#,16#9517#,16#9cf8#,16#a4d9#,16#acda#,16#b4f9#,16#c117#,16#c936#,16#d555#,16#dd94#,
        16#55d3#,16#59d4#,16#5dd5#,16#61b7#,16#69b8#,16#6d99#,16#719a#,16#759c#,16#797d#,16#7d7e#,16#815f#,16#917e#,16#a19c#,16#ad9a#,16#bdb8#,16#cdb6#,
        16#5a12#,16#5e14#,16#6215#,16#6616#,16#6e17#,16#7218#,16#763a#,16#7a3b#,16#823c#,16#863d#,16#8a3e#,16#9a3d#,16#a63b#,16#b619#,16#c217#,16#d215#,
        16#5a32#,16#6253#,16#6674#,16#6a76#,16#7297#,16#76b8#,16#7eb9#,16#82da#,16#8afb#,16#8efc#,16#931d#,16#a2fc#,16#aeda#,16#bab8#,16#c697#,16#d675#,
        16#5651#,16#5e72#,16#6293#,16#66b3#,16#6ad4#,16#6ef5#,16#7315#,16#7b36#,16#7f57#,16#8377#,16#8798#,16#9757#,16#a336#,16#b2f5#,16#c2d4#,16#ce93#,
        16#5250#,16#5690#,16#5ab0#,16#5ad0#,16#5ef1#,16#6311#,16#6731#,16#6751#,16#6b91#,16#6fb1#,16#6fd1#,16#8391#,16#9351#,16#a331#,16#b6f1#,16#c6b0#,
        16#524f#,16#568e#,16#5aae#,16#5ecd#,16#5eed#,16#630d#,16#672c#,16#674c#,16#6b8c#,16#6fab#,16#73cb#,16#838b#,16#934c#,16#a72d#,16#b6ed#,16#c6ae#,
        16#5e2d#,16#624d#,16#6a6c#,16#728b#,16#76aa#,16#7ea9#,16#82c8#,16#8ae8#,16#9307#,16#9726#,16#9f25#,16#ab06#,16#b6e8#,16#c2c9#,16#ceaa#,16#da6b#,
        16#662c#,16#6e2b#,16#7a2a#,16#8248#,16#8e47#,16#9666#,16#a265#,16#aa63#,16#b682#,16#be81#,16#caa0#,16#d281#,16#d663#,16#de65#,16#e247#,16#ea49#,
        16#61ed#,16#6deb#,16#75ea#,16#7de9#,16#89e8#,16#91e7#,16#99c5#,16#a5c4#,16#adc3#,16#b5c2#,16#c1c1#,16#c9c2#,16#d1c4#,16#d5e6#,16#dde8#,16#e5ea#,
        16#61cd#,16#69ac#,16#718b#,16#7989#,16#8568#,16#8d47#,16#9546#,16#9d25#,16#a504#,16#ad03#,16#b8e2#,16#c103#,16#c925#,16#d147#,16#d968#,16#e18a#,
        16#65ae#,16#6d8d#,16#756c#,16#814c#,16#892b#,16#950a#,16#9cea#,16#a8c9#,16#b0a8#,16#bc88#,16#c467#,16#cca8#,16#d0c9#,16#d90a#,16#e12b#,16#e96c#,
        16#69af#,16#756f#,16#7d4f#,16#892f#,16#950e#,16#a0ee#,16#acce#,16#b8ae#,16#c46e#,16#d04e#,16#dc2e#,16#e06e#,16#e4ae#,16#e8ce#,16#ed0e#,16#f14f#,
        16#69b0#,16#7571#,16#7d51#,16#8932#,16#9512#,16#a0f2#,16#acd3#,16#b8b3#,16#c473#,16#d054#,16#d834#,16#dc74#,16#e4b3#,16#e8d2#,16#ed12#,16#f151#,
        16#5dd2#,16#65b2#,16#6d93#,16#7574#,16#7d55#,16#8556#,16#8d37#,16#9517#,16#9cf8#,16#a4d9#,16#acda#,16#b4f9#,16#c117#,16#c936#,16#d555#,16#dd94#	  
	 );	
	constant sync : integer := 0 + 16*32 + 16;
	
	
	constant w: integer := 512;  -- (64 microseconds)
	constant h: integer := 312;
	variable cx: integer range 0 to w-1 := 0;
	variable cy: integer range 0 to h-1 := 0;
	
	variable out_ypbpr: integer range 0 to 65535 := 0;
	
	variable micros: integer range 0 to 63;
	variable px: integer range 0 to 319;
	variable py: integer range 0 to 255;
	variable tmp_ypbpr: std_logic_vector(15 downto 0);
	begin
		if rising_edge(CLK8) then
		
			-- idle black
			out_ypbpr := ataripalette(0);

			-- compute sync pulses
			micros := cx/8;
			if (cy=0 or cy=1) and (micros<30 or (micros>=32 and micros<62)) then  -- long syncs
				out_ypbpr := sync;
			end if;
			if cy=2 and (micros<30 or (micros>=32 and micros<34)) then           -- one long, one short sync
				out_ypbpr := sync;
			end if;
			if (cy=3 or cy=4) and (micros<2 or (micros>=32 and micros<34)) then   -- short syncs
				out_ypbpr := sync;
			end if;
			if (cy>=5 and cy<309) and (micros<4) then                             -- normal syncs
				out_ypbpr := sync;
			end if;
			if cy>=309 and (micros<2 or (micros>=32 and micros<34)) then         -- short syncs
				out_ypbpr := sync;
			end if;
			

			-- compute image
			if cx>=134 and cx<134+320 and cy>=38 and cy<38+256 then
				px := cx-134;
				py := cy-38;
				
				out_ypbpr := ataripalette(4);
				if px=0 or py=0 or px=319 or py=255 then
					out_ypbpr := ataripalette(8);
				else				
					if px>=16 and py>=32 and px<16+16*8 and py<32+16*8 then
						out_ypbpr := ataripalette( ((px-16)/8) + ((py-32)/8) * 16 );
					elsif px>=16 and px<16+45*4 and py>=180 and py<200 then					
						out_ypbpr := (19 + (px-16)/4)*1024 + 16*32 + 16;
					end if;
				
				end if;
			end if;
			
			-- progress horizontal and vertical counters
			if cx<w-1 then
				cx:=cx+1;
			else
				cx:=0;
				if cy<h-1 then
					cy:=cy+1;
				else
					cy:=0;
				end if;
			end if;
		end if;

		tmp_ypbpr := std_logic_vector(to_unsigned(out_ypbpr,16));
		Y  <= tmp_ypbpr(15 downto 10);
		PB <= tmp_ypbpr(9 downto 5);
		PR <= tmp_ypbpr(4 downto 0);
	end process;


end immediate;

