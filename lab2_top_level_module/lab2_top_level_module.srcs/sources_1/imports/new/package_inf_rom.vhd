library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
package package_inf_rom is
constant data_length : natural := 8;
constant addr_length : natural := 3;
constant mem_size : natural := 2**addr_length;
--8bits
subtype rom_word_8bits is std_logic_vector(data_length-1 downto 0);
type mem_type_8bits is array (mem_size-1 downto 0) of rom_word_8bits;

--9bits
--subtype rom_word_9bits is std_logic_vector(data_length downto 0);
--type mem_type_9bits is array (mem_size-1 downto 0) of rom_word_9bits;

    constant mem_A : mem_type_8bits :=(
        0 => x"02",1 => x"03",2 => x"04",3 => x"05",
        4 => x"06",5 => x"07",6 => x"08",7 => x"09"
     );
     
--     constant mem_C : mem_type_8bits :=(
--        0 => x"ab",1 => x"00",2 => x"55",3 => x"10",
--        4 => x"5a",5 => x"f0",6 => x"12",7 => x"ff"
--     );
     
--     constant mem_D : mem_type_9bits :=(
--        0 => "000000001",1 => "000000011",2 => "000000001",3 => "000000111",
--        4 => "000000111",5 => "000000011",6 => "000000001",7 => "000000111"

 --    );

end package package_inf_rom;
