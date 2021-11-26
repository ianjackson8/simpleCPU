library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity memory is
	generic(width: integer := 8; depth: integer := 32; addr: integer := 5);
	port(
		clk:			in std_logic;
		we:			in std_logic;
		readAddr:	in std_logic_vector(4 downto 0);
		dataIn:		in std_logic_vector(7 downto 0);
		dataOut:   out std_logic_vector(7 downto 0)
	);
end memory;

architecture behavior of memory is

type ram_type is array(0 to 31) of std_logic_vector(7 downto 0);
signal mem: ram_type := ("00000101", "00100011", "01000111", "00000111", "00101000",
								 "00000110", "00010100", "00001101", "00000001", others=>(others=>'0'));

begin
process(clk, we)
begin
	if clk'event and clk='0' then
		if we = '0' then
			dataOut <= mem(conv_integer(readAddr));
		elsif we = '1' then
			mem(conv_integer(readAddr)) <= dataIn;
		end if;
	end if;
end process;
end behavior;