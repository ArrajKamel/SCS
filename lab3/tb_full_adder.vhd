library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_full_adder is
end tb_full_adder;

architecture Tb of tb_full_adder is

component full_adder is
port (a, b, cin: in std_logic;
        s, cout: out std_logic);
end component;

constant T : time := 10 ns;
signal a, b, cin, s, cout : std_logic := '0';

begin
    
    cin <= not cin after T;
    a <= not a after 2 * T;
    b <= not b after 4 * T;
    
    adder : full_adder port map (
        a => a,
        b => b,
        cin => cin,
        s => s,
        cout => cout
    );

end Tb;
