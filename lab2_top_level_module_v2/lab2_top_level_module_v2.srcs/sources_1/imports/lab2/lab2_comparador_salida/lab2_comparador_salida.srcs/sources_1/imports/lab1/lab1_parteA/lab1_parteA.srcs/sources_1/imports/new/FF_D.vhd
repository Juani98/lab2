----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 23.04.2022 20:18:54
-- Design Name: 
-- Module Name: FF_D - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity FF_D is
    Port ( d : in STD_LOGIC;
           q : out STD_LOGIC;
           r : in STD_LOGIC;
           clk : in STD_LOGIC);
end FF_D;

architecture Behavioral of FF_D is

    begin
    process (clk,r)
    --variables de process
        begin
        if (r='1') then
            q<='0';
        elsif (rising_edge(clk)) then
            q<=d;
        
        end if;
    end process;

end Behavioral;
