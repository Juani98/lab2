library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
use work.package_inf_rom.all;
------------------------------------------------------------------
 -- Enitiy --
------------------------------------------------------------------
entity lab2_top_v3 is
    Port(
	   reset : in std_logic;
	   clock : in std_logic; 
	   acuse_error_comp : in std_logic; --error de comparacion
	   start_cycle : in std_logic; --inicio de ciclo FSM
	   output_comp : out std_logic;

	   --estas 2 últimas señales se usaron para debuguear en la placa
	   out_state_FSM : out std_logic_vector(3 downto 0);
	   hay_error_salida : out std_logic
	   );
end lab2_top_v3;
------------------------------------------------------------------
 -- Architecture --
------------------------------------------------------------------
architecture Behavioral of lab2_top_v3 is

--Componentes
--Contador de 3bits
component counter_3bits is
    generic(cnt_width: natural:= 3); --selección de la resolución del contador
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

--Reset asincrónico para activación y sincrónico para la desactivacion.
component rst_async_ass_synch_deass_v2 is
    generic(
        rst_width : integer := 2; 
        rst_active_value : std_logic := '1' --reset activo en 1
    );
    port(
        sys_clk : in std_logic;
        sys_rst : in std_logic;
        rst_aa_sd : out std_logic
    );
end component;

--Máquina de estados
component lab2_FSM is 
	port(
	   reset : in std_logic;
	   clk : in std_logic; 
	   carry_out_counter : in std_logic; -- carry de salida del contador
	   acuse_error_comp : in std_logic; --señal externa de acuse de un error de comparacion 
	   start_cycle : in std_logic; --inicio de ciclo FSM
	   load_counter : out std_logic;
	   en_counter : out std_logic;
	   wea_A : out std_logic; --habilitacion data in A, Mem RAM
	   wea_B : out std_logic; -- habilitacion data in B, Mem RAM
	   hay_error_comp : in std_logic;
	   out_current_state : out std_logic_vector(3 downto 0);
	   flag_de_error_comp : out std_logic
	);
end component;

--Bloque sumador
component lad2_bloque_sumador is
     generic(
         bus_width : natural := 8
     );
     port(
         clk : in std_logic;
         rst : in std_logic;
         dato_A : in std_logic_vector(bus_width-1 downto 0);
         dato_B : in std_logic_vector(bus_width-1 downto 0);
         dato_C : in std_logic_vector(bus_width-1 downto 0);
         dato_salida : out std_logic_vector(bus_width-1 downto 0)
     );
end component;

--Memoria ROM inferida
component lab2_ROM_inf is --Esta es de tamaño de 8bits
    port (
        clk :in std_logic;
        address :in std_logic_vector(addr_length-1 downto 0);
        data_out:out std_logic_vector(data_length-1 downto 0)
    );
end component;

--Memoria ROM generada
component lab2_ROM_gen is
    Port (
        clka : IN STD_LOGIC;
        addra : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        douta : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
    );
end component;

--Memoria RAM single inferida
component single_ram is
	generic 
	(
		DATA_WIDTH : natural := 8;
		ADDR_WIDTH : natural := 3
	);
    Port (
        clk	: in std_logic;
        addr	: in std_logic_vector(ADDR_WIDTH - 1 downto 0);
		we	: in std_logic;
        en	: in std_logic;
		data	: in std_logic_vector((DATA_WIDTH-1) downto 0);
		q		: out std_logic_vector((DATA_WIDTH -1) downto 0)
    );
end component;

--Comparador de salida
component lab2_comparador_salida is
    generic(bus_width: natural:= 8);
    Port (
        clk : in std_logic;
        rst : in std_logic;
        data_in_A : in std_logic_vector(bus_width-1 downto 0);
        data_in_B : in std_logic_vector(bus_width-1 downto 0);
        data_out : out std_logic;
        hay_error_comp : out std_logic;
        flag_aviso_error_FSM : in std_logic
    );
end component;

--Registro de 8bits
component reg_8bits is
    Port ( d : in STD_LOGIC_VECTOR(7 downto 0);
       q : out STD_LOGIC_VECTOR(7 downto 0);
       r : in STD_LOGIC;
       clk : in STD_LOGIC
       );
end component;

--Circuito antirebote
component debounce_v2 is
    generic(cnt_width: natural:= 21);
    Port ( 
        debounce_input : in STD_LOGIC;
        clock : in STD_LOGIC;
        reset : in std_logic;
        debounce_output : out STD_LOGIC
        );
