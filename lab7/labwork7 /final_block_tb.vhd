library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tb_final_block is
end entity;

architecture Behavioral of tb_final_block is

    -- Component Under Test (CUT)
    component final_block is
        port(
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

            m_axis_sum_tvalid   : out std_logic;                              
            m_axis_sum_tready   : in  std_logic;                              
            m_axis_sum_tdata    : out std_logic_vector(31 downto 0)   
        );
    end component;

    -- Signals for CUT
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
    signal m_axis_sum_tvalid   : std_logic;
    signal m_axis_sum_tready   : std_logic := '1';
    signal m_axis_sum_tdata    : std_logic_vector(31 downto 0);

    -- Clock period
    constant CLK_PERIOD : time := 10 ns;

begin

    -- Instantiate the final_block
    UUT: final_block
        port map (
            aclk                => aclk,
            s_axis_val_tvalid   => s_axis_val_tvalid,
            s_axis_val_tready   => s_axis_val_tready,
            s_axis_val_tdata    => s_axis_val_tdata,
            s_axis_max_tvalid   => s_axis_max_tvalid,
            s_axis_max_tready   => s_axis_max_tready,
            s_axis_max_tdata    => s_axis_max_tdata,
            s_axis_min_tvalid   => s_axis_min_tvalid,
            s_axis_min_tready   => s_axis_min_tready,
            s_axis_min_tdata    => s_axis_min_tdata,
            m_axis_sum_tvalid   => m_axis_sum_tvalid,
            m_axis_sum_tready   => m_axis_sum_tready,
            m_axis_sum_tdata    => m_axis_sum_tdata
        );

    -- Clock generation process
    clk_process: process
    begin
        while true loop
            aclk <= '1';
            wait for CLK_PERIOD / 2;
            aclk <= '0';
            wait for CLK_PERIOD / 2;
        end loop;
    end process;

    -- Test process
    test_process: process
    begin
        -- Reset conditions
        s_axis_val_tvalid <= '0';
        s_axis_max_tvalid <= '0';
        s_axis_min_tvalid <= '0';
        wait for 20 ns;

        -- Provide max, min, and input values
        s_axis_max_tvalid <= '1';
        s_axis_max_tdata <= std_logic_vector(to_signed(100, 32));
        s_axis_min_tvalid <= '1';
        s_axis_min_tdata <= std_logic_vector(to_signed(-50, 32));
        wait for CLK_PERIOD;

        s_axis_val_tvalid <= '1';
        s_axis_val_tdata <= std_logic_vector(to_signed(120, 32));  -- Above max
        wait for CLK_PERIOD;
        s_axis_val_tdata <= std_logic_vector(to_signed(-60, 32)); -- Below min
        wait for CLK_PERIOD;
        s_axis_val_tdata <= std_logic_vector(to_signed(20, 32));  -- Within range
        wait for CLK_PERIOD;

        -- Stop providing new data
        s_axis_val_tvalid <= '0';
        wait for 50 ns;

        -- End simulation
        wait;
    end process;

end Behavioral;
