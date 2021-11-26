library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity sevenSeg is
	port(
		i:  in std_logic_vector(3 downto 0);
		o: out std_logic_vector(6 downto 0)
	);
end sevenSeg;

architecture behavior of sevenSeg is

component binary2hex
	port(
		--inputs
		W: in std_logic;
		X: in std_logic;
		Y: in std_logic;
		Z: in std_logic;
		
		--outputs
		a: out std_logic;
		b: out std_logic;
		c: out std_logic;
		d: out std_logic;
		e: out std_logic;
		f: out std_logic;
		g: out std_logic
	);
end component;

begin
sgd: binary2hex port map(W => i(3), X => i(2), Y => i(1), Z => i(0), a => o(6), b => o(5), c => o(4), d => o(3),
									e => o(2), f => o(1), g => o(0));
end behavior;