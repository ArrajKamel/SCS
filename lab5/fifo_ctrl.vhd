library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity fifo_ctrl is 
    port (
        rd, wr : in std_logic; 
        clk, reset : in std_logic; 
        -- empty, full : out std_logic;
        rdinc, wrinc : out std_logic 
        
    );
end entity;

architecture beh of fifo_ctrl is 
    begin
        process (clk, reset)
            begin
                if reset = '1' then 
                    rdinc <= '0'; 
                    wrinc <= '0';
                end if; 
                if rising_edge(clk) then 
                    rdinc <= rd; 
                    wrinc <= wr;
                end if ; 
            end process; 
    end beh; 



