library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.package_inf_rom.all;

entity lab2_ROM_D_inf is
    port (
        clk :in std_logic;
        address :in std_logic_vector(addr_length-1 downto 0);
        data_out:out std_logic_vector(data_length-1 downto 0)
    );
end lab2_ROM_D_inf;
architecture beh of lab2_ROM_D_inf is
--SIN ERRORES
--     constant memD : mem_type :=(
--        0 => x"06",1 => x"09",2 => x"0c",3 => x"0f",
--        4 => x"12",5 => x"15",6 => x"18",7 => x"1b"
--     );
          
     --ERRORES
--     constant memD : mem_type :=(
--        0 => x"02",1 => x"03",2 => x"04",3 => x"05",
--        4 => x"12",5 => x"07",6 => x"08",7 => x"09"
--     );

--CON UN ERROR
     constant memD : mem_type :=(
        0 => x"06",1 => x"08",2 => x"0c",3 => x"0f",
        4 => x"12",5 => x"15",6 => x"18",7 => x"1b"
     );

begin
    rom : process (clk)
    begin
    if rising_edge(clk) then
        data_out <= memD(to_integer(unsigned(address)));
    end if;
    end process rom;
end architecture beh;
