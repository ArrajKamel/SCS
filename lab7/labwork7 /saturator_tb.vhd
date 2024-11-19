library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity saturator_tb is
end saturator_tb;

architecture Behavioral of saturator_tb is

    component saturator
        Port (
            aclk                : in  std_logic;
            s_axis_val_tvalid   : in  std_logic;
            s_axis_val_tready   : out std_logic;
            s_axis_val_tdata    : in  std_logic_vector(31 downto 0);
            s_axis_max_tvalid   : in  std_logic;
            s_axis_max_tready   : out std_logic;
            s_axis_max_tdata    : in  std_logic_vector(31 downto 0);
            s_axis_min_tvalid   : in  std_logic;
            s_axis_min_tready   : out std_logic;
            s_axis_min_tdata    : in  std_logic_vector(31 downto 0);
            m_axis_result_tvalid: out std_logic;
            m_axis_result_tready: in  std_logic;
            m_axis_result_tdata : out std_logic_vector(31 downto 0)
        );
    end component;

    signal aclk                : std_logic := '0';
    signal s_axis_val_tvalid   : std_logic := '0';
    signal s_axis_val_tready   : std_logic;
    signal s_axis_val_tdata    : std_logic_vector(31 downto 0) := (others => '0');
    signal s_axis_max_tvalid   : std_logic := '0';
    signal s_axis_max_tready   : std_logic;
    signal s_axis_max_tdata    : std_logic_vector(31 downto 0) := (others => '0');
    signal s_axis_min_tvalid   : std_logic := '0';
    signal s_axis_min_tready   : std_logic;
    signal s_axis_min_tdata    : std_logic_vector(31 downto 0) := (others => '0');
    signal m_axis_result_tvalid: std_logic;
    signal m_axis_result_tready: std_logic := '0';
    signal m_axis_result_tdata : std_logic_vector(31 downto 0);

    constant clk_period : time := 10 ns;

begin

    uut: saturator
        Port map (
            aclk => aclk,
            s_axis_val_tvalid => s_axis_val_tvalid,
            s_axis_val_tready => s_axis_val_tready,
            s_axis_val_tdata => s_axis_val_tdata,
            s_axis_max_tvalid => s_axis_max_tvalid,
            s_axis_max_tready => s_axis_max_tready,
            s_axis_max_tdata => s_axis_max_tdata,
            s_axis_min_tvalid => s_axis_min_tvalid,
            s_axis_min_tready => s_axis_min_tready,
            s_axis_min_tdata => s_axis_min_tdata,
            m_axis_result_tvalid => m_axis_result_tvalid,
            m_axis_result_tready => m_axis_result_tready,
            m_axis_result_tdata => m_axis_result_tdata
        );

    -- Clock generation process
    clk_process: process
    begin
        while True loop
            aclk <= '0';
            wait for clk_period / 2;
            aclk <= '1';
            wait for clk_period / 2;
        end loop;
    end process;

    stimulus: process
    begin
        s_axis_val_tvalid <= '0';
        s_axis_max_tvalid <= '0';
        s_axis_min_tvalid <= '0';
        m_axis_result_tready <= '0';
        wait for 20 ns;

        -- Case 1: val > max
        s_axis_val_tdata <= x"00000064"; -- 100
        s_axis_max_tdata <= x"00000032"; -- 50
        s_axis_min_tdata <= x"00000014"; -- 20
        s_axis_val_tvalid <= '1';
        s_axis_max_tvalid <= '1';
        s_axis_min_tvalid <= '1';
        m_axis_result_tready <= '1';
        wait for clk_period;
        
        assert m_axis_result_tdata = x"00000032" report "Test failed: val > max" severity error;

        -- Case 2: val < min
        s_axis_val_tdata <= x"0000000A"; -- 10
        s_axis_max_tdata <= x"00000032"; -- 50
        s_axis_min_tdata <= x"00000014"; -- 20
        wait for clk_period;

        assert m_axis_result_tdata = x"00000014" report "Test failed: val < min" severity error;

        -- Case 3: min <= val <= max
        s_axis_val_tdata <= x"00000028"; -- 40
        s_axis_max_tdata <= x"00000032"; -- 50
        s_axis_min_tdata <= x"00000014"; -- 20
        wait for clk_period;

        assert m_axis_result_tdata = x"00000028" report "Test failed: min <= val <= max" severity error;

        -- Finish simulation
        wait for 20 ns;
        report "Simulation completed successfully" severity note;
        wait;
    end process;

end Behavioral;
