-- hw3 - danial riazati(98243029) - zahra kamali(98243047) 
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
PACKAGE base_utils IS
	TYPE out_string IS ARRAY (3 DOWNTO 0) OF std_logic;
	TYPE mode_type IS ARRAY (1 DOWNTO 0) OF std_logic;
	
END base_utils;

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE work.base_utils.ALL;

-- mode 00 one bit logical left shift
-- mode 01 one bit logical right shift
-- mode 10 one bit arithmatic right shift
-- mode 11 one bit circular right shift

ENTITY shift_reg IS
	PORT(
		clk 		: IN 	std_logic;
		rst			: IN 	std_logic;
		serial_in 	: IN	std_logic;
		mode		: IN	mode_type;
		serial_out	: OUT 	std_logic;
		dout		: OUT 	out_string
	);
END shift_reg;

ARCHITECTURE arch OF shift_reg IS
	SIGNAL tmp : out_string;
BEGIN
	PROCESS(clk)
	BEGIN
		IF clk = '1' THEN
			IF rst = '1' THEN
				serial_out <= '0';
				tmp <= "0000";
			ELSE
				IF mode = "00" THEN
					serial_out <= tmp(3);
					tmp <= tmp(2 DOWNTO 0) & serial_in;
				END IF;
			
				IF mode = "01" THEN
					serial_out <= tmp(0);
					tmp <= serial_in & tmp(3 DOWNTO 1);
				END IF;
			
				IF mode = "10" THEN
					serial_out <= tmp(0);
					tmp <= tmp(3) & tmp(3 DOWNTO 1);
				END IF;
			
				IF mode = "11" THEN
					serial_out <= tmp(0);
					tmp <= tmp(0) & tmp(3 DOWNTO 1);
				END IF;
			END IF;
		END IF;		
	END PROCESS;
	dout <= tmp;
END arch;