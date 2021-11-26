library ieee;
use ieee.std_logic_1164.all;

entity cpu is
	port(
		clk:	in std_logic;
		
		pcOut:		 	out std_logic_vector(7 downto 0);
		marOut:			out std_logic_vector(7 downto 0);
		irOutput:		out std_logic_vector(7 downto 0);
		mdriOutput:		out std_logic_vector(7 downto 0);
		mdroOutput:		out std_logic_vector(7 downto 0);
		aOut:			 	out std_logic_vector(7 downto 0);
		incrementOut:	out std_logic;
		
		ssd1:				out std_logic_vector(6 downto 0);
		ssd2:				out std_logic_vector(6 downto 0);
		ssd3:				out std_logic_vector(6 downto 0)
	);
end;

architecture behavior of cpu is
-- memory component
component memory
	port(
		clk:			in std_logic;
		we:			in std_logic;
		readAddr:	in std_logic_vector(4 downto 0);
		dataIn:		in std_logic_vector(7 downto 0);
		dataOut:   out std_logic_vector(7 downto 0)
	);
end component;

-- alu component
component alu
	port(
		A:			in std_logic_vector(7 downto 0);
		B:			in std_logic_vector(7 downto 0);
		ALUOp:	in std_logic_vector(2 downto 0);
		output: out std_logic_vector(7 downto 0)
	);
end component;

-- register component
component reg
	port(
		clk: 		in std_logic;
		load: 	in std_logic;
		input:	in std_logic_vector(7 downto 0);
		output: out std_logic_vector(7 downto 0)
	);
end component;

-- program counter component
component programCounter
	port(
		clk:			in std_logic;
		increment:	in std_logic;
		output:	  out std_logic_vector(7 downto 0)
	);
end component;

-- mux component
component twoToOneMux
	port(
		A:			in std_logic_vector(7 downto 0);
		B:			in std_logic_vector(7 downto 0);
		address:	in std_logic;
		output: out std_logic_vector(7 downto 0)
	);
end component;

-- seven segment decoder component
component sevenSeg
	port(
		i:  in std_logic_vector(3 downto 0);
		o: out std_logic_vector(6 downto 0)
	);
end component;

-- control unit component
component controlUnit
	port(
		opCode:				in std_logic_vector(2 downto 0);
		clk:					in std_logic;
		toALoad:				out std_logic;
		toMARload:			out std_logic;
		toIRLoad:			out std_logic;
		toMDRILoad:			out std_logic;
		toMDROLoad:			out std_logic;
		toPCIncrement:		out std_logic := '0';
		toMARMux:			out std_logic;
		toRAMWriteEnable:	out std_logic;
		toALUOp:				out std_logic_vector(2 downto 0)
	);
end component;

-- busses
signal RAMDataOutToMDRI:	std_logic_vector(7 downto 0);	-- Ram Data Out -> MRDI
signal pcToMARMux:			std_logic_vector(7 downto 0); -- PC -> MAR Mux
signal muxToMAR:				std_logic_vector(7 downto 0); -- Mux -> MAR
signal MARToRAMReadAddr:	std_logic_vector(7 downto 0); -- RAM Connections
signal MDROToRAMDataIn:		std_logic_vector(7 downto 0); 
signal MDRIOut:				std_logic_vector(7 downto 0); -- MRDI Connection
signal IROut:					std_logic_vector(7 downto 0); -- IR Connection
signal ALUOut:					std_logic_vector(7 downto 0); -- ALU/Acccumulator Connections
signal AToALUB:				std_logic_vector(7 downto 0);
signal CUToALoad:				std_logic; -- Control Unit Connections
signal CUToMARLoad:			std_logic;
signal CUToIRLoad:			std_logic;
signal CUToMDRILoad:			std_logic;
signal CUToMDROLoad:			std_logic;
signal CUToPCIncrement:		std_logic;
signal CUToMARMUX:			std_logic;
signal CUToRAMWriteEnable:	std_logic;
signal CUToALUOp:				std_logic_vector(2 downto 0);

begin
-- memory
mapMemory: memory port map(clk => clk,
									readAddr => MARToRAMReadAddr(4 downto 0),
									dataIn => MDROToRAMDataIn,
									dataOut => RAMDataOutToMDRI,
									we => CUToRAMWriteEnable);

-- accumulator
mapAccumulator: reg port map(clk => clk,
									  load => CUToALoad,
									  input => ALUOut,
									  output => AToALUB);

-- ALU
mapALU: ALU port map(A => MDRIOut,
							B => AToALUB,
							ALUOp => CUToALUOp,
							output => ALUOut);

-- program counter
mapPC: programCounter port map(clk => clk,
										 increment => CUToPCIncrement,
										 output => pcToMARMux);

-- instruction register
mapIR: reg port map(clk => clk,
						  load => CUToIRLoad,
						  input => MDRIOut,
						  output => IROut);

-- MAR Mux
mapMARMux: twoToOneMux port map(A => pcToMARMux,
										  B => IROut,
										  address => CUToMARMUX,
										  output => muxToMAR);

-- memory access register
mapMAR: reg port map (clk => clk,
							 input => muxToMAR,
							 output => MARToRAMReadAddr,
							 load => CUToMARLoad);

-- memory data register input
mapMDRI: reg port map(clk => clk,
							 input => RAMDataOutToMDRI,
							 output => MDRIOut,
							 load => CUToMDRILoad);

-- memory data register output
mapMDRO: reg port map(clk => clk,
							 input => ALUOut,
							 output => MDROToRamDataIn,
							 load => CUToMDROLoad);

-- control unit
mapCU: controlUnit port map(clk => clk,
									 opCode => IROut(7 downto 5),
									 toALoad => CUToALoad,
									 toMARLoad => CUToMARLoad,
									 toIRLoad => CUToIRLoad,
									 toMDRILoad => CUtoMDRILoad,
									 toMDROLoad => CUToMDROLoad,
									 toPCIncrement => CUtoPCIncrement,
									 toMARMux => CUToMARMUX,
									 toRAMWriteEnable => CUtoRAMWriteEnable,
									 toALUOp => CUToALUOp);

-- ssd
aOutHex0: sevenSeg port map(i(3) => AToALUB(3), i(2) => AToALUB(2), i(1) => AToALUB(1), i(0) => AToALUB(0), o(6) => ssd1(6),
									 o(5) => ssd1(5), o(4) => ssd1(4), o(3) => ssd1(3), o(2) => ssd1(2), o(1) => ssd1(1),
									 o(0) => ssd1(0));
aOutHex1: sevenSeg port map(i(3) => '0', i(2) => '0', i(1) => '0', i(0) => AToALUB(4), o(6) => ssd2(6),
									 o(5) => ssd2(5), o(4) => ssd2(4), o(3) => ssd2(3), o(2) => ssd2(2), o(1) => ssd2(1),
									 o(0) => ssd2(0));
pcOutHex5: sevenSeg port map(i(3) => PCToMARMux(3), i(2) => PCToMARMux(2), i(1) => PCToMARMux(1),
									 i(0) => PCToMARMux(0), o(6) => ssd3(6), o(5) => ssd3(5), o(4) => ssd3(4), o(3) => ssd3(3),
									 o(2) => ssd3(2), o(1) => ssd3(1), o(0) => ssd3(0));

pcOut <= PCToMARMux;
irOutput <= IROut;
aOut <= AToALUB;
marOut <= IROut(7 downto 5)&MARToRAMReadAddr(4 downto 0);
mdriOutput <= MDRIOut;
mdroOutput <= MDROToRAMDataIn;
end behavior;