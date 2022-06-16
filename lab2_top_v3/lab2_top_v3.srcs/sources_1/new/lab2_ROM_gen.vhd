library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity lab2_ROM_gen is
  PORT (
    clka : IN STD_LOGIC;
    addra : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
    douta : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
  );
end lab2_ROM_gen;

architecture Behavioral of lab2_ROM_gen is
COMPONENT blk_mem_gen_0_ROM_B
  PORT (
    clka : IN STD_LOGIC;
    addra : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
    douta : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
  );
END COMPONENT;
begin

ROM_B_GEN : blk_mem_gen_0_ROM_B
  PORT MAP (
    clka => clka,
    addra => addra,
    douta => douta
  );
end Behavioral;
