library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
-------------------------------------------------------------------
 -- Enitiy --
-------------------------------------------------------------------
entity lab2_bloque_sumador_testbench is
    generic(
        bus_width : natural := 8
    );
end lab2_bloque_sumador_testbench;

-------------------------------------------------------------------
 -- Architecture --
-------------------------------------------------------------------
architecture Behavioral of lab2_bloque_sumador_testbench is
    component lad2_bloque_sumador is 
        Port(
             clk : in std_logic;
             rst : in std_logic;
             dato_A : in std_logic_vector(bus_width-1 downto 0);
             dato_B : in std_logic_vector(bus_width-1 downto 0);
             dato_C : in std_logic_vector(bus_width-1 downto 0);
             dato_salida : out std_logic_vector(bus_width-1 downto 0)
         );
        end component;
    --asignacion de señales para simulación
    signal tb_rst : std_logic :='0';
    signal tb_clk : std_logic :='0';
    signal tb_dato_A : std_logic_vector(bus_width-1 downto 0);
    signal tb_dato_B : std_logic_vector(bus_width-1 downto 0);
    signal tb_dato_C : std_logic_vector(bus_width-1 downto 0);
    signal tb_dato_salida : std_logic_vector(bus_width-1 downto 0);
    constant clk_period: time := 15 ns; --Tclk=30nS -> Ton = Toff = 15nS - 50% duty
begin
 --Mapeo de puertos de la UUT
     UUT_1: lad2_bloque_sumador port map (
         rst => tb_rst,
         clk => tb_clk,
         dato_A => tb_dato_A,
         dato_B => tb_dato_B,
         dato_C => tb_dato_C,
         dato_salida => tb_dato_salida
     );
 tb_clk <= not(tb_clk) after clk_period; --T=30nS

process 
begin

wait for 200 ns;
tb_rst <= '0';
wait for 10 us;
tb_rst <= '1';
wait for 3 us;
tb_rst <= '0';
wait for 2 us;
tb_dato_A <= X"05";
tb_dato_B <= X"05";
tb_dato_C <= X"01";
wait for 100 ns;

tb_rst <= '0';
wait for 10 us;
tb_rst <= '1';
wait for 3 us;
tb_rst <= '0';

wait for 2 us;
tb_dato_A <= X"02";
tb_dato_B <= X"03";
tb_dato_C <= X"01";
wait for 100 ns;
wait;
end process;



end Behavioral;
