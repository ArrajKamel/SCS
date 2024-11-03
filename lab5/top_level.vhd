library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity top_level is 
    port(
        btn_rd, btn_wr : in std_logic; 
        clk, reset     : in std_logic; 
        data_in        : in std_logic_vector(7 downto 0);
        -- empty, full : out std_logic; 
        cat            : out std_logic_vector(7 downto 0);
        an             : out std_logic_vector(3 downto 0)
    );
end entity; 

architecture struct of top_level is 
    component debouncer is
        Port ( clk : in std_logic;
              btn : in std_logic;
              en : out std_logic );
      end component;

    component fifo_ctrl is 
        port (
            rd, wr : in std_logic; 
            clk, reset : in std_logic; 
            -- empty, full : out std_logic;
            rdinc, wrinc : out std_logic 
            
        );
    end component;

    component FIFO_memory is 
        port(
            rd, wr       : in std_logic; 
            rdinc, wrinc : in std_logic; 
            clk, reset   : in std_logic; 
            data_in      : in std_logic_vector(7 downto 0);
            data_out     : out std_logic_vector(7 downto 0)
        );
    end component;

    component display_7seg is
        Port ( digit0 : in std_logic_vector (3 downto 0);
               digit1 : in std_logic_vector (3 downto 0);
               digit2 : in std_logic_vector (3 downto 0);
               digit3 : in std_logic_vector (3 downto 0);
               clk : in STD_LOGIC;
               cat : out std_logic_vector (6 downto 0);
               an : out std_logic_vector (3 downto 0));
    end component;

    signal s_filters_out          : std_logic_vector(1 downto 0) := (others => '0');
    signal s_fifo_ctrl_out        : std_logic_vector(1 downto 0) := (others => '0');
    -- signal s_empty         : std_logic := '0';
    -- signal s_full          : std_logic := '0';
    signal s_fifo_memroy_data_out : std_logic_vector(7 downto 0) := (others => '0');

    begin
        filtr0 : debouncer port map(
            clk => clk, 
            btn => btn_rd, 
            en => s_filters_out(0)
        );

        filtr1 : debouncer port map(
            clk => clk, 
            btn => btn_wr, 
            en => s_filters_out(1)
        );

        CU : fifo_ctrl port map (
            -- empty => empty, 
            -- full => full,
            rd => s_filters_out(0),
            wr => s_filters_out(1),
            clk => clk , 
            reset => reset, 
            rdinc => s_fifo_ctrl_out(0),
            wrinc => s_fifo_ctrl_out(1)
        );

        FM : FIFO_memory port map (
            clk => clk, 
            reset => reset,
            rd => s_filters_out(0),
            wr => s_filters_out(1),
            rdinc => s_fifo_ctrl_out(0),
            wrinc => s_fifo_ctrl_out(1),
            data_in => data_in ,
            data_out => s_fifo_memroy_data_out
        );

        SSD : display_7seg port map (
            digit0 => data_in(7 downto 4),
            digit1 => data_in(3 downto 0),
            digit2 => s_fifo_memroy_data_out(7 downto 4),
            digit3 => s_fifo_memroy_data_out(3 downto 0),
            clk => clk, 
            cat => cat(6 downto 0), 
            an => an
        );

    end struct; 

        

      
    