library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_SIGNED.ALL;


entity top_level is 
    port (
        s_axis_xt_tvalid     : in  std_logic;
        s_axis_xt_tready     : out std_logic;
        s_axis_xt_tdata      : in std_logic_vector(32 downto 0);


        s_axis_xt_1_tvalid   : in  std_logic;
        s_axis_xt_1_tready   : out std_logic;
        s_axis_xt_1_tdata    : in std_logic_vector(32 downto 0);

        s_axis_drift_tvalid  : in  std_logic;
        s_axis_drift_tready  : out std_logic;
        s_axis_drift_tdata   : in std_logic_vector(32 downto 0);

        threshold : in std_logic_vector(32 downto 0)
    );
end top_level; 

architecture struct of top_level is

    signal s_sub1_1_in : std_logic_vector(32 downto 0) := (others => '0');
    signal s_sub1_2_in : std_logic_vector(32 downto 0) := (others => '0');
    signal s_sub1_out  : std_logic_vector(32 downto 0) := (others => '0');

    signal s_sub2_1_in : std_logic_vector(32 downto 0) := (others => '0');
    signal s_sub2_2_in : std_logic_vector(32 downto 0) := (others => '0');
    signal s_sub2_out  : std_logic_vector(32 downto 0) := (others => '0');

    signal s_sub3_1_in : std_logic_vector(32 downto 0) := (others => '0');
    signal s_sub3_2_in : std_logic_vector(32 downto 0) := (others => '0'); -- drift input 
    signal s_sub3_out  : std_logic_vector(32 downto 0) := (others => '0');

    signal s_sub4_1_in : std_logic_vector(32 downto 0) := (others => '0');
    signal s_sub4_2_in : std_logic_vector(32 downto 0) := (others => '0'); -- drift input 
    signal s_sub4_out  : std_logic_vector(32 downto 0) := (others => '0');

    signal s_adder1_1_in : std_logic_vector(32 downto 0) := (others => '0');
    signal s_adder1_2_in : std_logic_vector(32 downto 0) := (others => '0');
    signal s_adder1_out  : std_logic_vector(32 downto 0) := (others => '0');

    signal s_max1_in : std_logic_vector(32 downto 0) := (others => '0');
    signal s_max1_out : std_logic_vector(32 downto 0) := (others => '0');

    signal s_max2_in : std_logic_vector(32 downto 0) := (others => '0');
    signal s_max2_out : std_logic_vector(32 downto 0) := (others => '0');

    signal s_thcomp_1_in : std_logic_vector(32 downto 0) := (others => '0');
    signal s_thcomp_2_in : std_logic_vector(32 downto 0) := (others => '0'); --the threshold input 
    signal s_thcomp_3_in : std_logic_vector(32 downto 0) := (others => '0');
    signal s_thcomp_1_out  : std_logic_vector(32 downto 0) := (others => '0');
    signal s_thcomp_2_out  : std_logic_vector(32 downto 0) := (others => '0'); -- the label ouput 
    signal s_thcomp_3_out  : std_logic_vector(32 downto 0) := (others => '0');

    component adder is
        Port (
            aclk                : in  std_logic;
    
            s_axis_x1_tvalid    : in  std_logic;
            s_axis_x1_tready    : out std_logic;
            s_axis_x1_tdata     : in  std_logic_vector(31 downto 0);
    
            s_axis_x2_tvalid    : in  std_logic;
            s_axis_x2_tready    : out std_logic;
            s_axis_x2_tdata     : in  std_logic_vector(31 downto 0);
    
            m_axis_sum_tvalid  : out std_logic;
            m_axis_sum_tready  : in  std_logic;
            m_axis_sum_tdata   : out std_logic_vector(31 downto 0)
        );
    end component;

    component maxOp is
        Port (
            aclk                : in  std_logic;
    
            s_axis_g_tvalid     : in  std_logic;  
            s_axis_g_tready     : out std_logic;
            s_axis_g_tdata      : in  std_logic_vector(31 downto 0);
    
            m_axis_max_tvalid   : out std_logic;
            m_axis_max_tready   : in  std_logic;
            m_axis_max_tdata    : out std_logic_vector(31 downto 0)
        );
    end component;


    component subtractor is
        Port (
            aclk                : in  std_logic;

            s_axis_x1_tvalid    : in  std_logic;
            s_axis_x1_tready    : out std_logic;
            s_axis_x1_tdata     : in  std_logic_vector(31 downto 0);

            s_axis_x2_tvalid    : in  std_logic;
            s_axis_x2_tready    : out std_logic;
            s_axis_x2_tdata     : in  std_logic_vector(31 downto 0);

            m_axis_diff_tvalid  : out std_logic;
            m_axis_diff_tready  : in  std_logic;
            m_axis_diff_tdata   : out std_logic_vector(31 downto 0)
        );
    end component;

    component THComp is
        Port (
            aclk                : in  std_logic;
    
            s_axis_g_plus_tvalid     : in  std_logic;
            s_axis_g_plus_tready     : out std_logic;
            s_axis_g_plus_tdata      : in  std_logic_vector(31 downto 0); 
    
            s_axis_g_minus_tvalid     : in  std_logic;
            s_axis_g_minus_tready     : out std_logic;
            s_axis_g_minus_tdata      : in  std_logic_vector(31 downto 0);
    
            threshold           : in  std_logic_vector(31 downto 0);
            
            m_axis_anomaly_tvalid : out std_logic;
            m_axis_anomaly_tready : in  std_logic;
    
            anomaly_flag        : out std_logic
        );
    end component;

begin

    



end architecture;