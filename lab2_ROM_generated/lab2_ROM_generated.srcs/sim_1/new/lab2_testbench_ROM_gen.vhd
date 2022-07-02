library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
-------------------------------------------------------------------
 -- Enitiy --
-------------------------------------------------------------------
entity lab2_ROM_gen_testbench is

end lab2_ROM_gen_testbench;
-------------------------------------------------------------------
 -- Architecture --
-------------------------------------------------------------------
architecture Behavioral of lab2_ROM_gen_testbench is
    component lab2_ROM_gen is 
        Port(
            clka : IN STD_LOGIC;
            addra : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
            douta : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
         );
        end component;
    --asignacion de señales para simulación
    signal tb_clka : std_logic :='0';
    signal tb_addra : std_logic_vector(2 downto 0);
    signal tb_douta: std_logic_vector(7 downto 0);
    constant clk_period: time := 5 ns; --Tclk=10nS -> Ton = Toff = 10nS - 50% duty
begin
 --Mapeo de puertos de la UUT
     UUT_1: lab2_ROM_gen port map (
         clka => tb_clka,
         addra => tb_addra,
         douta=> tb_douta
     );
 tb_clka <= not(tb_clka) after clk_period; --T=10nS
-------------------------------------------------------------------
-- Descripción --
-- Realizar una simulación por 1uS
-------------------------------------------------------------------
process 
begin
wait for 100 ns;
tb_addra <= "000";
wait for 100 ns;
tb_addra <= "001";
wait for 100 ns;
tb_addra <= "010";
wait for 100 ns;
tb_addra <= "011";
wait for 100 ns;
tb_addra <= "100";
wait for 100 ns;
tb_addra <= "101";
wait for 100 ns;
tb_addra <= "110";
wait for 100 ns;
tb_addra <= "111";
wait for 100 ns;
wait;
end process;
end Behavioral;
