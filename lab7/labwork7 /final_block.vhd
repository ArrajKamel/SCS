library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_SIGNED.ALL;

entity final_block is 
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
end entity ; 

architecture struct of final_block is
    component saturator is
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

    component sliding_window_adder is
        Generic (
            WINDOW_SIZE : integer := 5  -- Size of the sliding window
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

    signal s_value_tvalid, s_value_tready : std_logic := '0';
    signal s_value : std_logic_vector(31 downto 0) := (others => '0');

begin
    s : saturator port map (
        aclk                 <= aclk                ,
        s_axis_val_tvalid    <= s_axis_val_tvalid   ,
        s_axis_val_tready    <= s_axis_val_tready   ,
        s_axis_val_tdata     <= s_axis_val_tdata    ,
        s_axis_max_tvalid    <= s_axis_max_tvalid   ,
        s_axis_max_tready    <= s_axis_max_tready   ,
        s_axis_max_tdata     <= s_axis_max_tdata    ,
        s_axis_min_tvalid    <= s_axis_min_tvalid   ,
        s_axis_min_tready    <= s_axis_min_tready   ,
        s_axis_min_tdata     <= s_axis_min_tdata    ,
        m_axis_result_tvalid <= s_value_tvalid,
        m_axis_result_tready <= s_value_tready,
        m_axis_result_tdata  <= s_value
    );

    SWA : sliding_window_adder port map (
        aclk              <= aclk                ,
        s_axis_val_tvalid <=  s_value_tvalid     ,
        s_axis_val_tready <=  s_value_tready     ,
        s_axis_val_tdata  <=  s_value            ,
        m_axis_sum_tvalid <=  m_axis_sum_tvalid  ,
        m_axis_sum_tready <=  m_axis_sum_tready  ,
        m_axis_sum_tdata  <=  m_axis_sum_tdata   
    );

end architecture;