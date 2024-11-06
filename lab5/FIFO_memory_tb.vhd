library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity FIFO_memory_tb is
end entity;

architecture behavior of FIFO_memory_tb is
    -- Component declaration for the FIFO_memory entity
    component FIFO_memory
        port(
            rd, wr       : in std_logic; 
            rdinc, wrinc : in std_logic; 
            clk, reset   : in std_logic; 
            data_in      : in std_logic_vector(7 downto 0);
            data_out     : out std_logic_vector(7 downto 0)
        );
    end component;

    -- Signals for the test bench to drive FIFO_memory inputs and capture outputs
    signal rd, wr       : std_logic := '0';
    signal rdinc, wrinc : std_logic := '0';
    signal clk, reset   : std_logic := '0';
    signal data_in      : std_logic_vector(7 downto 0) := (others => '0');
    signal data_out     : std_logic_vector(7 downto 0);

    -- Clock period definition
    constant clk_period : time := 10 ns;

begin
    -- Instantiate the FIFO_memory component
    uut: FIFO_memory
        port map (
            rd      => rd,
            wr      => wr,
            rdinc   => rdinc,
            wrinc   => wrinc,
            clk     => clk,
            reset   => reset,
            data_in => data_in,
            data_out => data_out
        );

    -- Clock process to generate clock signal
    clk_process : process
    begin
        clk <= '0';
        wait for clk_period/2;
        clk <= '1';
        wait for clk_period/2;
    end process;

    -- Test process to apply stimulus to the FIFO memory
    stim_proc: process
    begin
        -- Reset the FIFO
        reset <= '1';
        wait for clk_period * 2;
        reset <= '0';

        -- Write some data to FIFO
        wr <= '1';
        wrinc <= '1';
        
        data_in <= x"01";
        wait for clk_period;

        wrinc <= '1';
        data_in <= x"02";
        wait for clk_period;

        wrinc <= '1';
        data_in <= x"03";
        wait for clk_period;

        wrinc <= '0';  -- Disable write increment

        -- Wait a little before reading
        wr <= '0';
        wait for clk_period * 2;

        -- Read data from FIFO
        rd <= '1';
        rdinc <= '1';
        wait for clk_period;

        rdinc <= '1';
        wait for clk_period;

        rdinc <= '0';  -- Disable read increment

        -- End of test
        wait;
    end process;

end architecture;
