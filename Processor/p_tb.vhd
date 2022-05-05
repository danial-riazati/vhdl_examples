LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
ENTITY test_bench IS
ENd test_bench;
ARCHITECTURE test OF test_bench IS
	COMPONENT processor is
		PORT(
				instruction  	: IN  std_logic_vector(2 DOWNTO 0);
				clk  	: IN  std_logic;
				rst  	: IN  std_logic
				
		);
	END COMPONENT;
	
	SIGNAL t_ins  	: std_logic_vector(2 DOWNTO 0);
	SIGNAL t_clk  : std_logic := '0';
	SIGNAL t_rest : std_logic;
	

BEGIN
	u1 : processor PORT MAP (t_ins, t_clk, t_rest);
	
	
	t_rest <= '0', '1' AFTER 24 ns,'0' AFTER 250 ns;
	t_ins <= "000",  "101" AFTER 42 ns,  "111" AFTER 72 ns; 
	t_clk <= NOT t_clk AFTER 5 ns;
END test;