library ieee;					-- {
use ieee.numeric_std.all;		-- Libraries needed for the implementation
use ieee.std_logic_1164.all;	-- }

entity ALU_entity is
	port
	(
	r_in: in unsigned (15 downto 0);		-- R entry
	s_in: in unsigned (15 downto 0);		-- S entry
	op: in std_logic_vector (2 downto 0);	-- Opcode
	
	carry_in: in std_logic;		-- Carry entry
	clk: in std_logic;			-- Clock entry
	ce: in std_logic;			-- Enable bit entry
	
	f_out: out unsigned (15 downto 0);		-- F exit (result of the operation)
	
	carry_out: out std_logic;	-- Carry flag exit
	sign: out std_logic;		-- Sign flag exit	
	zero: out std_logic			-- Zero flag exit
	);
end ALU_entity;


architecture ALU_architecture of ALU_entity is

	signal temp: unsigned (16 downto 0) := "00000000000000000";	-- Signal for caching the result of the operation => is mapped to f_out at the end
	begin
	
	f_out <= temp(15 downto 0); -- mapping temp to the f_out exit
	
	carry_out <= '1' when ((op = "000" or op = "001" or op = "010") and temp (16) = '1') else '0';			-- {
	sign <= '1' when ((op = "000" or op = "001" or op = "010") and temp (15) = '1') else '0';				-- Setting the exits that represent the flags
	zero <= '1' when temp (15 downto 0) = "0000000000000000" else '0';										-- }

	process(clk, ce) is -- Start of the actual computation
		begin
		
		-- Testing if the entry values are numerical => if not, temp is set to 0
		if((r_in >= 0 and r_in <= 65535) and (s_in >= 0 and s_in <= 65535) and (carry_in = '0' or carry_in = '1') and (clk = '0' or clk = '1') and (ce = '0' or ce = '1')) then
		
			if rising_edge(clk) and (ce = '1') then	-- Only is active when ce is set and the clock is at a rising edge
		
				case op is	
			
				when "000" =>  -- ADD
				
					if(carry_in = '1') then								-- if the carry entry is set: add 1 to the result
						temp <= (("0" & r_in) + ("0" & s_in) + 1);		
					else												-- if the carry entry isn´t set: leave the result as is
						temp <= (("0" & r_in) + ("0" & s_in));
					end if;												-- at both operations a 0 has to be prepended to R and S so they have the same length as temp
			
				when "001" =>  -- SUBR => S - R
				
					if(carry_in = '1') then								-- if the carry entry is set: leave the result as is
						temp <= (("0" & s_in) - ("0" & r_in));
					else												-- if the carry entry isn´t set: subtract 1 of the result
						temp <= (("0" & s_in) - ("0" & r_in) - 1);
					end if;												-- at both operations a 0 has to be prepended to R and S so they have the same length as temp
			
				when "010" =>  -- SUBS => R - S
			
					if(carry_in = '1') then								-- if the carry entry is set: leave the result as is
						temp <= (("0" & r_in) - ("0" & s_in));
					else												-- if the carry entry isn´t set: subtract 1 of the result
						temp <= (("0" & r_in) - ("0" & s_in) - 1);
					end if;												-- at both operations a 0 has to be prepended to R and S so they have the same length as temp
			
				when "011" =>  -- OR
					temp <= (("0" & r_in) or ("0" & s_in));				-- R or S => a 0 has to be prepended to R and S so they have the same length as temp
			
				when "100" =>  -- AND		
					temp <= (("0" & r_in) and ("0" & s_in));			-- R and S => a 0 has to be prepended to R and S so they have the same length as temp
			
				when "101" =>  -- NOTRS		
					temp <= (("0" & (not r_in)) and ("0" & s_in));		-- (Not R) and S => a 0 has to be prepended to R and S so they have the same length as temp
			
				when "110" =>  -- EXOR		
					temp <= (("0" & r_in) xor ("0" & s_in));			-- R xor S => a 0 has to be prepended to R and S so they have the same length as temp
			
				when "111" =>  -- EXNOR			
					temp <= (("0" & r_in) xnor ("0" & s_in));			-- R xnor S => a 0 has to be prepended to R and S so they have the same length as temp
				
				when others =>
					temp <= "00000000000000000";
			
				end case;
			
			end if;
		
		else	-- Setting temp to 0 if there is an non numerical entry value
			temp <= "00000000000000000";
		
		end if;
		
	end process;
	
end ALU_architecture;
