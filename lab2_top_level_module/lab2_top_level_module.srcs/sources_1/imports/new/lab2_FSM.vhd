library IEEE;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity lab2_FSM is 
	port(
	   reset : in std_logic;
	   clk : in std_logic; 
	   carry_out_counter : in std_logic; -- carry de salida del contador
	   error_comp : in std_logic; --error de comparacion
	   start_cycle : in std_logic; --inicio de ciclo FSM
	   load_counter : out std_logic;
	   en_counter : out std_logic;
	   wea_A : out std_logic_vector(0 downto 0); --habilitacion data in A, Mem RAM
	   wea_B : out std_logic_vector(0 downto 0) -- habilitacion data in B, Mem RAM
	);

end lab2_FSM;

architecture behavioral of lab2_FSM is

	type state_type is (S0,S1,S2,S3,S4,S5,S6,S7);
	signal current_state,next_state: state_type;
	
begin
	current_state_process: process(clk,reset)
		begin
		if (reset = '1') then  --Reset activo en alto
			current_state <= S0;
		elsif (rising_edge(clk)) then 
			current_state <= next_state;
		end if;
	end process current_state_process;
next_state_process: process(current_state,start_cycle,carry_out_counter,error_comp)
	begin
		case current_state is 
			when S0 => --Estado inicial
				if (start_cycle = '1') then
					next_state <= S1;
				elsif(start_cycle = '0') then 
					next_state <= S0;
				else
					next_state <= S0;
				end if;
			when S1 => 		
				next_state <= S2;
			when S2 => 
				next_state <= S3;
			when S3 => 
				next_state <= S4;
			when S4 => 
				if (carry_out_counter = '1') then
					next_state <= S5;
				else
					next_state <= S1;
				end if;
			when S5 => 
				next_state <= S6;
            when S6 => 
                if (error_comp = '1') then
					next_state <= S6;
				else
					next_state <= S7;
				end if;
			when S7 => 
                if (carry_out_counter = '0') then
					next_state <= S6;
				else
					next_state <= S0;
				end if;
		end case;
		
end process next_state_process;
		
output_logic_process: process(current_state) --logica combinacional de salida (salida no registrada)
	
	begin
        load_counter <= '0';
        en_counter <= '0';
        wea_A <= "0";
        wea_B <= "0";
		case current_state is 
		
			when S0 => 
				load_counter <= '1';
			when S1 => 
			    load_counter <= '0'; --DUDA: HACE FALTA ACOLOCAR AQUI LOS ESTADOS BAJOS?
				en_counter <= '1';
			when S2 => 
				en_counter <= '1';
			when S3 => 
                en_counter <= '1';
                wea_A <= "1";
                wea_B <= "1";
			when S4 => 
                en_counter <= '0';
                wea_A <= "1";
                wea_B <= "1";
                
			when S5 => 
			wea_A <= "0";
                wea_B <= "0";
				load_counter <= '1';
			when S6 => 
			    load_counter <= '0';
				en_counter <= '1';
			when S7 => 
			    en_counter <= '0';					
			when others =>
                load_counter <= '0';
                en_counter <= '0';
                wea_A <= "0";
                wea_B <= "0";
		end case;
		
end process output_logic_process;	
		
end behavioral;