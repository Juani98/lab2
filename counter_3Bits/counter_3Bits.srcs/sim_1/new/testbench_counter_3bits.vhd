library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;
------------------------------------------------------------------
 -- Entity --
------------------------------------------------------------------
entity testbench_counter_3bits is
    generic(cnt_width: natural:= 3);
end testbench_counter_3bits;
------------------------------------------------------------------
 -- Architecture --
------------------------------------------------------------------
architecture Behavioral of testbench_counter_3bits is
    component counter_Nbits is
    Port (
            rst : in STD_LOGIC;
            enable: in std_logic;
            data_in : in STD_LOGIC_VECTOR (cnt_width-1 downto 0);
            clk : in STD_LOGIC;
            up_down : in STD_LOGIC;
            load_data : in STD_LOGIC;
            data_out : out STD_LOGIC_VECTOR (cnt_width-1 downto 0);
            carry_out : out std_logic
           );
    end component;
    signal tb_reset : std_logic :='1';
    signal tb_clock : std_logic :='0';
    signal tb_enable : std_logic :='0';
    signal tb_up_down : std_logic :='1';
    signal tb_load_data : std_logic :='0';
    signal tb_data_in : std_logic_vector (cnt_width-1 downto 0) := (others=>'0');
    signal tb_data_out: std_logic_vector (cnt_width-1 downto 0);
    signal tb_carry_out : std_logic;
    constant clk_period: time :=  5 ns; 
begin
      UUT_1: counter_Nbits port map (
        rst => tb_reset,
        enable => tb_enable,
        clk => tb_clock,
        data_in => tb_data_in,
        up_down => tb_up_down,
        load_data => tb_load_data,
        data_out => tb_data_out,
        carry_out => tb_carry_out
    );
    --clock 
    tb_clock <= not(tb_clock) after clk_period; --Tclk=10nS
------------------------------------------------------------------
-- Descripción --
-- Realizar una simulación por 2uS
------------------------------------------------------------------
    process
    begin
 --generacion de señale
 --reset
        wait for 20 ns;
        tb_reset <= '1'; 
        wait for 20 ns;
        tb_reset <= '0';
        wait for 20 ns;
        tb_load_data <= '1';
        wait for 50 ns;
        tb_data_in <= (others=>'0');
        wait for 50 ns;
        tb_load_data <= '0';
        wait for 50 ns;
        tb_enable <='1';
        wait for 50 ns;
        tb_enable <='0';
        wait;
    end process;
end Behavioral;