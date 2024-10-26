

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity dff is
port(
    clk : in std_logic;
    d : in std_logic; 
    q : out std_logic
);
end dff;

architecture Behavioral of dff is
begin

    dff : process (clk) 
        begin 
            if rising_edge(clk) then 
                q <= d ; 
            end if ; 
        end process; 

end Behavioral;