end component;

--Memoria ROM D inferida
component lab2_ROM_D_inf is
    port (
        clk :in std_logic;
        address :in std_logic_vector(addr_length-1 downto 0);
        data_out:out std_logic_vector(data_length-1 downto 0)
    );
end component;

--Señales internas generales
signal internal_reset : std_logic;-- reset con activacion asincronica y desactivacion sincronica

--Señales internas contador 3bits
signal internal_enable_counter : std_logic; --enable de counter manejado por FSM
signal internal_pre_load_data : std_logic; --pre_load_data manejado por FSM
signal internal_bus_address : std_logic_vector(addr_length-1 downto 0);
signal internal_carry_out : std_logic; --carry_out manejado por FSM

--Señales internas Memoria RAM
signal internal_wen_A : std_logic;
signal internal_wen_B : std_logic;

--Señal interna de entrada a las RAMs
signal internal_data_in_RAM_A : std_logic_vector(data_length-1 downto 0);
signal internal_data_in_RAM_B : std_logic_vector(data_length-1 downto 0);

--Señal interna de salida de las RAMs
signal internal_data_out_RAM_A : std_logic_vector(data_length-1 downto 0);
signal internal_data_out_RAM_B : std_logic_vector(data_length-1 downto 0);


--Señales internas bloque sumador y ROMS
--signal internal_dato_ROM_A_out : std_logic_vector(data_length-1 downto 0);
signal internal_dato_ROM_B_out : std_logic_vector(data_length-1 downto 0);
--signal internal_dato_ROM_C_out : std_logic_vector(data_length-1 downto 0);

signal internal_dato_salida : std_logic_vector(data_length-1 downto 0); ---------------------------CORREGIR TAMAÑO

--Registros de 8 bits de retardo
signal internal_in_reg_Rom_A : std_logic_vector(data_length-1 downto 0); 
signal internal_out_reg_Rom_A : std_logic_vector(data_length-1 downto 0); 
signal internal_in_reg_Rom_C : std_logic_vector(data_length-1 downto 0); 
signal internal_out_reg_Rom_C : std_logic_vector(data_length-1 downto 0); 


--Bloque comparador de salida
signal internal_hay_error_comp : std_logic;


--Antirebote
signal debounced_input_start_cycle : std_logic;
signal debounced_input_acuse_error_comp : std_logic;


signal internal_flag_aviso_error_comp : std_logic; 
--- Esta señal avisa y queda fijada en 1 si hubo error. EL aviso sale desde la FSM

