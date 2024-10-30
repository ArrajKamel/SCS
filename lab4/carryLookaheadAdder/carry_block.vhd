library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity carry_block is 
    port(
        cin : in std_logic; 
        x, y: in std_logic_vector(3 downto 0); 
        cout : out std_logic_vector(3 downto 0)
    );
end entity ; 

architecture beh of carry_block is 
        signal P0, P1, P2, P3 : std_logic;
        signal G0, G1, G2, G3 : std_logic;
    begin
        P0 <= x(0) or y(0);
        G0 <= x(0) and y(0);
        P1 <= x(1) or y(1);
        G1 <= x(1) and y(1);
        P2 <= x(2) or y(2);
        G2 <= x(2) and y(2);
        P3 <= x(3) or y(3);
        G3 <= x(3) and y(3);
        
        --//need to modify, this is correct for the four bit adder but it is not carry lookahead adder :)
        -- cout(0) <= G0 or (P0 and cin);
        -- cout(1) <= G1 or (P1 and cout(0));
        -- cout(2) <= G2 or (P2 and cout(1));
        -- cout(3) <= G3 or (P3 and cout(2));

        cout(0) <= G0 or (P0 and cin);
        cout(1) <= G1 or (P1 and (G0 or (P0 and cin)));
        cout(2) <= G2 or (P2 and (G1 or (P1 and (G0 or (P0 and cin)))));
        cout(3) <= G3 or (P3 and (G2 or (P2 and (G1 or (P1 and (G0 or (P0 and cin)))))));

    end beh; 
