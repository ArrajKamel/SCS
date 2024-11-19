library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity SWA_tb is
end SWA_tb;

architecture Behavioral of SWA_tb is

    component sliding_window_adder
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
    end component;

    signal aclk                : std_logic := '0';
    signal s_axis_val_tvalid   : std_logic := '0';
    signal s_axis_val_tready   : std_logic;
    signal s_axis_val_tdata    : std_logic_vector(31 downto 0) := (others => '0');
    signal m_axis_sum_tvalid   : std_logic;
    signal m_axis_sum_tready   : std_logic := '0';
    signal m_axis_sum_tdata    : std_logic_vector(31 downto 0);

    constant clk_period : time := 10 ns;

begin

    uut: sliding_window_adder
        Generic map (
            WINDOW_SIZE => 5
        )
        Port map (
            aclk => aclk,
            s_axis_val_tvalid => s_axis_val_tvalid,
            s_axis_val_tready => s_axis_val_tready,
            s_axis_val_tdata => s_axis_val_tdata,
            m_axis_sum_tvalid => m_axis_sum_tvalid,
            m_axis_sum_tready => m_axis_sum_tready,
            m_axis_sum_tdata => m_axis_sum_tdata
        );

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
        variable input_values : array(0 to 9) of signed(31 downto 0) := 
            (to_signed(10, 32), to_signed(20, 32), to_signed(30, 32), 
             to_signed(40, 32), to_signed(50, 32), to_signed(60, 32), 
             to_signed(70, 32), to_signed(80, 32), to_signed(90, 32), 
             to_signed(100, 32));
        variable expected_sums : array(0 to 9) of signed(31 downto 0) := 
             (to_signed(10, 32), to_signed(30, 32), to_signed(60, 32), 
              to_signed(100, 32), to_signed(150, 32), to_signed(200, 32), 
              to_signed(250, 32), to_signed(300, 32), to_signed(350, 32), 
              to_signed(400, 32));
        variable index : integer := 0;
     begin
         s_axis_val_tvalid <= '0';
         m_axis_sum_tready <= '0';
         wait for 20 ns;
 
         for index in 0 to 9 loop
             wait until s_axis_val_tready = '1';
             s_axis_val_tdata <= std_logic_vector(input_values(index));
             s_axis_val_tvalid <= '1';
             wait for clk_period;
             s_axis_val_tvalid <= '0';
 
             wait until m_axis_sum_tvalid = '1';
             m_axis_sum_tready <= '1';
             wait for clk_period;
 
             assert signed(m_axis_sum_tdata) = expected_sums(index) 
                 report "Test failed at index " & integer'image(index) severity error;
 
             m_axis_sum_tready <= '0';
         end loop;
 
         report "Simulation completed successfully" severity note;
         wait;
     end process;
 
 end Behavioral;