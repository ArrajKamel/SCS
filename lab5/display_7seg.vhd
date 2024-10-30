library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity display_7seg is
    Port ( digit0 : in std_logic_vector (3 downto 0);
           digit1 : in std_logic_vector (3 downto 0);
           digit2 : in std_logic_vector (3 downto 0);
           digit3 : in std_logic_vector (3 downto 0);
           clk : in STD_LOGIC;
           cat : out std_logic_vector (6 downto 0);
           an : out std_logic_vector (3 downto 0));
end display_7seg;

architecture Behavioral of display_7seg is

signal cnt : std_logic_vector (15 downto 0) := (others => '0');
signal digit_to_display : std_logic_vector (3 downto 0) := (others => '0');

begin

    process (clk)
    begin
        if rising_edge(clk) then
            cnt <= cnt + 1;
        end if;
    end process;
    
    digit_to_display <= digit0 when cnt(15 downto 14) = "00" else
                        digit1 when cnt(15 downto 14) = "01" else
                        digit2 when cnt(15 downto 14) = "10" else
                        digit3;
    
    an <= "1110" when cnt(15 downto 14) = "00" else
          "1101" when cnt(15 downto 14) = "01" else
          "1011" when cnt(15 downto 14) = "10" else
          "0111";
    
    -- HEX-to-seven-segment decoder
          --   HEX:   in    std_logic_vector (3 downto 0);
          --   LED:   out   std_logic_vector (6 downto 0);
          --
          -- segment encoinputg
          --      0
          --     ---
          --  5 |   | 1
          --     ---   <- 6
          --  4 |   | 2
          --     ---
          --      3
          
    with digit_to_display select
         cat <= "1111001" when "0001",   --1
                "0100100" when "0010",   --2
                "0110000" when "0011",   --3
                "0011001" when "0100",   --4
                "0010010" when "0101",   --5
                "0000010" when "0110",   --6
                "1111000" when "0111",   --7
                "0000000" when "1000",   --8
                "0010000" when "1001",   --9
                "0001000" when "1010",   --A
                "0000011" when "1011",   --b
                "1000110" when "1100",   --C
                "0100001" when "1101",   --d
                "0000110" when "1110",   --E
                "0001110" when "1111",   --F
                "1000000" when others;   --0

end Behavioral;
