library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
use work.package_inf_rom.all;
-------------------------------------------------------------------
 -- Enitiy --
-------------------------------------------------------------------
entity lab2_ROM_inf_testbench is

end lab2_ROM_inf_testbench;
-------------------------------------------------------------------
 -- Architecture --
-------------------------------------------------------------------
architecture Behavioral of lab2_ROM_inf_testbench is
    component lab2_ROM_inf is 
        Port(
            clk :in std_logic;
            address :in std_logic_vector(addr_length-1 downto 0);
            data_out:out std_logic_vector(data_length-1 downto 0)
         );
        end component;
    --asignacion de señales para simulación
    signal tb_rst : std_logic :='0';
    signal tb_clk : std_logic :='0';
    signal tb_address : std_logic_vector(addr_length-1 downto 0);
    signal tb_data_out : std_logic_vector(data_length-1 downto 0);
    constant clk_period: time := 15 ns; --Tclk=30nS -> Ton = Toff = 15nS - 50% duty
begin
 --Mapeo de puertos de la UUT
     UUT_1: lab2_ROM_inf port map (
         clk => tb_clk,
         address => tb_address,
         data_out=> tb_data_out
     );
 tb_clk <= not(tb_clk) after clk_period; --T=30nS

process 
begin

wait for 200 ns;
tb_address <= "000";
wait for 200 ns;
tb_address <= "001";
wait for 200 ns;
tb_address <= "010";
wait for 200 ns;
tb_address <= "011";
wait for 200 ns;
tb_address <= "100";
wait for 200 ns;
tb_address <= "101";
wait for 200 ns;
tb_address <= "110";
wait for 200 ns;
tb_address <= "111";
wait for 200 ns;

wait;
end process;



end Behavioral;
