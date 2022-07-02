library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
use work.package_inf_rom.all;
------------------------------------------------------------------
 -- Enitiy --
------------------------------------------------------------------
entity testbench_top_v3 is
--  Port ( );
end testbench_top_v3;
------------------------------------------------------------------
 -- Architecture --
------------------------------------------------------------------
architecture Behavioral of testbench_top_v3 is
    component lab2_top_v3 is 
        Port(
           reset : in std_logic;
           clock : in std_logic; 
           acuse_error_comp : in std_logic; --error de comparacion
           start_cycle : in std_logic; --inicio de ciclo FSM
           output_comp : out std_logic
	   );
    end component;
    --asignacion de señales para simulación
    signal tb_reset : std_logic :='0';
    signal tb_clock : std_logic :='0';
    signal tb_error_comp : std_logic :='0';
    signal tb_start_cycle : std_logic :='0';
    signal tb_output_comp : std_logic;
   constant clk_period: time := 5 ns; --Tclk=10nS -> Ton = Toff = 5nS - 50% duty
------------------------------------------------------------------
 -- Descripción --
 -- Realizar una simulación por 400mS
 -- Comentar y/o Descomentar las constantes de la ROM D para observar
 -- cómo se comporta con errores, sin errores y con un error.
------------------------------------------------------------------
begin
 --Mapeo de puertos de la UUT
     UUT_1: lab2_top_v3 port map (
        reset => tb_reset,
        clock => tb_clock,
        acuse_error_comp => tb_error_comp,
        start_cycle=> tb_start_cycle,
        output_comp => tb_output_comp
     );
 tb_clock <= not(tb_clock) after clk_period; --T=10nS

process 
begin
    tb_reset <= '1';
    wait for 50 ns;
    tb_reset <= '0';
    wait for 50 ns;
    --Inicio FSM
    tb_start_cycle <= '1';
    wait for 30000 us; 
    --Este retardo simula un botón que se presiona del exterior 
    -- no un instante, sino mucho tiempo 
    -- comparado a la rapidez de respuesta del sistema
    tb_start_cycle <= '0';
    wait for 220000 us;
    
    tb_error_comp <= '1';
    wait for 30000 us; 
    --Se presiona el acuse de error
    --Aqui se le indica a la placa desde el exterior
    -- que se entiende que hubo un error
    tb_error_comp <= '0';
    wait for 50 ns;
    wait;
end process;
end Behavioral;
