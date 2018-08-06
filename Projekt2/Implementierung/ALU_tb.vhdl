library ieee;					-- {
use ieee.numeric_std.all;		-- Libraries needed for the implementation
use ieee.std_logic_1164.all;	-- }

entity ALU_tb is
end ALU_tb;

architecture ALU_tb_architecture of ALU_tb is	
	component ALU_entity
		port
		(
		r_in: in unsigned (15 downto 0);		-- R entry
		s_in: in unsigned (15 downto 0);		-- S entry
		op: in std_logic_vector (2 downto 0);	-- Opcode
	
		carry_in: in std_logic;		-- Carry entry
		clk: in std_logic;			-- Clock entry
		ce: in std_logic;			-- Enable Bit entry
	
		f_out: out unsigned (15 downto 0);		-- F exit (result of the operation)
	
		carry_out: out std_logic;	-- Carry flag exit
		sign: out std_logic;		-- Sign flag exit	
		zero: out std_logic			-- Zero flag exit
		);
	end component;
	
	signal r_in, s_in, f_out: unsigned (15 downto 0);				-- {
	signal op: std_logic_vector (2 downto 0);						-- Create signals for testing
	signal carry_in, clk, ce, carry_out, sign, zero: std_logic;		-- }
	
	begin
	
	ALU_map: ALU_entity port map (r_in => r_in, s_in => s_in, f_out => f_out, op => op, carry_in => carry_in,	-- Mapping the entrys and exits of the ALU to the ones
	clk => clk, ce => ce, carry_out => carry_out, sign => sign, zero => zero);									-- of the testbench
	
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------	
	
	process begin
	
	r_in <= "UUUUUUUUUUUUUUUU";		-- {
	s_in <= "UUUUUUUUUUUUUUUU";
	op <= "UUU";
									-- Setting start values
	carry_in <= 'U';
	clk <= 'U';
	ce <= 'U';						-- }
	
	wait for 10 ns; -- wait for 1/2 Clock period
	
	assert (f_out = "0000000000000000" and carry_out = '0' and sign = '0' and zero = '1')
	report "Something went wrong at the 1st assertion";	-- As there is a non numeric value, the result is set to 0
	
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------	
	
	r_in <= "0001100000010010";		-- R <= 6162
	s_in <= "0000011011110010";		-- S <= 1778
	op <= "000";					-- Addition
	
	carry_in <= '0';				-- Carry is set to 0
	clk <= '0';						-- Clock is set to 0
	ce <= '1';						-- Ce is set to 1
	
	wait for 10 ns; -- wait for 1/2 Clock period	
	
	assert (f_out = "0000000000000000" and carry_out = '0' and sign = '0' and zero = '1')
	report "Something went wrong at the 2nd assertion";	-- As Clock isn´t set, nothing should change.
	
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	
	r_in <= "0001100000010010";		-- R <= 6162
	s_in <= "0000011011110010";		-- S <= 1778
	op <= "000";					-- Addition => All the same as above
	
	carry_in <= '0';
	clk <= '1';						-- Clock is set to 1 
	ce <= '1';
	
	wait for 10 ns;	-- wait for 1/2 Clock period	
	
	assert (f_out = "0001111100000100" and carry_out = '0' and sign = '0' and zero = '0')
	report "Something went wrong at the 3rd assertion";	-- Result of 6162 + 1778 should be 7940. Carry-, sign- and zero flag should not be set.
	
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	
	r_in <= "1001001000111010";		-- R <= 37434
	s_in <= "1010000101111000";		-- S <= 41336
	op <= "000";					-- Addition
	
	carry_in <= '1';				-- Carry is set to 1
	clk <= '0';						-- Clock is set to 0
	ce <= '1';						
	
	wait for 10 ns; -- wait for 1/2 Clock period	
	
	assert (f_out = "0001111100000100" and carry_out = '0' and sign = '0' and zero = '0')
	report "Something went wrong at the 4th assertion";	-- As Clock isn´t set, nothing should change.
	
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	
	r_in <= "1001001000111010";		-- R <= 37434
	s_in <= "1010000101111000";		-- S <= 41336
	op <= "000";					-- Addition => All the same as above
	
	carry_in <= '1';				
	clk <= '1';						-- Clock is set to 1
	ce <= '1';						
	
	wait for 10 ns; -- wait for 1/2 Clock period	
	
	assert (f_out = "0011001110110011" and carry_out = '1' and sign = '0' and zero = '0')
	report "Something went wrong at the 5th assertion";	-- Result of 37434 + 41336 should be 78770. As the Carry entry is set: Result should be 78770 + 1 = 78771.
															-- Carry flag should be set. Sign- and zero flag should not be set.
	
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	
	r_in <= "1100001001111001";		-- R <= 49785
	s_in <= "0100110111101110";		-- S <= 19950
	op <= "001";					-- S - R
	
	carry_in <= '1';				
	clk <= '0';						-- Clock is set to 0
	ce <= '1';
	
	wait for 10 ns;	-- wait for 1/2 Clock period
	
	assert (f_out = "0011001110110011" and carry_out = '1' and sign = '0' and zero = '0')
	report "Something went wrong at the 6th assertion";	-- As Clock isn´t set, nothing should change.

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	
	r_in <= "1100001001111001";		-- R <= 49785
	s_in <= "0100110111101110";		-- S <= 19950
	op <= "001";					-- S - R => All the same as above
	
	carry_in <= '1';				
	clk <= '1';						-- Clock is set to 1
	ce <= '1';
	
	wait for 10 ns;	-- wait for 1/2 Clock period
	
	assert (f_out = "1000101101110101" and carry_out = '1' and sign = '1' and zero = '0')
	report "Something went wrong at the 7th assertion";	-- Result of 19950 - 49785 should be -29835. Carry- and sign flag should be set. Zero flag should not be set.

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	
	r_in <= "0101101110000110";		-- R <= 23430
	s_in <= "0101101110000110";		-- S <= 23430
	op <= "001";					-- S - R
	
	carry_in <= '1';				
	clk <= '0';						-- Clock is set to 0
	ce <= '1';
	
	wait for 10 ns;	-- wait for 1/2 Clock period
	
	assert (f_out = "1000101101110101" and carry_out = '1' and sign = '1' and zero = '0')
	report "Something went wrong at the 8th assertion";	-- As Clock isn´t set, nothing should change.

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	
	r_in <= "0101101110000110";		-- R <= 23430
	s_in <= "0101101110000110";		-- S <= 23430
	op <= "001";					-- S - R => All the same as above
	
	carry_in <= '1';				
	clk <= '1';						-- Clock is set to 1
	ce <= '1';
	
	wait for 10 ns;	-- wait for 1/2 Clock period
		
	assert (f_out = "0000000000000000" and carry_out = '0' and sign = '0' and zero = '1')
	report "Something went wrong at the 9th assertion";	-- Result of 23430 - 23430 should be 0. Zero flag should be set. Carry- and sign flag should not be set.

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	
	r_in <= "0000100010110000";		-- R <= 2224
	s_in <= "0000000111010010";		-- S <= 466
	op <= "010";					-- R - S
	
	carry_in <= '0';				-- Carry is set to 0
	clk <= '0';						-- Clock is set to 0
	ce <= '0';						-- Ce is set to 0
	
	wait for 10 ns;	-- wait for 1/2 Clock period
		
	assert (f_out = "0000000000000000" and carry_out = '0' and sign = '0' and zero = '1')
	report "Something went wrong at the 10th assertion";	-- As Clock and ce aren´t set, nothing should change.

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	
	r_in <= "0000100010110000";		-- R <= 2224
	s_in <= "0000000111010010";		-- S <= 466
	op <= "010";					-- R - S => All the same as above
	
	carry_in <= '0';				
	clk <= '1';						-- Clock is set to 1
	ce <= '0';						
	
	wait for 10 ns;	-- wait for 1/2 Clock period
		
	assert (f_out = "0000000000000000" and carry_out = '0' and sign = '0' and zero = '1')
	report "Something went wrong at the 11th assertion";	-- As Ce isn´t set, nothing should change.

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	
	r_in <= "0000100010110000";		-- R <= 2224
	s_in <= "0000000111010010";		-- S <= 466
	op <= "010";					-- R - S => All the same as above
	
	carry_in <= '0';				
	clk <= '0';						-- Clock is set to 0
	ce <= '1';						-- Ce is set to 1
	
	wait for 10 ns;	-- wait for 1/2 Clock period
	
	assert (f_out = "0000000000000000" and carry_out = '0' and sign = '0' and zero = '1')
	report "Something went wrong at the 12th assertion";	-- As Clock isn´t set, nothing should change.
	
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------	
	
	r_in <= "0000100010110000";		-- R <= 2224
	s_in <= "0000000111010010";		-- S <= 466
	op <= "010";					-- R - S => All the same as above
	
	carry_in <= '0';				
	clk <= '1';						-- Clock is set to 1
	ce <= '1';								
	
	wait for 10 ns;	-- wait for 1/2 Clock period
		
	assert (f_out = "0000011011011101" and carry_out = '0' and sign = '0' and zero = '0')
	report "Something went wrong at the 13th assertion";	-- Result of 2224 - 466 should be 1758. As the Carry entry isn´t set: Result should be 1758 - 1 = 1757.
															-- Carry-, sign- and zero flag should not be set.

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
															
	r_in <= "1100010111011000";		-- R <= 1100010111011000
	s_in <= "0100100011011100";		-- S <= 0100100011011100
	op <= "011";					-- R or S
	
	carry_in <= '0';				
	clk <= '0';						-- Clock is set to 0
	ce <= '1';								
	
	wait for 10 ns;	-- wait for 1/2 Clock period														
	
	assert (f_out = "0000011011011101" and carry_out = '0' and sign = '0' and zero = '0')
	report "Something went wrong at the 14th assertion";	-- As Clock isn´t set, nothing should change.

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	
	r_in <= "1100010111011000";		-- R <= 1100010111011000
	s_in <= "0100100011011100";		-- S <= 0100100011011100
	op <= "011";					-- R or S => All the same as above
	
	carry_in <= '0';				
	clk <= '1';						-- Clock is set to 1
	ce <= '1';
	
	wait for 10 ns;	-- wait for 1/2 Clock period	
		
	assert (f_out = "1100110111011100" and carry_out = '0' and sign = '0' and zero = '0')
	report "Something went wrong at the 15th assertion";	-- Result of 1100010111011000 or 0100100011011100 should be 1100110111011100. As or is a logic operation
															-- Carry- and sign flag should not change. Zero flag should not be set.

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
															
	r_in <= "1110001001001010";		-- R <= 1110001001001010
	s_in <= "1101111000001011";		-- S <= 1101111000001011
	op <= "100";					-- R and S
	
	carry_in <= '1';				-- Carry is set to 1
	clk <= '0';						-- Clock is set to 0
	ce <= '1';						
	
	wait for 10 ns;	-- wait for 1/2 Clock period
		
	assert (f_out = "1100110111011100" and carry_out = '0' and sign = '0' and zero = '0')
	report "Something went wrong at the 16th assertion";	-- As Clock isn´t set, nothing should change.

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	
	r_in <= "1110001001001010";		-- R <= 1110001001001010
	s_in <= "1101111000001011";		-- S <= 1101111000001011
	op <= "100";					-- R and S => All the same as above
	
	carry_in <= '1';				
	clk <= '1';						-- Clock is set to 1
	ce <= '1';						
	
	wait for 10 ns;	-- wait for 1/2 Clock period

	assert (f_out = "1100001000001010" and carry_out = '0' and sign = '0' and zero = '0')
	report "Something went wrong at the 17th assertion";	-- Result of 1110001001001010 and 1101111000001011 should be 1100001000001010. As and is a logic operation
															-- Carry- and sign flag should not change. Zero flag should not be set.
	
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	
	r_in <= "0011101010110100";		-- R <= 0011101010110100
	s_in <= "1100010101001011";		-- S <= 1100010101001011
	op <= "100";					-- R and S
	
	carry_in <= '0';				-- Carry is set to 0
	clk <= '0';						-- Clock is set to 0
	ce <= '1';						
	
	wait for 10 ns;	-- wait for 1/2 Clock period
	
	assert (f_out = "1100001000001010" and carry_out = '0' and sign = '0' and zero = '0')
	report "Something went wrong at the 18th assertion";	-- As Clock isn´t set, nothing should change.
	
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------	
	
	r_in <= "0011101010110100";		-- R <= 0011101010110100
	s_in <= "1100010101001011";		-- S <= 1100010101001011
	op <= "100";					-- R and S => All the same as above
	
	carry_in <= '0';				
	clk <= '1';						-- Clock is set to 1
	ce <= '1';						
	
	wait for 10 ns;	-- wait for 1/2 Clock period
	
	assert (f_out = "0000000000000000" and carry_out = '0' and sign = '0' and zero = '1')
	report "Something went wrong at the 19th assertion";	-- Result of 0011101010110100 and 1100010101001011 should be 0000000000000000. As and is a logic operation
															-- Carry- and sign flag should not change. Zero flag should be set.

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
															
	r_in <= "0111001011000000";		-- R <= 0111001011000000
	s_in <= "1011001110010111";		-- S <= 1011001110010111
	op <= "101";					-- Not R and S
	
	carry_in <= '0';				
	clk <= '0';						-- Clock is set to 0
	ce <= '1';						
	
	wait for 10 ns;	-- wait for 1/2 Clock period
		
	assert (f_out = "0000000000000000" and carry_out = '0' and sign = '0' and zero = '1')
	report "Something went wrong at the 20th assertion";	-- As Clock isn´t set, nothing should change.

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	
	r_in <= "0111001011000000";		-- R <= 0111001011000000
	s_in <= "1011001110010111";		-- S <= 1011001110010111
	op <= "101";					-- Not R and S => All the same as above
	
	carry_in <= '0';				
	clk <= '1';						-- Clock is set to 1
	ce <= '1';						
	
	wait for 10 ns;	-- wait for 1/2 Clock period
	
	assert (f_out = "1000000100010111" and carry_out = '0' and sign = '0' and zero = '0')
	report "Something went wrong at the 21st assertion";	-- Result of Not 0111001011000000 and 1011001110010111 should be 1000000100010111. As and is a logic operation
															-- Carry- and sign flag should not change. Zero flag should not be set.

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
															
	r_in <= "1111011101100010";		-- R <= 1111011101100010
	s_in <= "1111011101100010";		-- S <= 1111011101100010
	op <= "110";					-- R xor S
	
	carry_in <= '0';				
	clk <= '0';						-- Clock is set to 0
	ce <= '1';						
	
	wait for 10 ns;	-- wait for 1/2 Clock period
	
	assert (f_out = "1000000100010111" and carry_out = '0' and sign = '0' and zero = '0')
	report "Something went wrong at the 22nd assertion";	-- As Clock isn´t set, nothing should change.

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	
	r_in <= "1111011101100010";		-- R <= 1111011101100010
	s_in <= "1111011101100010";		-- S <= 1111011101100010
	op <= "110";					-- R xor S => All the same as above
	
	carry_in <= '0';				
	clk <= '1';						-- Clock is set to 1
	ce <= '1';						
	
	wait for 10 ns;	-- wait for 1/2 Clock period
	
	assert (f_out = "0000000000000000" and carry_out = '0' and sign = '0' and zero = '1')
	report "Something went wrong at the 23rd assertion";	-- Result of 1111011101100010 xor 1111011101100010 should be 0000000000000000. As and is a logic operation
															-- Carry- and sign flag should not change. Zero flag should be set.

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
						
	r_in <= "1000100101011100";		-- R <= 1000100101011100
	s_in <= "0000011101001110";		-- S <= 0000011101001110
	op <= "110";					-- R xor S
	
	carry_in <= '1';				-- Carry is set to 1
	clk <= '0';						-- Clock is set to 0
	ce <= '1';						
	
	wait for 10 ns;	-- wait for 1/2 Clock period
	
	assert (f_out = "0000000000000000" and carry_out = '0' and sign = '0' and zero = '1')
	report "Something went wrong at the 24th assertion";	-- As Clock isn´t set, nothing should change.

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
						
	r_in <= "1000100101011100";		-- R <= 1000100101011100
	s_in <= "0000011101001110";		-- S <= 0000011101001110
	op <= "110";					-- R xor S => All the same as above
	
	carry_in <= '1';				
	clk <= '1';						-- Clock is set to 1
	ce <= '1';						
	
	wait for 10 ns;	-- wait for 1/2 Clock period
	
	assert (f_out = "1000111000010010" and carry_out = '0' and sign = '0' and zero = '0')
	report "Something went wrong at the 25th assertion";	-- Result of 1000100101011100 xor 0000011101001110 should be 1000111000010010. As and is a logic operation
															-- Carry- and sign flag should not change. Zero flag should not be set.

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------					
						
	r_in <= "1111001101000010";		-- R <= 1111001101000010
	s_in <= "1000010101000110";		-- S <= 1000010101000110
	op <= "111";					-- R xnor S
	
	carry_in <= '1';				
	clk <= '0';						-- Clock is set to 0
	ce <= '1';						
	
	wait for 10 ns;	-- wait for 1/2 Clock period
	
	assert (f_out = "1000111000010010" and carry_out = '0' and sign = '0' and zero = '0')
	report "Something went wrong at the 26th assertion";	-- As Clock isn´t set, nothing should change.

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------															
		
	r_in <= "1111001101000010";		-- R <= 1111001101000010
	s_in <= "1000010101000110";		-- S <= 1000010101000110
	op <= "111";					-- R xnor S => All the same as above
	
	carry_in <= '1';				
	clk <= '1';						-- Clock is set to 1
	ce <= '1';						
	
	wait for 10 ns;	-- wait for 1/2 Clock period
	
	assert (f_out = "1000100111111011" and carry_out = '0' and sign = '0' and zero = '0')
	report "Something went wrong at the 27th assertion";	-- Result of 1111001101000010 xnor 1000010101000110 should be 1000100111111011. As and is a logic operation
															-- Carry- and sign flag should not change. Zero flag should not be set.	

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

	-- The following test cases demonstrate, what happens when an entry is set to an ususally unexpected value like 'U' or 'X' (Usually doesnt happen in an Am 2901 component)
	-- => These tests will cause assertion warnings because entrys are set to 'X' or 'U', however they should not cause assertion errors

	r_in <= "XXXX10XXXXXX0110";		-- R <= XXXX10XXXXXX0110
	s_in <= "0010111010011100";		-- S <= 11932
	op <= "000";					-- Addition
	
	carry_in <= '0';				-- Carry is set to 0
	clk <= '0';						-- Clock is set to 0
	ce <= '1';						
	
	wait for 10 ns;	-- wait for 1/2 Clock period
	
	assert (f_out = "0000000000000000" and carry_out = '0' and sign = '0' and zero = '1')
	report "Something went wrong at the 28th assertion";	-- As there is a non numeric value, the result is set to 0

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------	
		
	r_in <= "XXXX10XXXXXX0110";		-- R <= XXXX10XXXXXX0110
	s_in <= "0010111010011100";		-- S <= 11932
	op <= "000";					-- Addition => All the same as above
	
	carry_in <= '0';				
	clk <= '1';						-- Clock is set to 1
	ce <= '1';						
	
	wait for 10 ns;	-- wait for 1/2 Clock period
	
	assert (f_out = "0000000000000000" and carry_out = '0' and sign = '0' and zero = '1')
	report "Something went wrong at the 29th assertion";	-- As there is a non numeric value, the result is set to 0

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------	
	
	r_in <= "1111100100011000";		-- R <= 63768
	s_in <= "0010111010011100";		-- S <= 11932
	op <= "000";					-- Addition
	
	carry_in <= '0';				
	clk <= '0';						-- Clock is set to 0
	ce <= 'U';						-- Ce is set to U
	
	wait for 10 ns;	-- wait for 1/2 Clock period
	
	assert (f_out = "0000000000000000" and carry_out = '0' and sign = '0' and zero = '1')
	report "Something went wrong at the 30th assertion";	-- As there is a non numeric value, the result is set to 0

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	
	r_in <= "1111100100011000";		-- R <= 63768
	s_in <= "0010111010011100";		-- S <= 11932
	op <= "000";					-- Addition
	
	carry_in <= '0';				
	clk <= '1';						-- Clock is set to 1
	ce <= 'U';						
	
	wait for 10 ns;	-- wait for 1/2 Clock period
	
	assert (f_out = "0000000000000000" and carry_out = '0' and sign = '0' and zero = '1')
	report "Something went wrong at the 31st assertion";	-- As there is a non numeric value, the result is set to 0

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

	r_in <= "1111100100011000";		-- R <= 63768
	s_in <= "0010111010011100";		-- S <= 11932
	op <= "000";					-- Addition
	
	carry_in <= '0';				
	clk <= 'Z';						-- Clock is set to Z
	ce <= '1';						-- Ce is set to 1
	
	wait for 10 ns;	-- wait for 1/2 Clock period
	
	assert (f_out = "0000000000000000" and carry_out = '0' and sign = '0' and zero = '1')
	report "Something went wrong at the 32nd assertion";	-- As there is a non numeric value, the result is set to 0

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	
	r_in <= "1111100100011000";		-- R <= 63768
	s_in <= "0010111010011100";		-- S <= 11932
	op <= "000";					-- Addition
	
	carry_in <= '0';				
	clk <= 'Z';						-- Clock is set to Z
	ce <= '1';						
	
	wait for 10 ns;	-- wait for 1/2 Clock period
	
	assert (f_out = "0000000000000000" and carry_out = '0' and sign = '0' and zero = '1')
	report "Something went wrong at the 33rd assertion";	-- As there is a non numeric value, the result is set to 0

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

	r_in <= "1111100100011000";		-- R <= 63768
	s_in <= "0010111010011100";		-- S <= 11932
	op <= "000";					-- Addition
	
	carry_in <= 'W';				-- Carry is set to W
	clk <= '0';						-- Clock is set to 0
	ce <= '1';						
	
	wait for 10 ns;	-- wait for 1/2 Clock period
	
	assert (f_out = "0000000000000000" and carry_out = '0' and sign = '0' and zero = '1')
	report "Something went wrong at the 34th assertion";	-- As there is a non numeric value, the result is set to 0

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

	r_in <= "1111100100011000";		-- R <= 63768
	s_in <= "0010111010011100";		-- S <= 11932
	op <= "000";					-- Addition
	
	carry_in <= 'W';				
	clk <= '1';						-- Clock is set to 1
	ce <= '1';						
	
	wait for 10 ns;	-- wait for 1/2 Clock period
	
	assert (f_out = "0000000000000000" and carry_out = '0' and sign = '0' and zero = '1')
	report "Something went wrong at the 35th assertion";	-- As there is a non numeric value, the result is set to 0

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	
	r_in <= "1111100100011000";		-- R <= 63768
	s_in <= "0010111010011100";		-- S <= 11932
	op <= "00L";					-- Op is set to 00L
	
	carry_in <= '1';				-- Carry is set to 1
	clk <= '0';						-- Clock is set to 0
	ce <= '1';						
	
	wait for 10 ns;	-- wait for 1/2 Clock period
	
	assert (f_out = "0000000000000000" and carry_out = '0' and sign = '0' and zero = '1')
	report "Something went wrong at the 36th assertion";	-- As there is a non numeric value, the result is set to 0

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	
	r_in <= "1111100100011000";		-- R <= 63768
	s_in <= "0010111010011100";		-- S <= 11932
	op <= "00L";					
	
	carry_in <= '1';				
	clk <= '1';						-- Clock is set to 1
	ce <= '1';						
	
	wait for 10 ns;	-- wait for 1/2 Clock period
	
	assert (f_out = "0000000000000000" and carry_out = '0' and sign = '0' and zero = '1')
	report "Something went wrong at the 37th assertion";	-- As there is a non numeric value, the result is set to 0

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	
	assert false report "Reached end the of the testbench." & lf & "In case exactly 3 assertion warnings" & lf & "(caused by setting entry values to 'X' and 'U' in the final test cases)" & lf & "and 0 other assertion errors are displayed, all computations were correct." severity note;
	-- Assertion (-error) that notifies the user that the testbench has finished
	
	wait;	-- Final wait command to assure the testbench stops
	
	end process;
	
end ALU_tb_architecture;
