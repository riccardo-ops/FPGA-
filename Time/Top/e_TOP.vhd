------------------------------
-- Project : Time          
-- Author : Riccardo Rossi 
-- Date : 01-09-2025       
-- Description : Top module
------------------------------


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity e_TOP is 

generic (c_MaxTime_i      : integer := 1000000 - 1;
         c_Tick1Hz_i      : integer := 50000000 - 1;
         c_Tick10Hz_i     : integer := 5000000 - 1;
         c_Max_i          : integer := 9;
         c_Reset_i        : integer := 1000000 - 1);
         
port (l_Clock50MHz_i      : in  std_logic;                        -- Global clock at 50 MHz
      l_Reset_i           : in  std_logic;                        -- Reset button used for the display 
      lv8_SSD_o           : out std_logic_vector(7 downto 0);     -- Seven Segment Display signal 
      lv4_Sel_o           : out std_logic_vector(3 downto 0));    -- Selection signal 
      
end entity e_TOP;


architecture a_TOP of e_TOP is


   ---------
   -- PLL --
   ---------
   
   component e_PLLWapper is 
   port (l_Clock50MHz_i   : in  std_logic;
         ul_Locked_o      : out std_ulogic;
         ul_Clock50MHz_o  : out std_ulogic);   
   end component e_PLLWapper;
   
   
   -------------------
   -- Reset handler --
   -------------------

   component e_ResetHandler is 
   generic (c_MaxTime_i : integer);
   port (ul_Locked_i       : in  std_ulogic;
         ul_Clock50MHz_i   : in  std_ulogic;
         ul_Reset_o        : out std_ulogic);
   end component e_ResetHandler; 
   
   
   -------------------
   -- Clock divider --
   -------------------
   
   component e_ClockDivider is 
   generic (c_Tick1Hz_i  : integer;      
            c_Tick10Hz_i : integer;       
            c_Max_i      : integer);     
   port (ul_Clock50MHz_i  : in  std_ulogic;   
         ul_Reset_i       : in  std_logic;    
         ul_ResetBtn_i    : in  std_logic;    
         ul_Tick10Hz_o    : out std_ulogic);
   end component e_ClockDivider;
   
   
   ---------------------
   -- Button Debounce --
   ---------------------
   
   component e_Button is 
   generic (c_Reset_i : integer);
   port (ul_Clock50MHz_i   : in  std_ulogic;    
         ul_LockedReset_i  : in  std_logic;     
         l_Reset_i         : in  std_logic;     
         ul_Reset_o        : out std_ulogic);
   end component e_Button;
   
   
   ------------------
   -- Time Counter --
   ------------------
   
   component e_TimeCounter is 
   port (ul_Clock_i     : in  std_logic;            
         ul_Reset_i     : in  std_logic;            
         ul_Tick10Hz_i  : in  std_logic;            
         ul_ResetBtn_i  : in  std_logic;            
         u4_Seconds_o   : out unsigned(3 downto 0); 
         u4_Tenth_o     : out unsigned(3 downto 0));
   end component e_TimeCounter;
   
   
   
   ----------------
   -- SSD Driver --
   ----------------
   
   component e_DriverSSD is
   port (ul_Clock_i      : in  std_logic;                     
         ul_Reset_i      : in  std_logic;                    
         u4_Seconds_i    : in  unsigned(3 downto 0);         
         u4_Tenths_i     : in  unsigned(3 downto 0);         
         lv8_Seg_o       : out std_logic_vector(7 downto 0); 
         lv4_DigitSel_o  : out std_logic_vector(3 downto 0));
   end component e_DriverSSD;
   


   ------------------------
   -- Signal Declaration -- 
   ------------------------
   signal l_Clock50MHz_s   : std_logic;
   signal ul_Locked_s      : std_ulogic;
   signal ul_Clock50MHz_s  : std_ulogic;
   signal ul_Reset_s       : std_ulogic;
   signal ul_Tick10Hz_s    : std_ulogic;
   signal ul_ResetBtn_s    : std_ulogic;
   signal u4_Seconds_s     : unsigned(3 downto 0);
   signal u4_Tenths_s      : unsigned(3 downto 0);
   

begin 

   
   -- PLL --
   PLL_inst : e_PLLWapper 
   port map (l_Clock50MHz_i   => l_Clock50MHz_i,
             ul_Locked_o      => ul_Locked_s,
             ul_Clock50MHz_o  => ul_Clock50MHz_s);
   
   -- Reset Handler --
   Reset_inst : e_ResetHandler 
   generic map (c_MaxTime_i => c_MaxTime_i)
   port map (ul_Locked_i          => ul_Locked_s,
             ul_Clock50MHz_i      => ul_Clock50MHz_s,
             ul_Reset_o           => ul_Reset_s);
   
   -- Button -- 
   Button_inst : e_Button 
   generic map (c_Reset_i => c_Reset_i)
                
   port map (ul_Clock50MHz_i    => ul_Clock50MHz_s,
             ul_LockedReset_i   => ul_Reset_s,
             l_Reset_i          => l_Reset_i,
             ul_Reset_o         => ul_ResetBtn_s);
   
   -- Clock Divider --
   ClockDiv_inst : e_ClockDivider 
   generic map (c_Tick1Hz_i  => c_Tick1Hz_i,
                c_Tick10Hz_i => c_Tick10Hz_i,
                c_Max_i      => c_Max_i)
                
   port map (ul_Clock50MHz_i => ul_Clock50MHz_s,
             ul_Reset_i      => ul_Reset_s,
             ul_ResetBtn_i   => ul_ResetBtn_s,
             ul_Tick10Hz_o   => ul_Tick10Hz_s);
             
             
   -- Time Counter --
   TimeCounter_inst : e_TimeCounter
   port map (ul_Clock_i    => ul_Clock50MHz_s,
             ul_Reset_i    => ul_Reset_s,
             ul_Tick10Hz_i => ul_Tick10Hz_s,
             ul_ResetBtn_i => ul_ResetBtn_s,
             u4_Seconds_o  => u4_Seconds_s,
             u4_Tenth_o    => u4_Tenths_s);
             
   
   -- Driver SSD -- 
   DriverSSd_inst : e_DriverSSD
   port map (ul_Clock_i       => ul_Clock50MHz_s,
             ul_Reset_i       => ul_Reset_s,
             u4_Seconds_i     => u4_Seconds_s,
             u4_Tenths_i      => u4_Tenths_s,
             lv8_Seg_o        => lv8_SSD_o,
             lv4_DigitSel_o   => lv4_Sel_o);
   
end a_TOP;