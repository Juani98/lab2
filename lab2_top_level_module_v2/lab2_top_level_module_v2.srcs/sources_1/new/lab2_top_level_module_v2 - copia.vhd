library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
use work.package_inf_rom.all;
------------------------------------------------------------------
 -- Enitiy --
------------------------------------------------------------------
entity lab2_top_level_module_v2 is
    Port(
	   reset : in std_logic;
	   clock : in std_logic; 
	   error_comp : in std_logic; --error de comparacion
	   start_cycle : in std_logic; --inicio de ciclo FSM
	   output_comp : out std_logic
	   );
end lab2_top_level_module_v2;
------------------------------------------------------------------
 -- Architecture --
------------------------------------------------------------------
architecture Behavioral of lab2_top_level_module_v2 is
--Componentes
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

component lab2_FSM is 
	port(
	   reset : in std_logic;
	   clk : in std_logic; 
	   carry_out_counter : in std_logic; -- carry de salida del contador
	   error_comp : in std_logic; --error de comparacion
	   start_cycle : in std_logic; --inicio de ciclo FSM
	   load_counter : out std_logic;
	   en_counter : out std_logic;
	   wea_A : out std_logic_vector(0 downto 0); --habilitacion data in A, Mem RAM
	   wea_B : out std_logic_vector(0 downto 0) -- habilitacion data in B, Mem RAM
	);
end component;


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


component lab2_ROM_inf is --Esta es de tamaño de 8bits
    port (
        clk :in std_logic;
        address :in std_logic_vector(addr_length-1 downto 0);
        data_out:out std_logic_vector(data_length-1 downto 0)
    );
end component;

--component lab2_ROM_inf_v2 is --Esta es de tamaño de 9bits
--    port (
--        clk :in std_logic;
--        address :in std_logic_vector(addr_length-1 downto 0);
--        data_out:out std_logic_vector(data_length downto 0)
--    );
--end component;



component lab2_ROM_gen is
    Port (
        clka : IN STD_LOGIC;
        addra : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        douta : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
    );
end component;


component lab2_dual_port_ram_gen is
    Port (
        clka : IN STD_LOGIC;
        wea : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
        addra : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        dina : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
        douta : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
        clkb : IN STD_LOGIC;
        web : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
        addrb : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        dinb : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
        doutb : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
    );
end component;


component lab2_comparador_salida is
    generic(bus_width: natural:= 8);
    Port (
        clk : in std_logic;
        rst : in std_logic;
        data_in_A : in std_logic_vector(bus_width-1 downto 0);
        data_in_B : in std_logic_vector(bus_width-1 downto 0);
        data_out : out std_logic
    );
end component;

--Señales internas generales
--signal internal_output : std_logic; --salida por LED0 (para cada señal de distinta frecuencia)
signal internal_reset : std_logic;-- reset con activacion asincronica y desactivacion sincronica

--Señales internas contador 3bits
signal internal_enable_counter : std_logic; --enable de counter manejado por FSM
signal internal_pre_load_data : std_logic;
signal internal_bus_address : std_logic_vector(addr_length-1 downto 0);
signal internal_carry_out : std_logic; --carry_out manejado por FSM

--Señales internas Memoria RAM
signal internal_wen_A : std_logic_vector(0 downto 0);
signal internal_wen_B : std_logic_vector(0 downto 0);

signal internal_data_in_RAM_A : std_logic_vector(data_length-1 downto 0);
signal internal_data_in_RAM_B : std_logic_vector(data_length-1 downto 0);

signal internal_data_out_RAM_A : std_logic_vector(data_length-1 downto 0);
signal internal_data_out_RAM_B : std_logic_vector(data_length-1 downto 0);


--Señales internas bloque sumador y ROMS
signal internal_dato_A : std_logic_vector(data_length-1 downto 0);
signal internal_dato_B : std_logic_vector(data_length-1 downto 0);
signal internal_dato_C : std_logic_vector(data_length-1 downto 0);
signal internal_dato_salida : std_logic_vector(data_length-1 downto 0); ---------------------------CORREGIR TAMAÑO

begin
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

    COMP_N2_PowerOnRst: rst_async_ass_synch_deass_v2 port map(
        sys_clk => clock, --entrada de reloj
        sys_rst => reset, --entrada asincrónica
        rst_aa_sd => internal_reset --salida sincrónica
    );


    COMP_N3_FSM: lab2_FSM port map(
        reset => internal_reset, 
        clk => clock,
        carry_out_counter => internal_carry_out,
        error_comp => error_comp, ------------------------------------------------------------FALTA ANTIREBOTE
        start_cycle => start_cycle,
        load_counter => internal_pre_load_data,
        en_counter => internal_enable_counter,
        wea_A => internal_wen_A,
        wea_B => internal_wen_B
    );


    COMP_N4_bloque_sumador: lad2_bloque_sumador port map(
        clk => clock,
        rst => internal_reset, 
        dato_A => internal_dato_A,
        dato_B => internal_dato_B,
        dato_C => internal_dato_C,
        dato_salida => internal_data_in_RAM_A
    );

    COMP_N5_ROM_A: lab2_ROM_inf port map(
        clk => clock,
        address => internal_bus_address,
        data_out => internal_dato_A
    );
    COMP_N6_ROM_C: lab2_ROM_inf port map(
        clk => clock,
        address => internal_bus_address,
        data_out => internal_dato_C
    );
    
    COMP_N7_ROM_D: lab2_ROM_inf port map(
        clk => clock,
        address => internal_bus_address,
        data_out => internal_data_in_RAM_B ------------------------------------------------------AQUI VA HABER PROBLEMA DE TAMAÑO DE SEÑALES
    );
    
    
   COMP_N8_ROM_B: lab2_ROM_gen port map(
        clka => clock,
        addra => internal_bus_address,
        douta => internal_dato_B
    );

    COMP_N9_DUAL_PORT_RAM: lab2_dual_port_ram_gen port map(
        clka => clock,
        wea => internal_wen_A, 
        addra => internal_bus_address,
        dina => internal_data_in_RAM_A,
        douta => internal_data_out_RAM_A,
        clkb => clock,
        web => internal_wen_B,
        addrb => internal_bus_address,
        dinb => internal_data_in_RAM_B,
        doutb => internal_data_out_RAM_B
    );


    COMP_N10_COMP_SALIDA: lab2_comparador_salida port map(
        clk => clock,
        rst => internal_reset,
        data_in_A => internal_data_out_RAM_A,
        data_in_B => internal_data_out_RAM_B,
        data_out => output_comp
    );
    
end Behavioral;
