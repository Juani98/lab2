library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity lab2_testbench_dual_port_ram_gen is
--  Port ( );
end lab2_testbench_dual_port_ram_gen;

architecture Behavioral of lab2_testbench_dual_port_ram_gen is

component lab2_dual_port_ram_gen is 
    Port(
        clka : IN STD_LOGIC;
        wea : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
        addra : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
        dina : IN STD_LOGIC_VECTOR(8 DOWNTO 0);
        douta : OUT STD_LOGIC_VECTOR(8 DOWNTO 0);
        clkb : IN STD_LOGIC;
        web : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
        addrb : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
        dinb : IN STD_LOGIC_VECTOR(8 DOWNTO 0);
        doutb : OUT STD_LOGIC_VECTOR(8 DOWNTO 0)
     );
    end component;
    
    --Señales de simulación
    signal tb_clka : STD_LOGIC :='0';
    signal tb_wea : STD_LOGIC_VECTOR(0 DOWNTO 0);
    signal tb_addra : STD_LOGIC_VECTOR(3 DOWNTO 0);
    signal tb_dina : STD_LOGIC_VECTOR(8 DOWNTO 0);
    signal tb_douta : STD_LOGIC_VECTOR(8 DOWNTO 0);
    signal tb_clkb : STD_LOGIC :='0';
    signal tb_web : STD_LOGIC_VECTOR(0 DOWNTO 0);
    signal tb_addrb : STD_LOGIC_VECTOR(3 DOWNTO 0);
    signal tb_dinb : STD_LOGIC_VECTOR(8 DOWNTO 0);
    signal tb_doutb : STD_LOGIC_VECTOR(8 DOWNTO 0);

    constant clk_period: time := 15 ns; --Tclk=30nS -> Ton = Toff = 15nS - 50% duty
   
begin
 --Mapeo de puertos de la UUT
     UUT_1: lab2_dual_port_ram_gen port map (
        clka => tb_clka,
        wea => tb_wea,
        addra => tb_addra,
        dina => tb_dina,
        douta => tb_douta,
        clkb => tb_clkb,
        web => tb_web,
        addrb => tb_addrb,
        dinb => tb_dinb,
        doutb => tb_doutb 
     );
    tb_clka <= not(tb_clka) after clk_period; --T=30nS
    tb_clkb <= not(tb_clkb) after clk_period; --T=30nS
process 
begin
    wait for 200 ns;
    tb_addra <= "0000";
    wait for 200 ns;
    tb_addra <= "0001";
    wait for 200 ns;
    tb_dina <= "0" & x"0f";
    wait for 200 ns;
    tb_addrb <= "0001";
    wait for 200 ns;
    tb_dinb <= "0" & x"0f";
    tb_wea <= "1";
    wait for 40 ns;
    tb_wea <= "0";
    wait for 200 ns;
    tb_addra <= "0010";
    wait for 200 ns;
    tb_addra <= "0001";
    wait for 200 ns;
    tb_dina <= "1" & x"ff";
    tb_wea <= "1";
    wait for 40 ns;
    tb_wea <= "0";
    tb_addra <= "0100";
    wait for 200 ns;
    tb_addra <= "0001";
    wait for 200 ns;
    tb_addra <= "0110";
    wait for 200 ns;
    tb_addra <= "0111";
    wait for 200 ns;
    
    wait;
end process;
end Behavioral;
