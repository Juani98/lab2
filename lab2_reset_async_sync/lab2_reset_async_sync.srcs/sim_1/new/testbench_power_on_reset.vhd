library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
------------------------------------------------------------------
 -- Enitiy --
------------------------------------------------------------------
entity testbench_power_on_reset is
--  Port ( );
end testbench_power_on_reset;
------------------------------------------------------------------
 -- Architecture --
------------------------------------------------------------------
architecture Behavioral of testbench_power_on_reset is
    --componentes a probar
    component rst_async_ass_synch_deass is
    Port ( 
        sys_clk : in std_logic;
        sys_rst : in std_logic;
        rst_aa_sd: out std_logic
        );
    end component;
    --asignacion de señales
    signal tb_sys_rst : std_logic :='0'; --entrada de reset
    signal tb_sys_clk : std_logic :='0'; --clk
    signal tb_rst_aa_sd : std_logic :='0'; --salida de reset

    constant clk_period: time :=  15 ns; 
    --Tclk=30nS -> Ton = Toff = 15nS - 50% duty
    
    begin
    --instanciacion de componentes
    UUT_1: rst_async_ass_synch_deass port map (
        sys_rst => tb_sys_rst,
        sys_clk => tb_sys_clk,
        rst_aa_sd => tb_rst_aa_sd
    );
    --clock 
    tb_sys_clk <= not(tb_sys_clk) after clk_period;
    --Tclk=30nS -> Ton = Toff = 15nS - 50% duty
    
    process   
    begin
------------------------------------------------------------------
 -- Descripción: Cuando la entrada de reset sea '0', 
 --                   la salida se pondrá en 0 de forma asincrónica
 --              Cuando la entrada de reset sea '1',
 --                  la salida se pondrá en 1 luego de 2 flancos de reloj
 -- Observación: Ejecutar la simulación por 1uS
------------------------------------------------------------------
    
        --desactivo reset
        tb_sys_rst <= '1';
        wait for 100 ns;
        --activo reset (async)
        tb_sys_rst <= '0';
        wait for 200 ns;
        -- desactivo reset luego de 2 flancos 
        -- de reloj debe verse la desactivación
        tb_sys_rst <= '1';
        wait for 200 ns; 
        --activo reset
        tb_sys_rst <= '0';
        wait for 300 ns;
        --desactivo reset
        tb_sys_rst <= '1';
        wait for 300 ns;

        wait;

    end process;
end Behavioral;
