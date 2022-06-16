library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;

entity testbench_comparador_salida is
    generic(bus_width: natural:= 9);
end testbench_comparador_salida;

architecture Behavioral of testbench_comparador_salida is
component lab2_comparador_salida is
    Port (
        clk : in std_logic;
        rst : in std_logic;
        data_in_A : in std_logic_vector(bus_width-1 downto 0);
        data_in_B : in std_logic_vector(bus_width-1 downto 0);
        data_out : out std_logic
--        fin_operacion : out std_logic
    );
end component;
    --Señales de simulación
    --  signal tb_clka : STD_LOGIC :='0';
    signal tb_clk : std_logic :='0';
    signal tb_rst : std_logic :='0';
    signal tb_data_out : STD_LOGIC;
    signal tb_data_in_A : STD_LOGIC_VECTOR(bus_width-1 DOWNTO 0);
    signal tb_data_in_B : STD_LOGIC_VECTOR(bus_width-1 DOWNTO 0);
    constant clk_period: time := 5 ns; --Tclk=10nS -> Ton = Toff = 5nS - 50% duty
    -- PARA ESTA SIMULACION SE USA UN CLK DE 100MHZ CORRESPONDIENTE AL DEL ZEDBOARD 
begin
 --Mapeo de puertos de la UUT
     UUT_1: lab2_comparador_salida port map (
        clk => tb_clk,
        rst => tb_rst,
        data_in_A => tb_data_in_A,
        data_in_b => tb_data_in_b,
        data_out => tb_data_out
     );
    tb_clk <= not(tb_clk) after clk_period; --T=10nS
    
    process 
    begin
    tb_rst <= '1';
    wait for 200 ns;
    tb_rst <= '0';
    wait for 200 ns;
    tb_data_in_A <= "000000010";
    wait for 200 ns;
    tb_data_in_B <= "000000010";
    wait for 200 ns;
    tb_data_in_B <= "000000001";
    wait for 200 ns;
    tb_data_in_A <= "000000011";
    wait for 200 ns;
    wait;
    end process;   

end Behavioral;
