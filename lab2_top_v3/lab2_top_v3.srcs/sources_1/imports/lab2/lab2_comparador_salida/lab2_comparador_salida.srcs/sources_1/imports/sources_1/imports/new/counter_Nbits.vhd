
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;

entity counter_Nbits is
    generic(cnt_width: natural:= 29); --selección de la resolución del contador
    Port ( 
        rst : in STD_LOGIC;
        enable: in std_logic;
        data_in : in STD_LOGIC_VECTOR (cnt_width-1 downto 0);
        clk : in STD_LOGIC;
        up_down : in STD_LOGIC;
        load_data : in STD_LOGIC;
        data_out : out STD_LOGIC_VECTOR (cnt_width-1 downto 0);
        carry_out : out std_logic
        );
end counter_Nbits;

architecture Behavioral of counter_Nbits is
    constant full_count: std_logic_vector(cnt_width-1 downto 0) := (others =>'1');
    signal counter  : unsigned(cnt_width-1 downto 0);

begin

    process(clk,rst,enable,counter)
    begin
        if (rst='1') then --reset activo en alto
            counter <= (others => '0');
            carry_out <= '0';
        elsif (enable='1') then --si enable=0 cuenta normal, enable=1 retiene cuenta
            counter <= counter;
        
        elsif(rising_edge(clk)) then
            if(load_data='1') then --load data activo en alto
                counter <= unsigned(data_in);
            else
                if (up_down='1') then --cuenta ascendente en 1, descendente en 0
                    counter <= counter + 1;
                else
                    counter <= counter - 1;
                end if;
                if (counter=unsigned(full_count)) then -- si el contador desborda, activo carry out
                    carry_out <= '1';
                else
                    carry_out <= '0';
                end if;
            end if;
        end if;
    end process;

    data_out <= std_logic_vector(counter);
    
end Behavioral;
