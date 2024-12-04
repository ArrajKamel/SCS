library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity sliding_window_adder is
    Generic (
        WINDOW_SIZE : integer := 5 
    );
    Port (
        aclk                : in  std_logic;           
        s_axis_val_tvalid   : in  std_logic;                               
        s_axis_val_tready   : out std_logic;                          
        s_axis_val_tdata    : in  std_logic_vector(31 downto 0);     
        m_axis_sum_tvalid   : out std_logic;                              
        m_axis_sum_tready   : in  std_logic;                              
        m_axis_sum_tdata    : out std_logic_vector(31 downto 0)            
    );
end sliding_window_adder;

architecture Behavioral of sliding_window_adder is

    type window_type is array (0 to WINDOW_SIZE - 1) of signed(31 downto 0);
    signal window        : window_type := (others => (others => '0')); 
    signal ptr           : integer range 0 to WINDOW_SIZE - 1 := 0;     
    signal sum           : std_logic_vector(31 downto 0) := (others => '0');    
    signal new_val       : signed(31 downto 0) := (others => '0');
    signal ready         : std_logic := '1';

    type state_type is (S_READ, S_WRITE);
    signal state : state_type := S_READ;

begin
    -- the Handshake signals
    s_axis_val_tready <= ready;
    m_axis_sum_tvalid <= '0';

    process(aclk)
    begin
        if rising_edge(aclk) then
            case state is

                when S_READ =>
                    if s_axis_val_tvalid = '1' and ready = '1' then
                        new_val <= signed(s_axis_val_tdata);

                        sum <= sum + signed(s_axis_val_tdata) - window(ptr);
                        window(ptr) <= signed(s_axis_val_tdata);

                        if ptr < WINDOW_SIZE - 1 then
                            ptr <= ptr + 1;
                        else
                            ptr <= 0;
                        end if;

                        state <= S_WRITE;
                        ready <= '0';  
                    end if;

                when S_WRITE =>
                    m_axis_sum_tvalid <= '1';

                    if m_axis_sum_tready = '1' then
                        m_axis_sum_tdata <= std_logic_vector(sum);

                        m_axis_sum_tvalid <= '0'; 
                        state <= S_READ;
                        ready <= '1'; 
                    end if;

            end case;
        end if;
    end process;

end Behavioral;
