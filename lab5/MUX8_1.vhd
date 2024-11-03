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
        with sel select 
        data_out <= 
             reg0 when  "000",
             reg1 when  "001",
             reg2 when  "010",
             reg3 when  "011",
             reg4 when  "100",
             reg5 when  "101",
             reg6 when  "110",
             reg7 when others;
    end beh; 
    

