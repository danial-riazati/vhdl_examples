-- tb for mult 

LIBRARY ieee; 
USE ieee.std_logic_1164.ALL; 
use ieee.std_logic_arith.all; 

ENTITY tb_Multiplier IS 
 generic (SIZE: INTEGER:= 4); 
END tb_Multiplier; 
 
ARCHITECTURE tb OF tb_Multiplier IS  
 COMPONENT Multiplier 
 generic (SIZE: INTEGER:= 4);
 
 PORT( 
		
		A : 		IN 	std_logic_vector(SIZE-1 DOWNTO 0); 
		B : 		IN 	std_logic_vector(SIZE-1 DOWNTO 0); 
		mult_out : 	OUT	std_logic_vector(2*SIZE-1 DOWNTO 0) 
 
 ); 
 
 END COMPONENT; 
 
 SIGNAL tmp_a : std_logic_vector(SIZE-1 DOWNTO 0) := (others => '0'); 
 SIGNAL tmp_b : std_logic_vector(SIZE-1 DOWNTO 0) := (others => '0'); 
 SIGNAL tmp_out : std_logic_vector(2*SIZE-1 DOWNTO 0); 
 
BEGIN 
	Mult1: Multiplier GENERIC MAP(4) PORT MAP(A=>tmp_a,B=>tmp_b,mult_out=>tmp_out);
	-- input 13 and 8 for a
	tmp_a <= X"D" , X"8" after 40 ns;
	
	-- input 10 and 11 for b
	tmp_b <= X"A" , X"B" after 80 ns;

	
END tb; 
