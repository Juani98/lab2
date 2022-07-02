library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
-------------------------------------------------------------------
 -- Enitiy --
-------------------------------------------------------------------
entity lab2_comparador_salida is
    generic(bus_width: natural:= 8);
    Port (
        clk : in std_logic;
        rst : in std_logic;
        data_in_A : in std_logic_vector(bus_width-1 downto 0);
        data_in_B : in std_logic_vector(bus_width-1 downto 0);
        data_out : out std_logic;
        hay_error_comp : out std_logic;
        flag_aviso_error_FSM : in std_logic
    );
end lab2_comparador_salida;
-------------------------------------------------------------------
 -- Architecture --
-------------------------------------------------------------------
architecture Behavioral of lab2_comparador_salida is
-- Declaración de componentes
    component divisor_frecuencia is 
        Port (
            input_clk : in STD_LOGIC;
            reset : in std_logic;
            frec_selec : in std_logic_vector(2 downto 0);
            output_clk : out STD_LOGIC
        );
    end component;
--Señales internas
signal internal_hay_error : std_logic; -- esta es una señal que se pone en 1 si hay error
signal internal_output_frec : std_logic; --esta señal interconecta la salida del comparador con la del divisor de frecuencia
signal internal_start_frec : std_logic; --
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
            internal_hay_error <= '0';
            hay_error_comp <= '0';
        else
            internal_hay_error <= '1'; 
            hay_error_comp <= '1'; --Si hay un error en la comparacion, hay un flag que se pone en 1 acusando que hay error de comparacion a la FSM
        end if;
    end process;
    process (clk,flag_aviso_error_FSM)
    begin
        if(rising_edge(clk)) then
            if (flag_aviso_error_FSM='0') then --Si no hay error, establezco un 1
                data_out <= '1';
            else                 --Si hay error conecto la salida con el div. de frec a 5Hz
                --data_out<='0';
                data_out <= internal_output_frec;
            end if;
        end if;
    end process;
end Behavioral;