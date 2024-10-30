library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity full_adder is 
    port(
        x, y, cin : in std_logic; 
        sum, cout : out std_logic
    );
end entity; 

architecture beh of full_adder is 
    begin
        sum <= x xor y xor cin ; 
        cout <= (x and y ) or ((x or y) and cin);
    end beh; 