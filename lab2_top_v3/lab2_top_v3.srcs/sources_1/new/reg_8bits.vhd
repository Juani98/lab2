library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity reg_8bits is
    Port ( d : in STD_LOGIC_VECTOR(7 downto 0);
           q : out STD_LOGIC_VECTOR(7 downto 0);
           r : in STD_LOGIC;
           clk : in STD_LOGIC);
end reg_8bits;

architecture Behavioral of reg_8bits is

begin
    process (clk,r)
    --variables de process
        begin
        if (r='1') then
            q<=(others=>'0');
        elsif (rising_edge(clk)) then
            q<=d;
        end if;
    end process;

end Behavioral;
