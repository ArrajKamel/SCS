library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity adder is 
    port(
        x, y, cin : in std_logic ; 
        sum       : out std_logic
    );
end entity; 

architecture beh of adder is  
    begin
        sum <= x xor y xor cin; 
    end beh; 