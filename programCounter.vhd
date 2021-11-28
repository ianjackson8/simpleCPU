library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity programCounter is
	port(
		clk:			in std_logic;
		increment:	in std_logic;
		output:	  out std_logic_vector(7 downto 0)
	);
end programCounter;

architecture behavior of programCounter is
begin
process(clk,increment)
	variable counter: integer := 0;
	begin
		if (clk'event and clk='1' and increment = '1') then
			counter := counter + 1;
			output <= conv_std_logic_vector(counter,8);
		end if;
end process;
end behavior;