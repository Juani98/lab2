library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.package_inf_rom.all;
------------------------------------------------------------------
 -- Entity --
------------------------------------------------------------------
entity lab2_ROM_inf is
    port (
        clk :in std_logic;
        address :in std_logic_vector(addr_length-1 downto 0);
        data_out:out std_logic_vector(data_length-1 downto 0)
    );
end lab2_ROM_inf;
------------------------------------------------------------------
 -- Architecture --
------------------------------------------------------------------
architecture beh of lab2_ROM_inf is
begin
    rom : process (clk)
    begin
    if rising_edge(clk) then
        data_out <= mem(to_integer(unsigned(address)));
    end if;
    end process rom;
end architecture beh;
