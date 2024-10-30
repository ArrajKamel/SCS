--// Code your testbench here
--// or browse Examples
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity wallace_tree_multiplier_tb is
end wallace_tree_multiplier_tb;

architecture beh of wallace_tree_multiplier_tb is
    signal x_tb, y_tb : std_logic_vector(3 downto 0);
    signal p_tb       : std_logic_vector(7 downto 0);

    component wallace_tree_multiplier is
        port(
        x, y : in std_logic_vector(3 downto 0);
        p    : out std_logic_vector(7 downto 0)
    );
    end component;
    begin


    DUT: wallace_tree_multiplier port map(
        x => x_tb,
        y => y_tb,
        p => p_tb
    );

    stimulus_proc : process
    begin
        -- Test case 1: multiply 4 * 5 
        x_tb <= "0100";  -- 4 
        y_tb <= "0101";  -- 5 
        wait for 2 ns;

        -- Test case 2: multiply 1 * 1 
        x_tb <= "0001";  -- 1 
        y_tb <= "0001";  -- 1
        wait for 2 ns;

        -- Test case 3: multiply 15 * 15 
        x_tb <= "1111";  -- 15 
        y_tb <= "1111";  -- 15 
        wait for 2 ns;

        -- Test case 3: multiply 1 * 15 
        x_tb <= "0001";  -- 1
        y_tb <= "1111";  -- 15 
        wait for 2 ns;

        -- Test case 4: multiply 0 * 15 
        x_tb <= "0000";  -- 0 
        y_tb <= "1111";  -- 15
        wait for 2 ns;

        wait;
    end process;
end beh;
