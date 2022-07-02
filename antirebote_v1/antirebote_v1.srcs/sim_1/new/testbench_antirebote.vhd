library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;
------------------------------------------------------------------
 -- Enitiy --
------------------------------------------------------------------
entity testbench_antirebote_v1 is
generic(cnt_width: natural:= 21);
end testbench_antirebote_v1;
------------------------------------------------------------------
 -- Architecture --
------------------------------------------------------------------
architecture Behavioral of testbench_antirebote_v1 is
    --componentes a probar
    component debounce_v2 is
        Port ( 
            debounce_input : in STD_LOGIC;
            clock : in STD_LOGIC;
            reset : in std_logic;
            debounce_output : out STD_LOGIC
            );
    end component;
    --asignacion de señales para simulación  
    signal tb_reset : std_logic :='1';
    signal tb_clock : std_logic :='0';
    signal tb_debounce_input : std_logic :='0';
    signal tb_debounce_output : std_logic;
    constant clk_period: time :=  5 ns; --Tclk=10nS -> Ton = Toff = 5nS - 50% duty
    begin
    --Mapeo de puertos de la UUT
    UUT_1: debounce_v2 port map (
        reset => tb_reset,
        clock => tb_clock,
        debounce_input => tb_debounce_input,
        debounce_output => tb_debounce_output
    );
    --clock 
    tb_clock <= not(tb_clock) after clk_period; --T=10nS
    
    process   
    begin
------------------------------------------------------------------
 -- Descripción --
 -- Realizar la simulación durante 30mS
------------------------------------------------------------------
        -- se simulan rebotes
        wait for 10 us;
        tb_reset <= '1'; 
        wait for 200 ns;
        tb_reset <= '0';
        wait for 3 us;
        tb_debounce_input <= '1'; 
        wait for 2 us;
        tb_debounce_input <= '0'; 
        wait for 6 us;
        tb_debounce_input <= '1'; 
        wait for 3 us;
        tb_debounce_input <= '0';
        wait for 500 ns;
        tb_debounce_input <= '1';
        wait for 7 us;
        tb_debounce_input <= '0';
        wait for 5 us;
        --finalmente la entrada se pone en 1
        tb_debounce_input <= '1';
        wait for 30000 us;
        --se espera por 20mS
        -- la salida debe seguir a la entrada
        -- cumplido el tiempo de contaje (aprx. 20mS) 
        tb_debounce_input <= '0'; 
        wait;       
    end process;
end Behavioral;






