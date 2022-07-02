library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;
-------------------------------------------------------------------
 -- Enitiy --
-------------------------------------------------------------------
entity lad2_bloque_sumador is
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
end lad2_bloque_sumador;
-------------------------------------------------------------------
 -- Architecture --
-------------------------------------------------------------------
architecture Behavioral of lad2_bloque_sumador is
--Señales internas
signal internal_dato_A : std_logic_vector(bus_width-1 downto 0); 
signal internal_dato_B : std_logic_vector(bus_width-1 downto 0); 
signal internal_dato_C : std_logic_vector(bus_width-1 downto 0); 
signal suma_AyB : unsigned(bus_width-1 downto 0);
signal suma_AyByC : unsigned(bus_width-1 downto 0);
--signal internal_suma_A_B_C : std_logic_vector(bus_width-1 downto 0); 
begin
-- Lógica concurrente y combinacional
suma_AyB <= unsigned(internal_dato_A) + unsigned(internal_dato_B);
suma_AyByC <= unsigned(internal_dato_C) + suma_AyB;
-- Lógica secuencial
    process (clk,rst)
        --variables de process
         begin
         if (rst='1') then --Reset activo en bajo
            dato_salida<= (others=>'0');
            internal_dato_A <= (others=>'0');
            internal_dato_B <= (others=>'0');
            internal_dato_C <= (others=>'0');
         elsif (rising_edge(clk)) then
            internal_dato_A <= dato_A;
            internal_dato_B <= dato_B;
            internal_dato_C <= dato_C;
            dato_salida <= std_logic_vector(suma_AyByC);
         end if;
 end process;

end Behavioral;
