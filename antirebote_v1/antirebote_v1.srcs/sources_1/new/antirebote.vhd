library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;
------------------------------------------------------------------
 -- Enitiy --
------------------------------------------------------------------
entity debounce_v2 is
    generic(cnt_width: natural:= 21);
    Port ( 
        debounce_input : in STD_LOGIC;
        clock : in STD_LOGIC;
        reset : in std_logic;
        debounce_output : out STD_LOGIC
        );
end debounce_v2;
------------------------------------------------------------------
 -- Architecture --
------------------------------------------------------------------
architecture Behavioral of debounce_v2 is
    type state_type is (S0,S1,S2);
	signal current_state,next_state: state_type;
    --DISEÑO ESTRUCTURAL
    --Componentes
    --Contador de 21bits
    component counter_22bits is
        Port ( 
           rst : in STD_LOGIC;
           enable : in std_logic;
           data_in : in STD_LOGIC_VECTOR (cnt_width-1 downto 0);
           clk : in STD_LOGIC;
           up_down : in STD_LOGIC;
           load_data : in STD_LOGIC;
           data_out : out STD_LOGIC_VECTOR (cnt_width-1 downto 0);
           carry_out : out std_logic
           );
    end component;
--señales internas (contador)
signal internal_data_counter_in : STD_LOGIC_VECTOR (cnt_width-1 downto 0);
signal internal_data_counter_out : STD_LOGIC_VECTOR (cnt_width-1 downto 0);
signal internal_counter_carry_out : std_logic;
signal internal_counter_enable : std_logic;
signal internal_pre_load_data :  STD_LOGIC;
signal internal_start_counter : std_logic;
begin
    --Mapeo de puertos - componentes
    --Componente N1: contador de 22bits
     counter1_22bits: counter_22bits port map(
        rst => reset,
        enable => internal_counter_enable,
        data_in => (others=>'0'),
        clk => clock,
        up_down => '1',
        load_data => '0', 
        data_out => internal_data_counter_out,
        carry_out => internal_counter_carry_out
    );
current_state_process: process(clock,reset)
		begin
		if (reset = '1') then  --Reset activo en alto
			current_state <= S0;
		elsif (rising_edge(clock)) then 
			current_state <= next_state;
		end if;
	end process current_state_process;
	next_state_process: process(current_state,internal_counter_carry_out,debounce_input)
	begin
		case current_state is 
			when S0 => --Estado inicial
				if (debounce_input = '1') then
					next_state <= S1;
				elsif (debounce_input = '0') then
				    next_state <= S0;
				else 
					next_state <= S0;
				end if;
			when S1 => 		
				if (internal_counter_carry_out = '1') then
					next_state <= S2;
				elsif (internal_counter_carry_out = '0') then
				    next_state <= S1;
				else 
				     next_state <= S1;
				end if;
			when S2 => 
				if (debounce_input = '1') then
					next_state <= S2;
				elsif (debounce_input = '0') then
					next_state <= S0;
				else
			     	next_state <= S0;
				end if;
			end case;	
end process next_state_process;
output_logic_process: process(current_state) --logica combinacional de salida (salida no registrada)
	begin
        debounce_output <='0';
		case current_state is 
			when S0 => 
				debounce_output <= '0';
				internal_counter_enable<='1';
			when S1 => 
			    debounce_output <= '0'; --DUDA: HACE FALTA ACOLOCAR AQUI LOS ESTADOS BAJOS?
				internal_counter_enable<='0';
			when S2 => 
			     internal_counter_enable<='1';
				debounce_output <= '1';					
			when others =>
			   internal_counter_enable<='0';
                debounce_output <= '0';
		end case;
end process output_logic_process;	
end Behavioral;

