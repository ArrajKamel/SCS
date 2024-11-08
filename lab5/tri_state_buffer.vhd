library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity tri_state_buffer is
    Port (
        data_in  : in  STD_LOGIC_VECTOR(7 downto 0); 
        enable   : in  STD_LOGIC;                     
        data_out : out STD_LOGIC_VECTOR(7 downto 0)  
    );
end tri_state_buffer;

architecture Behavioral of tri_state_buffer is
begin
    process(data_in, enable)
    begin
        if enable = '1' then
            data_out <= data_in; 
        else
            data_out <= (others => 'Z');  
        end if;
    end process;
end Behavioral;