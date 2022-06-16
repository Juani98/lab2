library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;
------------------------------------------------------------------
 -- Enitiy --
------------------------------------------------------------------
entity divisor_frecuencia is
    generic(cnt_width: natural:= 29);
    Port ( 
        input_clk : in STD_LOGIC;
        reset : in std_logic;
        frec_selec : in std_logic_vector(2 downto 0);
        output_clk : out STD_LOGIC
        );
end divisor_frecuencia;
------------------------------------------------------------------
 -- Architecture --
------------------------------------------------------------------
architecture Behavioral of divisor_frecuencia is
--Componentes
-- Contador de 28bits para 33,33Mhz 
-- Nota: Para usar en la placa con clk de 100Mhz => configurar contador a 29bits 
--       Para simular con clk de 33,33Mhz => configurar contador a 28bits 
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
--Sincronizador de señales asincrónicas
    component synchronizer is
        Port ( 
            reset : in STD_LOGIC;
            clock : in STD_LOGIC;
            async_input : in STD_LOGIC;
            sync_output : out STD_LOGIC
        );
    end component;
--Reset con act. asincrónica y desact. sincrónica
    component rst_async_ass_synch_deass is
    port(
        sys_clk : in std_logic;
        sys_rst : in std_logic;
        rst_aa_sd: out std_logic
    );
    end component;
    
    
--señales internas (contador)
signal internal_data_counter_in : STD_LOGIC_VECTOR (cnt_width-1 downto 0);
signal internal_data_counter_out : STD_LOGIC_VECTOR (cnt_width-1 downto 0);
signal internal_counter_carry_out : std_logic;
signal internal_pre_load_data : STD_LOGIC;

--signal data_counter  : unsigned(cnt_width downto 0);
signal internal_output : std_logic; --salida por LED0 (para cada señal de distinta frecuencia)
signal internal_reset : std_logic;-- reset con activacion asincronica y desactivacion sincronica
signal internal_frec_selec : std_logic_vector(2 downto 0); -- seleccion de frecuencia sincronizada
begin

    --Componentes
    --Componente N1: contador de 28bits
     counter1: counter_Nbits port map(
        rst => internal_reset,
        enable => '0',
        data_in => internal_data_counter_in,
        clk => input_clk,
        up_down => '0', --lo uso para que decremente
        load_data => internal_pre_load_data, 
        data_out => internal_data_counter_out,
        carry_out => internal_counter_carry_out
    );
    --Componente N2: Reset con act. asincrónica y desact. sincrónica
    rst_async_ass_synch_deass1: rst_async_ass_synch_deass port map(
        sys_clk => input_clk,
        sys_rst => reset,
        rst_aa_sd => internal_reset --reset sincronico
    );  
    --Componente N2: Sincronizador 1
    synchronizer1: synchronizer port map(
        reset => internal_reset,
        clock => input_clk,
        async_input => frec_selec(0), --entrada asincronica
        sync_output => internal_frec_selec(0)
    );   
    --Componente N2: Sincronizador 2
    synchronizer2: synchronizer port map(
        reset => internal_reset,
        clock => input_clk,
        async_input => frec_selec(1), --entrada asincronica
        sync_output => internal_frec_selec(1)
    );
    --Componente N2: Sincronizador 3
    synchronizer3: synchronizer port map(
        reset => internal_reset,
        clock => input_clk,
        async_input => frec_selec(2), --entrada asincronica
        sync_output => internal_frec_selec(2)
    );
    with internal_frec_selec select
-- Este fragmento de código se utilizó para cargar en la placa debido al clk de 100Mhz, y no de 33,3MHz
-- Este código está pensado para un clk de 100Mhz
        internal_data_counter_in <= "00000100110001001011010000000" when "000",  --f=5Hz
                                    "00001011111010111100001000000" when "001",  --f=2Hz
                                    "00010111110101111000010000000" when "010",  --f=1Hz
                                    "00101111101011110000100000000" when "011",  --f=0.5Hz
                                    "11101110011010110010100000000" when others; --f=0.1Hz


    process (internal_reset,input_clk,internal_counter_carry_out)
    begin 
    if(internal_reset='1') then --reset activo en alto
        internal_output <='0';
    elsif(rising_edge(input_clk)) then 
              if(internal_counter_carry_out='1') then --finalizó la cuenta
                    internal_pre_load_data <='1'; --precargo nuevo dato
                    internal_output <= not(internal_output); --invierto la salida
                else
                    internal_pre_load_data <='0'; --si no hubo desborde, inhabilito la precarga
                end if;
        end if;
    end process;
    output_clk <= internal_output;
end Behavioral;






