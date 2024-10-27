library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity wallace_tree_multiplier is 
    port(
        x, y : in std_logic_vector(3 downto 0);
        p    : out std_logic_vector(7 downto 0)
    );
end entity; 

architecture struct of wallace_tree_multiplier is 
    signal s_bottom_level_carry_out : std_logic_vector(4 downto 0) := "00000";
    signal s_middle_level_carry_out : std_logic_vector(3 downto 0) := "0000";
    signal s_top_level_carry_out : std_logic_vector(1 downto 0) := "00";

    signal s_middle_level_sum : std_logic_vector(3 downto 0) := "0000";
    signal s_top_level_sum : std_logic_vector(1 downto 0) := "00";

    component full_adder is 
        port(
            x, y, cin : in std_logic; 
            sum, cout : out std_logic
        );
    end component;
    begin

        p(0) <= (x(0) and y(0));

        --mapping the full adders 
        FA_0 : full_adder 
                port map(
                    x    => (x(0) and y(1)),
                    y    => (x(1) and y(0)), 
                    cin  => '0',
                    sum  => p(1),
                    cout => s_bottom_level_carry_out(0)
                );

        FA_1 : full_adder 
                port map(
                    x    => (x(2) and y(0)),
                    y    => (x(1) and y(1)), 
                    cin  => '0',
                    sum  => s_middle_level_sum(0),
                    cout => s_middle_level_carry_out(0)
                );

        FA_2 : full_adder 
                port map(
                    x    => (x(3) and y(0)),
                    y    => (x(2) and y(1)), 
                    cin  => '0',
                    sum  => s_top_level_sum(0),
                    cout => s_top_level_carry_out(0)
                );

        FA_3 : full_adder 
                port map(
                    x    => s_middle_level_sum(0),
                    y    => (x(0) and y(2)), 
                    cin  => s_bottom_level_carry_out(0),
                    sum  => p(2),
                    cout => s_bottom_level_carry_out(1)
                );
        
        FA_4 : full_adder 
                port map(
                    x    => (x(0) and y(3)),
                    y    => s_top_level_sum(0), 
                    cin  => (x(1) and y(2)),
                    sum  => s_middle_level_sum(1),
                    cout => s_middle_level_carry_out(1)
                );


        FA_5 : full_adder 
                port map(
                    x    => (x(3) and y(1)),
                    y    => (x(2) and y(2)), 
                    cin  => '0',
                    sum  => s_top_level_sum(1),
                    cout => s_top_level_carry_out(1)
                );

        FA_6 : full_adder 
                port map(
                    x    => s_middle_level_sum(1),
                    y    => s_middle_level_carry_out(0), 
                    cin  => s_bottom_level_carry_out(1),
                    sum  => p(3),
                    cout => s_bottom_level_carry_out(2)
                );

        FA_7 : full_adder 
                port map(
                    x    => (x(1) and y(3)),
                    y    => s_top_level_sum(1), 
                    cin  => s_top_level_carry_out(0),
                    sum  => s_middle_level_sum(2),
                    cout => s_middle_level_carry_out(2)
                );

        FA_8 : full_adder 
                port map(
                    x    => s_middle_level_sum(2),
                    y    => s_middle_level_carry_out(1), 
                    cin  => s_bottom_level_carry_out(2),
                    sum  => p(4),
                    cout => s_bottom_level_carry_out(3)
                );

        FA_9 : full_adder 
                port map(
                    x    => (x(3) and y(2)),
                    y    => (x(2) and y(3)), 
                    cin  => s_top_level_carry_out(1),
                    sum  => s_middle_level_sum(3),
                    cout => s_middle_level_carry_out(3)
                );

        FA_10 : full_adder 
                port map(
                    x    => s_middle_level_sum(3),
                    y    => s_middle_level_carry_out(2), 
                    cin  => s_bottom_level_carry_out(3),
                    sum  => p(5),
                    cout => s_bottom_level_carry_out(4)
                );

        FA_11 : full_adder 
                port map(
                    x    => (x(3) and y(3)),
                    y    => s_middle_level_carry_out(3), 
                    cin  => s_bottom_level_carry_out(4),
                    sum  => p(6),
                    cout => p(7)
                );
    end struct; 

                

