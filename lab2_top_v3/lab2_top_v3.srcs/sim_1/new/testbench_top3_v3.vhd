library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
use work.package_inf_rom.all;

entity testbench_top_v3 is
--  Port ( );
end testbench_top_v3;

architecture Behavioral of testbench_top_v3 is
    component lab2_top_v3 is 
        Port(
           reset : in std_logic;
           clock : in std_logic; 
           error_comp : in std_logic; --error de comparacion
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
   constant clk_period: time := 10 ns; --Tclk=10nS -> Ton = Toff = 5nS - 50% duty

begin
 --Mapeo de puertos de la UUT
     UUT_1: lab2_top_v3 port map (
        reset => tb_reset,
        clock => tb_clock,
        error_comp => tb_error_comp,
        start_cycle=> tb_start_cycle,
        output_comp => tb_output_comp
     );
 tb_clock <= not(tb_clock) after clk_period; --T=10nS



process 
begin
    tb_reset <= '1';
    wait for 100 ns;
    tb_reset <= '0';
    wait for 100 ns;
    --Inicio FSM
    tb_start_cycle <= '1';
    wait for 20 ns;
    tb_start_cycle <= '0';
    wait for 20 ns;

    wait for 20 ns;

    wait for 20 ns;

    wait for 20 ns;

    wait for 20 ns;

    wait for 20 ns;

    wait for 20 ns;
    
    wait;
end process;
end Behavioral;
