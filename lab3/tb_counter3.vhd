library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_counter3 is
end tb_counter3;

architecture Tb of tb_counter3 is

component count3 is
    port (clk: in std_logic;
        count: out std_logic_vector (2 downto 0));
end component;

constant T : time := 10 ns;
signal clk : std_logic := '0';
signal count : std_logic_vector (2 downto 0) := (others => '0');

begin

    clk <= not clk  after T / 2;
    
    cnt3 : count3 port map (
        clk => clk,
        count => count
    );

end Tb;
