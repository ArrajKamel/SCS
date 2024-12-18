library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_SIGNED.ALL;

entity THComp is
    Port (
        aclk                      : in  std_logic;

        s_axis_g_plus_tvalid      : in  std_logic;
        s_axis_g_plus_tready      : out std_logic;
        s_axis_g_plus_tdata       : in  std_logic_vector(31 downto 0); 

        s_axis_g_minus_tvalid     : in  std_logic;
        s_axis_g_minus_tready     : out std_logic;
        s_axis_g_minus_tdata      : in  std_logic_vector(31 downto 0);

        threshold                 : in  std_logic_vector(31 downto 0);
        
        m_axis_anomaly_tvalid     : out std_logic;
        m_axis_anomaly_tready     : in  std_logic;

        anomaly_flag              : out std_logic
    );
end THComp;

architecture beh of THComp is

type state_type is (S_READ, S_WRITE);
signal state : state_type := S_READ;

signal anomaly : std_logic := '0';
signal internal_ready, external_ready : std_logic := '0';

begin
    s_axis_g_tready <= internal_ready;
    s_axis_g_tready <= internal_ready;
    external_ready <= internal_ready and s_axis_g_tvalid;

    m_axis_anomaly_tvalid <= '1' when state = S_WRITE else '0';
    anomaly_flag <= anomaly;

    process(aclk)
    begin
        if rising_edge(aclk) then
            case state is
                when S_READ =>
                    if external_ready = '1' then
                        if signed(s_axis_g_tdata) > signed(threshold) then
                            anomaly <= '1';
                        else
                            anomaly <= '0';
                        end if;
                        state <= S_WRITE;
                    end if;

                when S_WRITE =>
                    if m_axis_anomaly_tready = '1' then
                        state <= S_READ;
                    end if;
            end case;
        end if;
    end process;

end beh;
