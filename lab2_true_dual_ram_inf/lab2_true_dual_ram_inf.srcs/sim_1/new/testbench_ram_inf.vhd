library IEEE;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
---------------------------------------------------------------------
-- Entity --
---------------------------------------------------------------------
entity testbench_ram_inf is
	generic 
	(
		DATA_WIDTH : natural := 8;
		ADDR_WIDTH : natural := 3
	);
end testbench_ram_inf;
---------------------------------------------------------------------
-- Architecture --
---------------------------------------------------------------------
architecture Behavioral of testbench_ram_inf is
component true_dp_bram is 
    port (
        -- Port A --
		clk_a	: in std_logic;
        addr_a	: in std_logic_vector(ADDR_WIDTH - 1 downto 0);
		we_a	: in std_logic;
        en_a	: in std_logic;
		data_a	: in std_logic_vector((DATA_WIDTH-1) downto 0);    --dato de entrada en A
		q_a		: out std_logic_vector((DATA_WIDTH -1) downto 0)  --dato de salida en A
	);
    end component;
    
    --Señales de simulación
    signal tb_clk_a : STD_LOGIC :='0';
    signal tb_we_a : std_logic :='0';
    signal tb_en_a	: std_logic;
    signal tb_addr_a : STD_LOGIC_VECTOR(ADDR_WIDTH - 1 DOWNTO 0);
    signal tb_data_a : STD_LOGIC_VECTOR((DATA_WIDTH-1) DOWNTO 0);
    signal tb_q_a : STD_LOGIC_VECTOR(DATA_WIDTH-1 DOWNTO 0);
    constant clk_period: time := 5 ns; --Tclk=10nS -> Ton = Toff = 5nS - 50% duty
   
begin
 --Mapeo de puertos de la UUT
     UUT_1: true_dp_bram port map (
     --Señales en RAM A
        clk_a => tb_clk_a,
        we_a => tb_we_a,
        addr_a => tb_addr_a,
        en_a => tb_en_a,
        data_a => tb_data_a,
        q_a => tb_q_a
     );
    tb_clk_a <= not(tb_clk_a) after clk_period; --T=10nS
---------------------------------------------------------------------
-- Descripción --
-- Ejecutar la simulación durante 1.5uS
---------------------------------------------------------------------
process 
begin
    --habilito la memoria
    tb_en_a <= '1';
    wait for 50 ns;
    
    --ESCRITURA DE DATOS    
    --Escribo un dato en dir 000
    tb_addr_a <= "000";
    wait for 50 ns;
    tb_data_a <= x"1a";
    wait for 50 ns;
    tb_we_a <= '1';
    wait for 50 ns;
    tb_we_a <= '0';
    wait for 50 ns;
    
    --Escribo un dato en dir 001
    tb_addr_a <= "001";
    wait for 50 ns;
    tb_data_a <= x"0f";
    wait for 50 ns;
    tb_we_a <= '1';
    wait for 50 ns;
    tb_we_a <= '0';
    wait for 50 ns;
    
    --Escribo un dato en dir 010
    tb_addr_a <= "010";
    wait for 50 ns;
    tb_data_a <= x"bb";
    wait for 50 ns;
    tb_we_a <= '1';
    wait for 50 ns;
    tb_we_a <= '0';
    wait for 50 ns;

    --Escribo un dato en dir 011
    tb_data_a <= x"ff";
    wait for 50 ns;
    tb_addr_a <= "011";
    wait for 50 ns;
    tb_we_a <= '1';
    wait for 50 ns;
    tb_we_a <= '0';
    wait for 50 ns;
    
    
    --LEO VALORES CARGADOS
    tb_addr_a <= "000";
    wait for 100 ns;
    tb_addr_a <= "001";
    wait for 100 ns;
    tb_addr_a <= "010";
    wait for 100 ns;
    tb_addr_a <= "011";
    wait for 100 ns;
    
    wait;
end process;
end Behavioral;
