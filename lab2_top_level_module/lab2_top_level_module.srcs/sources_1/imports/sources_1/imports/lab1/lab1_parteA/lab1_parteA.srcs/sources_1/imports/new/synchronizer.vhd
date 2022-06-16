library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity synchronizer is
    Port ( reset : in STD_LOGIC;
           clock : in STD_LOGIC;
           async_input : in STD_LOGIC;
           sync_output : out STD_LOGIC);
end synchronizer;

architecture Behavioral of synchronizer is
    --components
    component FF_D is
        Port ( r : in STD_LOGIC;
               clk : in STD_LOGIC;
               d : in STD_LOGIC;
               q : out STD_LOGIC);
    end component;
    
    --internal signals declarations
    signal internal_q1 : std_logic;
begin
    --first component FFD1
    FF_D1: FF_D port map(
        r => reset,
        clk => clock,
        d => async_input,
        q => internal_q1
    );
    --second component FFD2
    FF_D2: FF_D port map(
        r => reset,
        clk => clock,
        d => internal_q1,
        q => sync_output
    );

end Behavioral;
