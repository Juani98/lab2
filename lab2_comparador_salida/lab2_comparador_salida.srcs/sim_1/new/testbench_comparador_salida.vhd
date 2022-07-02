library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;
-------------------------------------------------------------------
 -- Enitiy --
-------------------------------------------------------------------
entity testbench_comparador_salida is
    generic(bus_width: natural:= 8);
end testbench_comparador_salida;
-------------------------------------------------------------------
 -- Architecture --
-------------------------------------------------------------------
architecture Behavioral of testbench_comparador_salida is
component lab2_comparador_salida is
    Port (
        clk : in std_logic;
        rst : in std_logic;
        data_in_A : in std_logic_vector(bus_width-1 downto 0);
        data_in_B : in std_logic_vector(bus_width-1 downto 0);
        data_out : out std_logic;
        hay_error_comp : out std_logic;
        flag_aviso_error_FSM : in std_logic
    );
end component;
    --Señales de simulación
    signal tb_clk : std_logic :='0';
    signal tb_rst : std_logic :='0';
    signal tb_data_out : STD_LOGIC;
    signal tb_data_in_A : STD_LOGIC_VECTOR(bus_width-1 DOWNTO 0) :=X"00";
    signal tb_data_in_B : STD_LOGIC_VECTOR(bus_width-1 DOWNTO 0) :=X"00";
    signal tb_hay_error_comp : std_logic :='0';
    signal tb_flag_aviso_error_FSM : std_logic :='0';
    constant clk_period: time := 5 ns; --Tclk=10nS -> Ton = Toff = 5nS - 50% duty
begin
 --Mapeo de puertos de la UUT
     UUT_1: lab2_comparador_salida port map (
        clk => tb_clk,
        rst => tb_rst,
        data_in_A => tb_data_in_A,
        data_in_b => tb_data_in_b,
        data_out => tb_data_out,
        hay_error_comp => tb_hay_error_comp,
        flag_aviso_error_FSM => tb_flag_aviso_error_FSM
     );
    tb_clk <= not(tb_clk) after clk_period; --T=10nS
-------------------------------------------------------------------
-- Descripción --
-- Ejecutar la simulación por 400nS si desea ver el funcionamiento del comparador a nivel de lógica
-- Para ver el blinking del led a la salida en caso de error, simular por lo menos 200mS 
-- En ese caso debería ver un cambio de estado de la salida a los 100mS en caso de error de comparación.
-------------------------------------------------------------------   
    process 
    begin
    tb_rst <= '1';
    wait for 50 ns;
    tb_rst <= '0';
    wait for 50 ns;
    tb_data_in_B <= X"ab";
    wait for 50 ns;
    tb_data_in_A <= X"fa";
    wait for 50 ns;
    tb_data_in_B <= X"fa";
    wait for 50 ns;
    tb_data_in_A <= X"ff";
    tb_flag_aviso_error_FSM <= '1';
    wait for 50 ns;
    wait;
    end process;   
end Behavioral;
