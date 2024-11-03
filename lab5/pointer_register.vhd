library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity pointer_register is 
    port(
        clk, en, reset : in std_logic; 
        data_out       : out std_logic_vector(2 downto 0)
    );
end entity; 

architecture beh of pointer_register is 
    begin
        process (clk, en, reset)
            begin
                if reset == '1' then 
                    data_out <= "0000000";
                end if; 
                if rising_edge(clk) then 
                    if en == '1' then 
                        data_out <= data_out + '1'; 
                    end if ; 
                end if ; 
            end process ; 
    end beh; 