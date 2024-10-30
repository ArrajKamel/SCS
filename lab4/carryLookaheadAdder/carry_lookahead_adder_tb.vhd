--// Code your testbench here
--// or browse Examples
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity carry_lookahead_adder_tb is
end carry_lookahead_adder_tb;

architecture behavior of carry_lookahead_adder_tb is
    signal x_tb, y_tb : std_logic_vector(3 downto 0);
    signal cin_tb     : std_logic;
    signal sum_tb     : std_logic_vector(3 downto 0);
    signal cout_tb    : std_logic;

    component carry_lookahead_adder is
        port(
            x, y : in std_logic_vector(3 downto 0);
            cin  : in std_logic;
            sum  : out std_logic_vector(3 downto 0);
            cout : out std_logic
        );
    end component;

    begin

    DUT: carry_lookahead_adder port map(
        x => x_tb,
        y => y_tb,
        cin => cin_tb,
        sum => sum_tb,
        cout => cout_tb
    );

    stimulus_proc : process
    begin
        -- Test case 1: Add 4 + 5 without carry
        x_tb <= "0100";  -- 4 
        y_tb <= "0101";  -- 5 
        cin_tb <= '0';
        wait for 2 ns;

        -- Test case 2: Add 7 + 3 with carry
        x_tb <= "0111";  -- 7 
        y_tb <= "0011";  -- 3 
        cin_tb <= '1';
        wait for 2 ns;

        -- Test case 3: Add 15 + 15 without carry
        x_tb <= "1111";  -- 15 
        y_tb <= "1111";  -- 15 
        cin_tb <= '0';
        wait for 2 ns;

        -- Test case 3: Add 15 + 15 with carry
        x_tb <= "1111";  -- 15 
        y_tb <= "1111";  -- 15 
        cin_tb <= '1';
        wait for 2 ns;

        -- Test case 4: Add 0 + 0 with carry
        x_tb <= "0000";  -- 0 
        y_tb <= "0000";  -- 0 
        cin_tb <= '1';
        wait for 2 ns;

        wait;
    end process;
end behavior;
