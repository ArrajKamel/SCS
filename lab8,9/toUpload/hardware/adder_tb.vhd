library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_SIGNED.ALL;

entity adder_tb is
end adder_tb;

architecture beh of adder_tb is

    signal aclk               : std_logic := '0';
    signal s_axis_x1_tvalid   : std_logic := '0';
    signal s_axis_x1_tready   : std_logic;
    signal s_axis_x1_tdata    : std_logic_vector(31 downto 0) := (others => '0');
    signal s_axis_x2_tvalid   : std_logic := '0';
    signal s_axis_x2_tready   : std_logic;
    signal s_axis_x2_tdata    : std_logic_vector(31 downto 0) := (others => '0');
    signal m_axis_sum_tvalid  : std_logic;
    signal m_axis_sum_tready  : std_logic := '0';
    signal m_axis_sum_tdata   : std_logic_vector(31 downto 0);

    constant CLK_PERIOD : time := 10 ns;

begin

    clk_process : process
    begin
        aclk <= '0';
        wait for CLK_PERIOD/2;
        aclk <= '1';
        wait for CLK_PERIOD/2;
    end process;

    uut: entity work.subtractor
        port map (
            aclk               => aclk,
            s_axis_x1_tvalid   => s_axis_x1_tvalid,
            s_axis_x1_tready   => s_axis_x1_tready,
            s_axis_x1_tdata    => s_axis_x1_tdata,
            s_axis_x2_tvalid   => s_axis_x2_tvalid,
            s_axis_x2_tready   => s_axis_x2_tready,
            s_axis_x2_tdata    => s_axis_x2_tdata,
            m_axis_sum_tvalid => m_axis_sum_tvalid,
            m_axis_sum_tready => m_axis_sum_tready,
            m_axis_sum_tdata  => m_axis_sum_tdata
        );

    stim_proc: process
    begin
        wait for 20 ns;

        s_axis_x1_tdata <= x"00000005";  -- 5
        s_axis_x2_tdata <= x"00000003";  -- 3
        s_axis_x1_tvalid <= '1';
        s_axis_x2_tvalid <= '1';
        m_axis_sum_tready <= '1';
        wait for CLK_PERIOD;

        s_axis_x1_tvalid <= '0';
        s_axis_x2_tvalid <= '0';
        wait for 30 ns;

        s_axis_x1_tdata <= x"00000001";  -- 1
        s_axis_x2_tdata <= x"00000010";  -- 16
        s_axis_x1_tvalid <= '1';
        s_axis_x2_tvalid <= '1';
        wait for CLK_PERIOD;

        s_axis_x1_tvalid <= '0';
        s_axis_x2_tvalid <= '0';
        wait for 30 ns;

        wait for 100 ns;
        assert false report "Simulation complete!" severity note;
        wait;
    end process;

end beh;
