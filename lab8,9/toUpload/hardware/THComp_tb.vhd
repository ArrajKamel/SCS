library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_SIGNED.ALL;

entity tb_axi_threshold_comparator is
end tb_axi_threshold_comparator;

architecture Behavioral of tb_axi_threshold_comparator is

    signal aclk                  : std_logic := '0';

    signal s_axis_g_plus_tvalid  : std_logic := '0';
    signal s_axis_g_plus_tready  : std_logic;
    signal s_axis_g_plus_tdata   : std_logic_vector(31 downto 0) := (others => '0');

    signal s_axis_g_minus_tvalid : std_logic := '0';
    signal s_axis_g_minus_tready : std_logic;
    signal s_axis_g_minus_tdata  : std_logic_vector(31 downto 0) := (others => '0');

    signal threshold             : std_logic_vector(31 downto 0) := (others => '0');

    signal m_axis_anomaly_tvalid : std_logic;
    signal m_axis_anomaly_tready : std_logic := '0';
    signal anomaly_flag          : std_logic;

    -- Clock period constant
    constant CLK_PERIOD : time := 10 ns;

begin

    clk_process : process
    begin
        aclk <= '0';
        wait for CLK_PERIOD/2;
        aclk <= '1';
        wait for CLK_PERIOD/2;
    end process;

    uut: entity work.axi_threshold_comparator
        port map (
            aclk                  => aclk,
            s_axis_g_plus_tvalid  => s_axis_g_plus_tvalid,
            s_axis_g_plus_tready  => s_axis_g_plus_tready,
            s_axis_g_plus_tdata   => s_axis_g_plus_tdata,
            s_axis_g_minus_tvalid => s_axis_g_minus_tvalid,
            s_axis_g_minus_tready => s_axis_g_minus_tready,
            s_axis_g_minus_tdata  => s_axis_g_minus_tdata,
            threshold             => threshold,
            m_axis_anomaly_tvalid => m_axis_anomaly_tvalid,
            m_axis_anomaly_tready => m_axis_anomaly_tready,
            anomaly_flag          => anomaly_flag
        );

    stim_proc: process
    begin
        wait for 20 ns;

        -- g+ <= threshold -> No anomaly
        s_axis_g_plus_tdata <= x"00000010"; -- g+ = 16
        threshold <= x"00000020";           -- threshold = 32
        s_axis_g_plus_tvalid <= '1';
        m_axis_anomaly_tready <= '1';
        wait for CLK_PERIOD;

        s_axis_g_plus_tvalid <= '0';
        wait for 30 ns;

        -- g+ > threshold -> anomaly detected 
        s_axis_g_plus_tdata <= x"00000040"; -- g+ = 64
        threshold <= x"00000020";           -- threshold = 32
        s_axis_g_plus_tvalid <= '1';
        wait for CLK_PERIOD;

        s_axis_g_plus_tvalid <= '0';
        wait for 30 ns;

        -- g+ = threshold -> no anomaly
        s_axis_g_plus_tdata <= x"00000020"; -- g_plus = 32
        threshold <= x"00000020";           -- threshold = 32
        s_axis_g_plus_tvalid <= '1';
        wait for CLK_PERIOD;

        s_axis_g_plus_tvalid <= '0';
        wait for 30 ns;

        wait for 100 ns;
        assert false report "Simulation complete!" severity note;
        wait;
    end process;

end Behavioral;
