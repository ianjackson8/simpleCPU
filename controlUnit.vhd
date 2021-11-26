library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity controlUnit is
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
end controlUnit;

architecture behavior of controlUnit is

type cuStateType is(load_mar, read_mem, load_mdri, load_ir, decode, ldaa_load_mar, ldaa_read_mem, ldaa_load_mdri,
						  ldaa_load_a, adaa_load_mar, adaa_read_mem, adaa_load_mdri, adaa_store_load_a, staa_load_mdro,
						  staa_write_mem, increment_pc);

signal currentState: cuStateType;

begin 
process(clk)
begin
	if(clk'event and clk='1') then
		case currentState is
			-- decode instruction
			when increment_pc => 
				currentState <= load_mar;
			when load_mar =>
				currentState <= read_mem;
			when read_mem => 
				currentState <= load_mdri;
			when load_mdri =>
				currentState <= load_ir;
			when load_ir =>
				currentState <= decode;
			
			-- determine instruction
			when decode =>
				if opCode = "000" then
					currentState <= ldaa_load_mar;
				elsif opCode = "001" then
					currentState <= adaa_load_mar;
				elsif opCode = "010" then
					currentState <= staa_load_mdro;
				else
					currentState <= increment_pc;
				end if;
			
			-- load instruction
			when ldaa_load_mar => 
				currentState <= ldaa_read_mem;
			when ldaa_read_mem =>
				currentState <= ldaa_load_mdri;
			when ldaa_load_mdri =>
				currentState <= ldaa_load_a;
			when ldaa_load_a =>
				currentState <= increment_pc;
				
			-- add instruction
			when adaa_load_mar =>
				currentState <= adaa_read_mem;
			when adaa_read_mem =>
				currentState <= adaa_load_mdri;
			when adaa_load_mdri =>
				currentState <= adaa_store_load_a;
			when adaa_store_load_a =>
				currentState <= increment_pc;
			
			-- store instruction
			when staa_load_mdro =>
				currentState <= staa_write_mem;
			when staa_write_mem =>
				currentState <= increment_pc;
			
		end case;
	end if;
end process;

process(currentState)
begin
	toALoad <= '0';
	toMDROLoad <= '0';
	toALUOp <= "000";
	case currentState is
		when increment_pc =>
			toALoad <= '0';
			toPCIncrement <= '1';
			toMARMux <= '0';
			toMARLoad <= '0';
			toRAMWriteEnable <= '0';
			toMDRILoad <= '0';
			toIRLoad <= '0';
			toMDROLoad <= '0';
			toALUOp <= "000";
		when load_mar => 
			toALoad <= '0';
			toPCIncrement <= '0';
			toMARMux <= '0';
			toMARLoad <= '1';
			toRAMWriteEnable <= '0';
			toMDRILoad <= '0';
			toIRLoad <= '0';
			toMDROLoad <= '0';
		when read_mem =>
			toALoad <= '0';
			toPCIncrement <= '0';
			toMARMux <= '0';
			toMARLoad <= '0';
			toRAMWriteEnable <= '0';
			toMDRILoad <= '0';
			toIRLoad <= '0';
			toMDROLoad <= '0';
		when load_mdri => --CODED
			toALoad <= '0';
			toPCIncrement <= '0';
			toMARMux <= '0';
			toMARLoad <= '0';
			toRAMWriteEnable <= '0';
			toMDRILoad <= '1';
			toIRLoad <= '0';
			toMDROLoad <= '0';
		when load_ir => --CODED
			toALoad <= '0';
			toPCIncrement <= '0';
			toMARMux <= '0';
			toMARLoad <= '0';
			toRAMWriteEnable <= '0';
			toMDRILoad <= '0';
			toIRLoad <= '1';
			toMDROLoad <= '0';
		when decode => --CODED
			toALoad <= '0';
			toPCIncrement <= '0';
			toMARMux <= '0';
			toMARLoad <= '0';
			toRAMWriteEnable <= '0';
			toMDRILoad <= '0';
			toIRLoad <= '0';
			toMDROLoad <= '0';
		when ldaa_load_mar =>
			toALoad <= '0';
			toPCIncrement <= '0';
			toMARMux <= '1';
			toMARLoad <= '1';
			toRAMWriteEnable <= '0';
			toMDRILoad <= '0';
			toIRLoad <= '0';
			toMDROLoad <= '0';
			toALUOp <= "101";
		when ldaa_read_mem => --CODED
			toALoad <= '0';
			toPCIncrement <= '0';
			toMARMux <= '0';
			toMARLoad <= '0';
			toRAMWriteEnable <= '0';
			toMDRILoad <= '0';
			toIRLoad <= '0';
			toMDROLoad <= '0';
		when ldaa_load_mdri =>
			toALoad <= '0';
			toPCIncrement <= '0';
			toMARMux <= '0';
			toMARLoad <= '0';
			toRAMWriteEnable <= '0';
			toMDRILoad <= '1';
			toIRLoad <= '0';
			toMDROLoad <= '0';
			toALUOp <= "101";
		when ldaa_load_a => --CODED
			toALoad <= '1';
			toPCIncrement <= '0';
			toMARMux <= '0';
			toMARLoad <= '0';
			toRAMWriteEnable <= '0';
			toMDRILoad <= '0';
			toIRLoad <= '0';
			toMDROLoad <= '0';
			toALUOp <= "101";
		when adaa_load_mar => 
			toALoad <= '0';
			toPCIncrement <= '0';
			toMARMux <= '1';
			toMARLoad <= '1';
			toRAMWriteEnable <= '0';
			toMDRILoad <= '0';
			toIRLoad <= '0';
			toMDROLoad <= '0';
			toALUOp <= "000";
		when adaa_read_mem => --CODED
			toALoad <= '0';
			toPCIncrement <= '0';
			toMARMux <= '0';
			toMARLoad <= '0';
			toRAMWriteEnable <= '0';
			toMDRILoad <= '0';
			toIRLoad <= '0';
			toMDROLoad <= '0';
		when adaa_load_mdri => --CODED
			toALoad <= '0';
			toPCIncrement <= '0';
			toMARMux <= '0';
			toMARLoad <= '0';
			toRAMWriteEnable <= '0';
			toMDRILoad <= '1';
			toIRLoad <= '0';
			toMDROLoad <= '0';
		when adaa_store_load_a =>
			toALoad <= '1';
			toPCIncrement <= '0';
			toMARMux <= '0';
			toMARLoad <= '0';
			toRAMWriteEnable <= '0';
			toMDRILoad <= '0';
			toIRLoad <= '0';
			toMDROLoad <= '0';
			toALUOp <= "000";
		when staa_load_mdro =>
			toALoad <= '0';
			toPCIncrement <= '0';
			toMARMux <= '1';
			toMARLoad <= '1';
			toRAMWriteEnable <= '0';
			toMDRILoad <= '0';
			toIRLoad <= '0';
			toMDROLoad <= '1';
			toALUOp <= "100";
		when staa_write_mem => --CODED
			toALoad <= '0';
			toPCIncrement <= '0';
			toMARMux <= '0';
			toMARLoad <= '0';
			toRAMWriteEnable <= '1';
			toMDRILoad <= '0';
			toIRLoad <= '0';
			toMDROLoad <= '0';
	end case;
end process;
end behavior;