library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_SIGNED.ALL;

entity max_tb is
end max_tb;

architecture Behavioral of max_tb is

    signal aclk               : std_logic := '0';
    signal s_axis_g_tvalid    : std_logic := '0';
    signal s_axis_g_tready    : std_logic;
    signal s_axis_g_tdata     : std_logic_vector(31 downto 0) := (others => '0');
    signal m_axis_max_tvalid  : std_logic;
    signal m_axis_max_tready  : std_logic := '0';
    signal m_axis_max_tdata   : std_logic_vector(31 downto 0);

    constant CLK_PERIOD : time := 10 ns;

begin

    clk_process : process
    begin
        aclk <= '0';
        wait for CLK_PERIOD/2;
        aclk <= '1';
        wait for CLK_PERIOD/2;
    end process;

    uut: entity work.maxOp
        port map (
            aclk               => aclk,
            s_axis_g_tvalid    => s_axis_g_tvalid,
            s_axis_g_tready    => s_axis_g_tready,
            s_axis_g_tdata     => s_axis_g_tdata,
            m_axis_max_tvalid  => m_axis_max_tvalid,
            m_axis_max_tready  => m_axis_max_tready,
            m_axis_max_tdata   => m_axis_max_tdata
        );

    stim_proc: process
    begin
        wait for 20 ns;

        s_axis_g_tdata <= x"00000010";  -- Decimal 16
        s_axis_g_tvalid <= '1';
        m_axis_max_tready <= '1';
        wait for CLK_PERIOD;

        s_axis_g_tvalid <= '0';
        wait for 30 ns;

        s_axis_g_tdata <= x"FFFFFFF0";  -- Decimal -16 (2's complement)
        s_axis_g_tvalid <= '1';
        wait for CLK_PERIOD;

        s_axis_g_tvalid <= '0';
        wait for 30 ns;

        s_axis_g_tdata <= x"00000000";  -- Decimal 0
        s_axis_g_tvalid <= '1';
        wait for CLK_PERIOD;

        s_axis_g_tvalid <= '0';
        wait for 30 ns;

        wait for 100 ns;
        assert false report "Simulation complete!" severity note;
        wait;
    end process;

end Behavioral;
