library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity lab2_comparador_salida is
    generic(bus_width: natural:= 9);
    Port (
        clk : in std_logic;
        rst : in std_logic;
        data_in_A : in std_logic_vector(bus_width-1 downto 0);
        data_in_B : in std_logic_vector(bus_width-1 downto 0);
        data_out : out std_logic
--        fin_operacion : out std_logic
    );
end lab2_comparador_salida;

architecture Behavioral of lab2_comparador_salida is

    component divisor_frecuencia is 
        Port (
            input_clk : in STD_LOGIC;
            reset : in std_logic;
            frec_selec : in std_logic_vector(2 downto 0);
            output_clk : out STD_LOGIC
        );
    end component;
    
signal internal_data_out : std_logic;
signal internal_output_frec : std_logic;
signal internal_start_frec : std_logic;
--signal internal_output_true : std_logic;
begin

    componente_divisor_frecuencia: divisor_frecuencia port map(
        reset => rst,
        input_clk => clk,
        frec_selec => "000",
        output_clk => internal_output_frec
    );
    
    

    process (data_in_A, data_in_B) --bloque de comparacion
    begin
        if (data_in_A=data_in_B) then
            internal_data_out <= '1';
        else
            internal_data_out <= '0'; 
        end if;
    end process;
    process (clk)
    begin
        if(rising_edge(clk)) then
            if (internal_data_out='1') then
             --  internal_start_frec <= '0';
               data_out <= internal_data_out;
            else
             --   internal_start_frec <= '1';
                data_out <= internal_output_frec;
            end if;
        end if;
    end process;
end Behavioral;
