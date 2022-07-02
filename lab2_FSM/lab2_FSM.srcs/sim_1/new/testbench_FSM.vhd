library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
------------------------------------------------------------------
 -- Entity --
------------------------------------------------------------------
entity testbench_FSM is
--  Port ( );
end testbench_FSM;
------------------------------------------------------------------
 -- Architecture --
------------------------------------------------------------------
architecture Behavioral of testbench_FSM is
component lab2_FSM is
	   port(
	   reset : in std_logic;
	   clk : in std_logic; 
	   carry_out_counter : in std_logic; -- carry de salida del contador
	   acuse_error_comp : in std_logic; --señal externa de acuse de un error de comparacion (proviene del operario)
	   start_cycle : in std_logic; --inicio de ciclo FSM
	   load_counter : out std_logic; --controla la precarga del contador que maneja el bus de direcciones
	   en_counter : out std_logic; --controla el enable del contador. Permite mantener una direccion fija si es asertiva
	   wea_A : out std_logic; --habilitacion data in A, Mem RAM
	   wea_B : out std_logic; -- habilitacion data in B, Mem RAM
	   hay_error_comp : in std_logic; --Ingreso de aviso de error de comp (proviene del comparador)
	   flag_de_error_comp : out std_logic; --aviso desde FSM que hay error de comp
	   --señal de debug
	   out_current_state : out std_logic_vector(3 downto 0) --registro de estado actual
    );
end component;
    --asignacion de señales para simulación
    signal tb_reset : std_logic :='0';
    signal tb_clk : std_logic :='0';
    signal tb_carry_out_counter : std_logic;
    signal tb_acuse_error_comp : std_logic;
    signal tb_start_cycle : std_logic;
    signal tb_load_counter : std_logic;
    signal tb_en_counter : std_logic;
    signal tb_wea_A : std_logic;
    signal tb_wea_B : std_logic;
    signal tb_hay_error_comp : std_logic;
    signal tb_flag_de_error_comp : std_logic;
    signal tb_out_current_state : std_logic_vector(3 downto 0);
    constant clk_period: time := 5 ns; --Tclk=10nS -> Ton = Toff = 5nS - 50% duty
begin
 --Mapeo de puertos de la UUT
     UUT_1: lab2_FSM port map (
         clk => tb_clk,
         reset => tb_reset,
         carry_out_counter => tb_carry_out_counter,
         acuse_error_comp => tb_acuse_error_comp,
         start_cycle => tb_start_cycle,
         load_counter => tb_load_counter,
         en_counter => tb_en_counter,
         wea_A => tb_wea_A,
         wea_B => tb_wea_B,
         hay_error_comp => tb_hay_error_comp,
         flag_de_error_comp => tb_flag_de_error_comp,
         out_current_state => tb_out_current_state
     );
   --clock 
    tb_clk <= not(tb_clk) after clk_period;
    process   
    begin
------------------------------------------------------------------
 -- Descripción --
 -- Ejecutar la simulación por 400nS, y seguir los comentarios en el código
 -- y/o la descripción del funcionamiento en el informe
------------------------------------------------------------------
    --desactivo reset
    tb_reset <= '1';
    wait for 20 ns;
    tb_reset <= '0';
    tb_start_cycle <= '1';
    wait for 50 ns;
    tb_start_cycle <= '0';
    wait for 15 ns;
    tb_carry_out_counter <= '0';
    --Aqui debe repetir un ciclo de carga
    
    --Aqui inicia el ciclo de lectura (fin de ciclo de escritura)
    wait for 70 ns;
    tb_carry_out_counter <= '1';
    wait for 20 ns;
    tb_carry_out_counter <= '0';
    
    --Completa una lectura, y sigue con la próxima dirección
    wait for 50 ns;
    tb_hay_error_comp <= '0';
    tb_carry_out_counter <= '0';
    
    --Encuentra que hay un error en la comparacion y queda a la espera (en el estado S12)
    --de acuse de error por parte del usuario
    tb_hay_error_comp <= '1';
    tb_acuse_error_comp <= '0';
    wait for 70 ns;
    tb_acuse_error_comp <= '1'; --Aquí la persona presiona un botón acusando que hay error
    --Aqui retorna al estado IDLE
    wait;
    end process;
end Behavioral;
