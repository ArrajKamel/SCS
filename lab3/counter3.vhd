library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity count3 is
    port (clk: in std_logic;
        count: out std_logic_vector (2 downto 0));
end count3;

architecture Behavioral of count3 is
    signal tmp : std_logic_vector (2 downto 0) := (others => '0');
begin
    cnt: process (clk)
    begin
        if (clk'event and clk = '1') then
            tmp <= tmp + 1;
        end if;
    end process cnt;
    
    count <= tmp;
end Behavioral;