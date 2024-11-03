library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity decoder3_8 is 
    port(
        data_in : in std_logic_vector(2 downto 0);
        data_out : out std_logic_vector(7 downto 0)
    );
end entity; 

architecture beh of decoder3_8 is 
    begin
        data_out <= "00000000" when data_in == "000";
                    "00000010" when data_in == "001";
                    "00000100" when data_in == "010";
                    "00001000" when data_in == "011";
                    "00010000" when data_in == "100";
                    "00100000" when data_in == "101";
                    "01000000" when data_in == "110";
                    "10000000" when others;
    end beh; 
