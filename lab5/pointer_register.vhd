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
    signal s_data_out : std_logic_vector(2 downto 0) := (others -> '0'); 
    begin
        process (clk, reset)
            begin
                if reset = '1' then 
                    s_data_out <= "000";
                elsif rising_edge(clk) then 
                    if en = '1' then 
                        s_data_out <= s_data_out + '1'; 
                    end if ; 
                end if ; 
            end process ; 
            data_out <= s_data_out; 
    end beh; 