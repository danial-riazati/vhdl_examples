LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_UNSIGNED.ALL;
ENTITY processor IS
	PORT(
			instruction  	: IN  std_logic_vector(2 DOWNTO 0);
			clk  			: IN  std_logic;
			rst  			: IN  std_logic
			
	);
END processor;

ARCHITECTURE my_arch OF processor IS
	TYPE my_matrix IS ARRAY (0 TO 1023) OF std_logic_vector(31 DOWNTO 0);
	SIGNAL my_memory 	: my_matrix;
	SIGNAL R1 			: std_logic_vector(31 DOWNTO 0);
	SIGNAL R2 			: std_logic_vector(31 DOWNTO 0);
	SIGNAL DR 			: std_logic_vector(31 DOWNTO 0);
	SIGNAL AC 			: std_logic_vector(31 DOWNTO 0);
	SIGNAL AR 			: std_logic_vector(31 DOWNTO 0);
	SIGNAL memory_out	: std_logic_vector(31 DOWNTO 0);
	SIGNAL alu_out 		: std_logic_vector(31 DOWNTO 0);
	SIGNAL bss   		: std_logic_vector(31 DOWNTO 0);
	SIGNAL counter 		: std_logic_vector(1 DOWNTO 0);
	SIGNAL sel  		: std_logic_vector(1 DOWNTO 0);
	SIGNAL func 		: std_logic_vector(1 DOWNTO 0);
	SIGNAL R1_LD 		: std_logic;
	SIGNAL R2_LD 		: std_logic;
	SIGNAL DR_LD 		: std_logic;
	SIGNAL AR_LD 		: std_logic;
	SIGNAL wr   		: std_logic;
	SIGNAL en   		: std_logic;
	SIGNAL counter_rst  : std_logic;
	
	
	
	





BEGIN 

	memory_out <= my_memory(conv_integer(AR));
	
	alu_out <= 	DR        WHEN func = "00" ELSE
				bss        WHEN func = "01" ELSE
				DR + bss   WHEN func = "10" ELSE
				DR - bss;
				
	bss <=  R1 WHEN sel = "00" ELSE 
		   R2 WHEN sel = "01" ELSE
		   AC WHEN sel = "10" ELSE
		   memory_out;


	
	
	controlpath: PROCESS(instruction, counter)
	BEGIN
		R1_LD <= '0';
		R2_LD <= '0';
		DR_LD <= '0';
		AR_LD <= '0';
		wr    <= '0';
		en    <= '0';
		sel   <= "00";
		func  <= "00";
		counter_rst   <= '0';
		
		
		CASE counter IS
			WHEN "00" =>
				CASE instruction IS
					WHEN "000" =>
						sel   <= "01";
						R1_LD <= '1';
						counter_rst   <= '1';
					WHEN "001" =>
						sel   <= "11";
						R1_LD <= '1';			
						counter_rst   <= '1';
					WHEN "010" =>
						sel   <= "00";
						DR_LD <= '1';			
						counter_rst   <= '1';
					WHEN "011" =>
						sel  <= "00";
						en   <= '1';	
						func <= "01";
						counter_rst  <= '1';
					WHEN "100" =>
						sel   <= "00";
						DR_LD <= '1';	
					WHEN "101" =>
						sel   <= "00";
						DR_LD <= '1';
					WHEN "110" =>
						sel   <= "10";
						func  <= "10";
						en    <=  '1';
					WHEN OTHERS =>
						sel   <= "00";
						DR_LD <=  '1';
				END CASE;
			WHEN "01" =>
				CASE instruction IS
					WHEN "100" =>
						sel  <= "01";
						func <= "10";
						en   <=  '1';
						counter_rst  <=  '1';
					WHEN "101" =>
						sel   <= "01";
						func  <= "10";
						en    <= '1';
					WHEN "110" =>
						sel   <= "10";
						AR_LD <=  '1';
						wr  <= '1';
						counter_rst <= '1'; 
					WHEN OTHERS =>
						sel   <= "01";
						func  <= "11";
					    en    <=  '1';
				END CASE;
			WHEN OTHERS =>
				CASE instruction IS
					WHEN "101" =>
						sel    <= "10";
						R1_LD  <=  '1';
						counter_rst    <=  '1';
					WHEN OTHERS =>
						sel   <= "10";
						AR_LD <=  '1';
						wr    <=  '1';
						counter_rst   <=  '1';
				END CASE;
		END CASE;
	END PROCESS controlpath;

	
	datapath: PROCESS(clk)
	BEGIN
		IF clk = '1' THEN
			IF rst = '0' THEN
				R1 <= X"00000012";
				R2 <= X"00000005";
				DR <= X"00000002";
				AR <= X"00000003";
				AC <= X"00000004";
				counter <= "00";
				my_memory <= (0 => X"0000000F", 1 => X"00000009", OTHERS => X"00000000");
			ELSE
				IF R1_LD = '1' THEN
					R1 <= bss;
				END IF;
				IF R2_LD = '1' THEN
					R2 <= bss;
				END IF;
				IF DR_LD = '1' THEN
					DR <= bss;
				END IF;
				IF AR_LD = '1' THEN
					AR <= bss;
				END IF;
				IF wr = '1' THEN
					my_memory(conv_integer(AR)) <= bss;
				END IF;
				IF en = '1' THEN
					AC <= alu_out;
				END IF;
				IF counter_rst = '1' THEN
					counter <= (OTHERS => '0');
				ELSE
					counter <= counter + '1';
				END IF;
			END IF;
		END IF;
	END PROCESS datapath;
	
		   
END my_arch;