begin

    --Componente N1
    --Contador de 3bits
    --Descripción: Maneja el bus de direcciones
    COMP_N1_counter3bits: counter_3bits port map(
        rst => internal_reset,
        enable => internal_enable_counter,
        data_in => (others=>'0'),
        clk => clock,
        up_down => '1', --configurado para que incremente
        load_data => internal_pre_load_data, 
        data_out => internal_bus_address,
        carry_out => internal_carry_out    
    );
    
    --Componente N2
    --PowerOnReset
    --Descripción: Reset con activación asincrónica, y activación sincrónica
    --Valor activo en alto
    COMP_N2_PowerOnRst: rst_async_ass_synch_deass_v2 port map(
        sys_clk => clock, --entrada de reloj
        sys_rst => reset, --entrada asincrónica
        rst_aa_sd => internal_reset --salida sincrónica
    );

    --Componente N3
    --Máquina de estados
    --Descripción: Controla los componentes del sistema
    COMP_N3_FSM: lab2_FSM port map(
        reset => internal_reset, 
        clk => clock,
        carry_out_counter => internal_carry_out,
        acuse_error_comp => debounced_input_acuse_error_comp,
     --  acuse_error_comp => acuse_error_comp,  -- Esta señal se uso para debuguear sin antirebote
       start_cycle => debounced_input_start_cycle,
    -- start_cycle => start_cycle,              -- Esta señal se uso para debuguear sin antirebote
        load_counter => internal_pre_load_data,
        en_counter => internal_enable_counter,
        wea_A => internal_wen_A,
        wea_B => internal_wen_B,
        hay_error_comp => internal_hay_error_comp,
        out_current_state => out_state_FSM ,
        flag_de_error_comp => internal_flag_aviso_error_comp
    );

    --Componente N4
    --Bloque sumador
    --Descripción: Suma datos provenientes de las memorias
    COMP_N4_bloque_sumador: lad2_bloque_sumador port map(
        clk => clock,
        rst => internal_reset, 
        dato_A => internal_out_reg_Rom_A, --esta ingresa a un registro
        dato_B => internal_dato_ROM_B_out, --esta NO ingresa al registro
        dato_C => internal_out_reg_Rom_C,--esta ingresa a un registro
        dato_salida => internal_data_in_RAM_A 
    );
    --Componente N5
    --ROM A (inferida)
    --Descripción: Almacena datos a sumar
    COMP_N5_ROM_A: lab2_ROM_inf port map(
        clk => clock,
        address => internal_bus_address,
        data_out => internal_in_reg_Rom_A
    );
    --Componente N6
    --ROM C (inferida)
    --Descripción: Almacena datos a sumar
    COMP_N6_ROM_C: lab2_ROM_inf port map(
        clk => clock,
        address => internal_bus_address,
        data_out => internal_in_reg_Rom_C
    );
     --Componente N7
    --ROM D (inferida)
    --Descripción: Almacena las sumas esperadas
    COMP_N7_ROM_D: lab2_ROM_D_inf port map(
        clk => clock,
        address => internal_bus_address,
        data_out => internal_data_in_RAM_B ------------------------------------------------------AQUI VA HABER PROBLEMA DE TAMAÑO DE SEÑALES
    );
    --Componente N8
    --ROM B (IP Core)
    --Descripción: Almacena datos a sumar
   COMP_N8_ROM_B: lab2_ROM_gen port map(
        clka => clock,
        addra => internal_bus_address,
        douta => internal_dato_ROM_B_out
    );
    --Componente N9
    --RAM A (inferida)
    --Descripción: Almacena datos de la suma
    COMP_N9_RAM_A: single_ram port map(
        clk => clock,
        we => internal_wen_A, 
        addr => internal_bus_address,
        data => internal_data_in_RAM_A,
        q => internal_data_out_RAM_A,
        en => '1'
    );
    --Componente N10
    --RAM B (inferida)
    --Descripción: Almacena datos de la memoria ROM D
    -- o sea, las sumas esperadas
     COMP_N10_RAM_B: single_ram port map(
        clk => clock,
        we => internal_wen_B, 
        addr => internal_bus_address,
        data => internal_data_in_RAM_B,
        q => internal_data_out_RAM_B,
        en => '1'
    );

    --Componente N11
    --COMPARADOR de salida
    --Descripción: Realiza la comparacion de los datos
    -- si hay error en la comparacion avisa a la FSM
    COMP_N11_COMP_SALIDA: lab2_comparador_salida port map(
        clk => clock,
        rst => internal_reset,
        data_in_A => internal_data_out_RAM_A,
        data_in_B => internal_data_out_RAM_B,
        data_out => output_comp,
        hay_error_comp => internal_hay_error_comp,
        flag_aviso_error_FSM => internal_flag_aviso_error_comp
    );
    --Componente N12
    --Registro de 8bits
    --Descripción: Retrasa 1 ciclo de reloj los datos
    -- de la ROM A inferida
     COMP_N12_REG_A_ROM_A: reg_8bits port map(
        clk => clock,
        r=> internal_reset,
        d => internal_in_reg_Rom_A,
        q => internal_out_reg_Rom_A
    );
    --Componente N13
    --Registro de 8bits
    --Descripción: Retrasa 1 ciclo de reloj los datos
    -- de la ROM C inferida
    COMP_N13_REG_C_ROM_C: reg_8bits port map(
        clk => clock,
        r=> internal_reset,
        d => internal_in_reg_Rom_C,
        q => internal_out_reg_Rom_C
    );
    --Componente N14
    --Antirebote
    --Descripción: Circuito antirebote para la señal
    -- de entrada externa start_cycle
    COMP_N14_DEBOUNCE_START: debounce_v2 port map(
        clock => clock,
        reset => internal_reset,
        debounce_input => start_cycle,
       debounce_output => debounced_input_start_cycle
     --  debounce_output => open 
    );
    --Componente N15
    --Antirebote
    --Descripción: Circuito antirebote para la señal
    -- de entrada externa acuse_error_comp
    COMP_N15_DEBOUNCE_ACUSE_ERR: debounce_v2 port map(
        clock => clock,
        reset => internal_reset,
        debounce_input => acuse_error_comp,
        debounce_output => debounced_input_acuse_error_comp
     -- debounce_output => open
    );
    hay_error_salida <= internal_hay_error_comp;
end Behavioral;
