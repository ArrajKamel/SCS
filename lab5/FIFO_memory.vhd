library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;


entity FIFO_memory is 
    port(
        rd, wr       : in std_logic; 
        rdinc, wrinc : in std_logic; 
        clk, reset   : in std_logic; 
        data_in      : in std_logic_vector(7 downto 0);
        data_out     : out std_logic_vector(7 downto 0)
    );
end entity; 

architecture struct of FIFO_memory is 
    component pointer_register is 
        port(
            clk, en, reset : in std_logic; 
            data_out       : out std_logic_vector(2 downto 0)
        );
    end component; 

    component decoder3_8 is 
        port(
            data_in : in std_logic_vector(2 downto 0);
            data_out : out std_logic_vector(7 downto 0)
        );
    end component; 

    component reg is 
        port(
            clk, en, reset : in std_logic; 
            data_in        : in std_logic_vector(7 downto 0); 
            data_out       : out std_logic_vector(7 downto 0)
        );
    end component;

    component MUX8_1 is 
        port(
            reg0 : in std_logic_vector(7 downto 0);
            reg1 : in std_logic_vector(7 downto 0);
            reg2 : in std_logic_vector(7 downto 0);
            reg3 : in std_logic_vector(7 downto 0);
            reg4 : in std_logic_vector(7 downto 0);
            reg5 : in std_logic_vector(7 downto 0);
            reg6 : in std_logic_vector(7 downto 0);
            reg7 : in std_logic_vector(7 downto 0);
            sel  : in std_logic_vector(2 downto 0);
            data_out : out std_logic_vector(7 downto 0)
        );
    end component;

    component tri_state_buffer is
        Port (
            data_in  : in  STD_LOGIC_VECTOR(7 downto 0); 
            enable   : in  STD_LOGIC;                     
            data_out : out STD_LOGIC_VECTOR(7 downto 0)  
        );
    end component;

    signal s_wrptr, s_rdptr : std_logic_vector(2 downto 0) := (others => '0');
    signal s_decoder_out    : std_logic_vector(7 downto 0) := (others => '0');
    type t_reg_array is array (0 to 7) of std_logic_vector(7 downto 0);

    signal s_mux_in : t_reg_array := (
      x"00",
      others => (others => '0')
    );

    signal s_mux_out : std_logic_vector(7 downto 0) := (others => '0');

    begin 

        writepointer : pointer_register port map(
            clk      => clk, 
            en       => wrinc, 
            reset    => reset, 
            data_out =>s_wrptr
        );

        read_pointer : pointer_register port map(
            clk      => clk, 
            en       => rdinc, 
            reset    => reset, 
            data_out =>s_rdptr
        );
                    

        decoder : decoder3_8 port map (
            data_in => s_wrptr, 
            data_out => s_decoder_out 
        );

        fifo_0 : reg port map(
            clk => clk, 
            en => s_decoder_out(0) and wr,
            reset => reset, 
            data_in => data_in, 
            data_out => s_mux_in(0)
        );
        
        fifo_1 : reg port map(
            clk => clk, 
            en => s_decoder_out(1) and wr,
            reset => reset, 
            data_in => data_in, 
            data_out => s_mux_in(1)
        );

        fifo_2 : reg port map(
            clk => clk, 
            en => s_decoder_out(2) and wr,
            reset => reset, 
            data_in => data_in, 
            data_out => s_mux_in(2)
        );

        fifo_3 : reg port map(
            clk => clk, 
            en => s_decoder_out(3) and wr,
            reset => reset, 
            data_in => data_in, 
            data_out => s_mux_in(3)
        );

        fifo_4 : reg port map(
            clk => clk, 
            en => s_decoder_out(4) and wr,
            reset => reset, 
            data_in => data_in, 
            data_out => s_mux_in(4)
        );

        fifo_5 : reg port map(
            clk => clk, 
            en => s_decoder_out(5) and wr,
            reset => reset, 
            data_in => data_in, 
            data_out => s_mux_in(5)
        );

        fifo_6 : reg port map(
            clk => clk, 
            en => s_decoder_out(6) and wr,
            reset => reset, 
            data_in => data_in, 
            data_out => s_mux_in(6)
        );

        fifo_7 : reg port map(
            clk => clk, 
            en => s_decoder_out(7) and wr,
            reset => reset, 
            data_in => data_in, 
            data_out => s_mux_in(7)
        );

        MUX : MUX8_1 port map (
            reg0 => s_mux_in(0),
            reg1 => s_mux_in(1),
            reg2 => s_mux_in(2),
            reg3 => s_mux_in(3),
            reg4 => s_mux_in(4),
            reg5 => s_mux_in(5),
            reg6 => s_mux_in(6),
            reg7 => s_mux_in(7),
            sel  => s_rdptr, 
            data_out => s_mux_out
        );

        TSB : tri_state_buffer port map (
            data_in => s_mux_out, 
            enable  => rd, 
            data_out => data_out
        );


    end struct ; 
    
