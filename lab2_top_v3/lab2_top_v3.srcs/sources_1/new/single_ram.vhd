-- -------------------------------------------------------------------- --
-- Library Declarations
-- -------------------------------------------------------------------- --
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
-- --------------------------------------------------------------------- -- 
-- Entity Declaration 
-- --------------------------------------------------------------------- -- 
entity single_ram is

	generic 
	(
		DATA_WIDTH : natural := 8;
		ADDR_WIDTH : natural := 3
	);

	port 
	(
        -- Port A --
		clk	: in std_logic;
        addr	: in std_logic_vector(ADDR_WIDTH - 1 downto 0);
		we	: in std_logic;
        en	: in std_logic;
		data	: in std_logic_vector((DATA_WIDTH-1) downto 0);
		q		: out std_logic_vector((DATA_WIDTH -1) downto 0)

	);
end single_ram;

-- --------------------------------------------------------------------- -- 
-- Architecture Declaration 
-- --------------------------------------------------------------------- -- 

architecture rtl of single_ram is

	-- Type declaration for building a 2-D array type for the RAM
	subtype word_t is std_logic_vector((DATA_WIDTH-1) downto 0);
	type memory_t is array(2**ADDR_WIDTH-1 downto 0) of word_t;
	-- Declare the RAM 
	signal bram: memory_t;


-- --------------------------------------------------------------------- -- 
-- Memory functionality description
-- --------------------------------------------------------------------- --
begin
-- Port A
porta_pr: process(clk)
  begin
	if(rising_edge(clk)) then 
        if(en = '1') then 
		    if(we = '1') then
                bram(to_integer(unsigned(addr))) <= data;
                q <= data;
		    end if;
			    q <= bram(to_integer(unsigned(addr)));
        end if;
	end if;
  end process porta_pr;

end rtl;
-- --------------------------------------------------------------------- -- 
-- 
-- --------------------------------------------------------------------- --