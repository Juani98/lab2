library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity lab2_ROM_gen is
    Port (
        clka : IN STD_LOGIC;
        addra : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        douta : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
    );
end lab2_ROM_gen;

architecture Behavioral of lab2_ROM_gen is
------------- Begin Cut here for COMPONENT Declaration ------ COMP_TAG
COMPONENT blk_memB_gen_0
  PORT (
    clka : IN STD_LOGIC;
    addra : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
    douta : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
  );
END COMPONENT;
-- COMP_TAG_END ------ End COMPONENT Declaration ------------

begin
------------- Begin Cut here for INSTANTIATION Template ----- INST_TAG
your_instance_name : blk_memB_gen_0
  PORT MAP (
    clka => clka,
    addra => addra,
    douta => douta
  );
-- INST_TAG_END ------ End INSTANTIATION Template ---------


end Behavioral;
