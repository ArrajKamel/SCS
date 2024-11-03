library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity carry_lookahead_adder is 
    port(
        x, y : in std_logic_vector(3 downto 0);
        cin  : in std_logic;
        sum  : out std_logic_vector(3 downto 0);
        cout : out std_logic 
    );
end entity; 

architecture struct of carry_lookahead_adder is 
    signal s_internal_carries : std_logic_vector(3 downto 0);


--////////////////////////////////////////////////////////////////////////////////////////////
    component adder is                                         --///////             
        port(                                                   --///////
            x, y, cin: in std_logic ;                           --///////
            sum : out std_logic                                 --///////                  
        );                                                      --///////
    end component;                                              --///////
                                                                --///////COMPONENT 
    component carry_block is                                    --///////DECLARATION
        port(                                                   --///////
            cin : in std_logic;                                 --///////
            x, y: in std_logic_vector(3 downto 0);              --///////
            cout : out std_logic_vector(3 downto 0)             --///////
        );                                                      --///////
    end component;                                              --///////
--////////////////////////////////////////////////////////////////////////////////////////////

    begin

        CB : carry_block port map (cin , x, y ,s_internal_carries);
        adder0 : adder port map (x(0) , y(0), cin, sum(0));
        adder1 : adder port map (x(1) , y(1), s_internal_carries(0), sum(1));
        adder2 : adder port map (x(2) , y(2), s_internal_carries(1), sum(2));
        adder3 : adder port map (x(3) , y(3), s_internal_carries(2), sum(3));
        cout <= s_internal_carries(3);

    end struct ; 
