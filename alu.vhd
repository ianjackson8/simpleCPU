library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity alu is
	port(
		A:			in std_logic_vector(7 downto 0);
		B:			in std_logic_vector(7 downto 0);
		ALUOp:	in std_logic_vector(2 downto 0);
		output: out std_logic_vector(7 downto 0)
	);
end alu;

architecture behavior of alu is
begin
process(A,B,ALUOp)
begin
	if(ALUOp = "000") then output <= (A + B);
	elsif(ALUOp = "001") then output <= (A - B);
	elsif(ALUOp = "010") then output <= (A and B);
	elsif(ALUOp = "011") then output <= (A or B);
	elsif(ALUOp = "100") then output <= B;
	elsif(ALUOp = "101") then output <= A;
	end if;
end process;
end behavior;