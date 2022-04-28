LIBRARY ieee; 
USE ieee.std_logic_1164.ALL; 
USE ieee.std_logic_unsigned.All; --mikhahim unsigned piade sazi konim
--piade sazi fulladder
ENTITY F_Adder IS 
	PORT( 
		cin: IN std_logic;
		x: IN std_logic; 
		y: IN std_logic; 
	 	cout : OUT std_logic;
		s : OUT std_logic
	); 
END F_Adder; 

ARCHITECTURE fa OF F_Adder IS 
BEGIN 
	cout <= (x AND y) or (x AND cin) or (y AND cin); 
	s <= x XOR y XOR cin; 
END fa;


LIBRARY ieee; 
USE ieee.std_logic_1164.ALL; 
USE ieee.std_logic_unsigned.All; --mikhahim unsigned piade sazi konim
ENTITY Multiplier IS 
	GENERIC (SIZE: INTEGER:= 8); 
	PORT (A: IN std_logic_vector (SIZE-1 DOWNTO 0); 
		  B: IN std_logic_vector (SIZE-1 DOWNTO 0); 
		  mult_out: OUT std_logic_vector (2*SIZE-1 DOWNTO 0)
	); 
END Multiplier; 



ARCHITECTURE mul OF Multiplier IS 

--estefade az fulladder sakhte shode
COMPONENT F_Adder 
	PORT( cin: IN std_logic;
		  x  : IN std_logic;
		  y  : IN std_logic;
		  s  : OUT std_logic;
		  cout: OUT std_logic
	); 
END COMPONENT; 
	
TYPE my_matrix IS ARRAY (natural RANGE <>, natural RANGE <>) OF std_logic; 
 
--inital temporary signals to use 
 
-- arayeE 2D baraye negah dari AND(A_i,B_i)
SIGNAL and_bits: my_matrix(SIZE DOWNTO 0, SIZE-1 DOWNTO 0); 

-- arayeE 2D baraye negah dari carryOut fulladder
SIGNAL fa_c: my_matrix(SIZE-1 DOWNTO 0, SIZE-2 DOWNTO 0);

-- arayeE 2D baraye negah dari output fulladder
SIGNAL fa_out: my_matrix(SIZE-1 DOWNTO 0, SIZE-1 DOWNTO 0); 

 
BEGIN 
	F1 : FOR i IN 0 TO SIZE-1 GENERATE  
		f2: FOR j IN 0 TO SIZE-1 GENERATE 
			
			and_bits(i,j) <= A(i) AND B(j); 
			
			IF1: IF i /= SIZE-1 AND j /= SIZE-1 GENERATE 
				Adder1: F_Adder PORT MAP (cin => fa_c(i,j), x => fa_out(i,j+1) , y => and_bits(i+1,j), s => fa_out(i+1,j), cout => fa_c(i+1,j)); 
			END GENERATE;
			
			IF2: IF i = 0 GENERATE 
				fa_out(i,j) <= and_bits(i,j); 
			
			
			END GENERATE; 
		END GENERATE; 
	END GENERATE; 
	
	and_bits(SIZE,0) <= '0'; 
	
    F3: FOR j IN 0 to SIZE-2 GENERATE 
			
			fa_c(0,j) <= '0'; 
			
			fa_out(j+1,SIZE-1) <= and_bits(j+1,SIZE-1);
			
			mult_out(j+1) <= fa_out(j+1,0); 
			
			Adder2: F_Adder PORT MAP (cin => fa_c(SIZE-1,j), x => fa_out(SIZE-1,j+1), y => and_bits(SIZE,j), s => mult_out(SIZE+j), cout => and_bits(SIZE,j+1)); 
	
	END GENERATE; 

	mult_out(0) <= and_bits(0,0); 
	
	mult_out(2*SIZE-1) <= and_bits(SIZE,SIZE-1); 

END mul; 