

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity reg is
Port (
    clk : in std_logic; 
    we : in std_logic ; 
    data_in : in std_logic_vector(7 downto 0); 
    data_out : out std_logic_vector(7 downto 0)
 );
end reg;

architecture Behavioral of reg is

begin
    reg : process(clk)
        begin 
            if rising_edge(clk) then
                if we = 1 then 
                    data_out <= data_in; 
                else 
                    data_out <= data_out; 
                end if ; 
            end if ; 
        end process ; 


end Behavioral;
