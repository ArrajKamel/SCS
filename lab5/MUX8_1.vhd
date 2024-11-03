library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity MUX8_1 is 
    port(
        reg0 : in std_logic_vector(7 downto 0);
        reg1 : in std_logic_vector(7 downto 0);
        reg2 : in std_logic_vector(7 downto 0);
        reg3 : in std_logic_vector(7 downto 0);
        reg4 : in std_logic_vector(7 downto 0);
        reg5 : in std_logic_vector(7 downto 0);
        reg6 : in std_logic_vector(7 downto 0);
        reg7 : in std_logic_vector(7 downto 0);
        sel  : in std_logic_vector(2 downto 0);
        data_out : out std_logic_vector(7 downto 0)
    );
end entity; 

architecture beh of MUX8_1 is 
    begin
        data_out <= reg0 when sel == "000";
        data_out <= reg1 when sel == "001";
        data_out <= reg2 when sel == "010";
        data_out <= reg3 when sel == "011";
        data_out <= reg4 when sel == "100";
        data_out <= reg5 when sel == "101";
        data_out <= reg6 when sel == "110";
        data_out <= reg7 when others;
    end beh; 
    

