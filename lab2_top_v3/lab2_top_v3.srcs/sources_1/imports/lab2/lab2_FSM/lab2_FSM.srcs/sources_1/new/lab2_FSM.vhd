library IEEE;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
------------------------------------------------------------------
 -- Entity --
------------------------------------------------------------------
entity lab2_FSM is 
	port(
	   reset : in std_logic;
	   clk : in std_logic; 
	   carry_out_counter : in std_logic; -- carry de salida del contador
	   acuse_error_comp : in std_logic; --señal externa de acuse de un error de comparacion (proviene del operario)
	   start_cycle : in std_logic; --inicio de ciclo FSM
	   load_counter : out std_logic; --controla la precarga del contador que maneja el bus de direcciones
	   en_counter : out std_logic; --controla el enable del contador. Permite mantener una direccion fija si es asertiva
	   wea_A : out std_logic; --habilitacion data in A, Mem RAM
	   wea_B : out std_logic; -- habilitacion data in B, Mem RAM
	   hay_error_comp : in std_logic; --Ingreso de aviso de error de comp (proviene del comparador)
	   flag_de_error_comp : out std_logic; --aviso desde FSM que hay error de comp
	   --señal de debug
	   out_current_state : out std_logic_vector(3 downto 0) --registro de estado actual
	);
end lab2_FSM;
------------------------------------------------------------------
 -- Architecture --
------------------------------------------------------------------
architecture behavioral of lab2_FSM is
	type state_type is (S0,S1,S2,S3,S4,S5,S6,S7,S8,S9,S10,S11,S12);
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
next_state_process: process(current_state,start_cycle,carry_out_counter,acuse_error_comp,hay_error_comp)
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
				next_state <= S5;
			when S5 => 
				next_state <= S6;
			when S6 => 
				next_state <= S7;				
			when S7 => 
				if (carry_out_counter = '1') then
					next_state <= S8;
				else
					next_state <= S1;
				end if;
			when S8 =>
				next_state <= S9;
            when S9 => 
                 next_state <= S10;
            when S10 => 
                if (hay_error_comp = '1') then
					next_state <= S12;
				else
					next_state <= S11;
				end if;
            when S11 => 
                if (carry_out_counter = '0') then
					next_state <= S10;
				else
					next_state <= S0;
				end if;
			when S12 => 
			    if (acuse_error_comp='1') then
					next_state <= S0; --el usuario acusó que entiende que hubo error de comparacion
				else
					next_state <= S12; --sigue en ese estado si el operario todavia no verifica 
				end if;
		end case;
end process next_state_process;
output_logic_process: process(current_state) --logica combinacional de salida (salida no registrada)
	begin
	    flag_de_error_comp<='0';
		out_current_state<="0000";
        load_counter <= '0';
        en_counter <= '0';
        wea_A <= '0';
        wea_B <= '0';
		case current_state is 
			when S0 => 
			    out_current_state<="0000";
				load_counter <= '1';
				flag_de_error_comp<='0';
			when S1 => 
			    load_counter <= '0'; --DUDA: HACE FALTA ACOLOCAR AQUI LOS ESTADOS BAJOS?
				en_counter <= '1';
				out_current_state<="0001";
			when S2 => 
				en_counter <= '1';
				out_current_state<="0010";
			when S3 => 
                en_counter <= '1';
			    out_current_state<="0011";
            when S4 => 
                en_counter <= '1';
			    out_current_state<="0100";
            when S5 => 
                en_counter <= '1';
                wea_A <= '1';
                wea_B <= '1';
			    out_current_state<="0101";
            when S6 => 
                en_counter <= '0';
                wea_A <= '0';
                wea_B <= '0';
                out_current_state<="0110";
            when S7 => 
                en_counter <= '1';
                out_current_state<="0111";
           when S8 => 
                en_counter <= '0';
                out_current_state<="1000";
           when S9 => 
                out_current_state<="1001";
                load_counter <= '1';
            when S10 => 
              out_current_state<="1010";
              load_counter <= '0';
              en_counter <= '1';
			when S11 => 
			   out_current_state<="1011";
			   en_counter <= '0';
			when S12 => 
			out_current_state<="1100";
			     en_counter <= '1';	
			     flag_de_error_comp<='1';			
			when others =>
			flag_de_error_comp<='0';
			     out_current_state<="0000";
                load_counter <= '0';
                en_counter <= '0';
                wea_A <= '0';
                wea_B <= '0';
		end case;
end process output_logic_process;
end behavioral;