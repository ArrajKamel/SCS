library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_SIGNED.ALL;

entity subtractor is
    Port (
        aclk                : in  std_logic;

        s_axis_x1_tvalid    : in  std_logic;
        s_axis_x1_tready    : out std_logic;
        s_axis_x1_tdata     : in  std_logic_vector(31 downto 0);

        s_axis_x2_tvalid    : in  std_logic;
        s_axis_x2_tready    : out std_logic;
        s_axis_x2_tdata     : in  std_logic_vector(31 downto 0);

        m_axis_sum_tvalid  : out std_logic;
        m_axis_sum_tready  : in  std_logic;
        m_axis_sum_tdata   : out std_logic_vector(31 downto 0)
    );
end subtractor;


architecture Behavioral of saturator is

    type state_type is (S_READ, S_WRITE);
    signal state : state_type := S_READ;
    
    signal res_valid : STD_LOGIC := '0';
    signal result : STD_LOGIC_VECTOR (31 downto 0) := (others => '0');
    
    signal internal_ready, external_ready, inputs_valid : STD_LOGIC := '0';
    
    begin
        s_axis_x1_tready <= external_ready;
        s_axis_x2_tready <= external_ready;
        
        internal_ready <= '1' when state = S_READ else '0';
        inputs_valid <= s_axis_x1_tvalid and s_axis_x2_tvalid  
        external_ready <= internal_ready and inputs_valid;
        
        m_axis_sum_tvalid <= '1' when state = S_WRITE else '0';
        m_axis_sum_tdata <= result;
        
        process(aclk)
        begin
            if rising_edge(aclk) then
                case state is
                    when S_READ =>
                        if external_ready = '1' then
                            result <= s_axis_x1_tdata + s_axis_x2_tdata;
                            
                            state <= S_WRITE;
                        end if;    
                    
                    when S_WRITE =>
                        if m_axis_sum_tready = '1' then
                            state <= S_READ;
                        end if;
                end case;
            end if;
        end process;
    
    end Behavioral;