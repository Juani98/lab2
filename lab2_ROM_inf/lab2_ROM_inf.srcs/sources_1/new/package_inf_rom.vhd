library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
package package_inf_rom is
constant data_length : natural := 8;
constant addr_length : natural := 3;
constant mem_size : natural := 2**addr_length;
subtype rom_word is std_logic_vector(data_length-1 downto 0);
type mem_type is array (mem_size-1 downto 0) of rom_word;
    constant mem : mem_type :=(
        0 => x"02",1 => x"03",2 => x"04",3 => x"05",
        4 => x"06",5 => x"07",6 => x"08",7 => x"09"
     );
end package package_inf_rom;
