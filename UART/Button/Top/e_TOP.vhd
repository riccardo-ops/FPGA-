---------------------------------------------------------------------
-- Project : UART                              
-- Author : Riccardo Rossi                     
-- Date : 19-09-2025                           
-- Description : Aim of this module is to 
---------------------------------------------------------------------


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity e_TOP is 

port (l_Clock12MHz_i   : in  std_logic;        -- System clock @ 12 MHz 
      l_Button_i       : in  std_logic;        -- Button signal debounced
      l_Data_o         : out std_logic);       -- Output serial data to pc   
end entity e_TOP;


architecture a_TOP of e_TOP is 

   -- PLL Wrapper --
   component e_PLLWrapper is 
   port (l_Clock12MHz_i   : in  std_logic;         -- System clock @ 12 MHz 
         ul_Locked_o      : out std_ulogic;        -- Locked signal  
         ul_Clock12MHz_o  : out std_ulogic);       -- Output clock @ 12 MHz    
   end component e_PLLWrapper;

   
   -- Reset --
   component e_Reset is 
   generic (c_MAX_i : integer := 240000);      -- This generic constant is set to 20 ms (240000 clock cycles at 12 MHz) 
   port (ul_Clock12MHz_i   : in  std_ulogic;        -- System clock @ 12 MHz from PLL 
         ul_Locked_i       : in  std_ulogic;        -- Locked signal  
         ul_Reset_o        : out std_ulogic);       -- Output Reset  
   end component e_Reset;
   
   -- Button --
   component e_Button is 
   generic (c_MAX_i : integer := 240000);          
   port (ul_Clock12MHz_i   : in  std_ulogic;       
         ul_Reset_i        : in  std_ulogic;       
         l_Button_i        : in  std_logic;        
         ul_Tick_o         : out std_ulogic);      
   end component e_Button;                         
                                                   
                                                   
   -- Baud Rate --                                 
   component e_BaudRate is                         
   generic (c_CYCLES_i : integer := 104);          
   port (ul_Clock12MHz_i   : in  std_ulogic;       
         ul_Reset_i        : in  std_ulogic;       
         ul_BaudRate_o     : out std_ulogic);      
   end component e_BaudRate;                       
                                                   
                                                   
   -- Transmission --                              
   component e_Transmission is                     
   port (ul_Clock12MHz_i   : in  std_ulogic;       
         ul_Reset_i        : in  std_ulogic;       
         ul_BaudRate_i     : in  std_ulogic;       
         ul_Button_i       : in  std_ulogic;       
         l_Data_o          : out std_logic);      
   end component e_Transmission;
   
   -- Signal declaration -- 
   constant c_MAX_i          : integer := 240000;
   constant c_CYCLES_i       : integer := 104;
   signal ul_Locked_s        : std_ulogic;
   signal ul_Clock12MHz_s    : std_ulogic;
   signal ul_Reset_s         : std_ulogic;
   signal ul_Tick_s          : std_ulogic;
   signal ul_BaudRate_s      : std_ulogic;
   
begin 

   -- PLL -- 
   PLL_inst : e_PLLWrapper 
   port map(
   l_Clock12MHz_i  => l_Clock12MHz_i,
   ul_Locked_o     => ul_Locked_s,
   ul_Clock12MHz_o => ul_Clock12MHz_s);
   
   -- Reset -- 
   Reset_inst : e_Reset
   port map(
   ul_Clock12MHz_i  => ul_Clock12MHz_s,
   ul_Locked_i      => ul_Locked_s,
   ul_Reset_o       => ul_Reset_s);
   
   -- Button -- 
   Button_inst : e_Button
   port map (
   ul_Clock12MHz_i => ul_Clock12MHz_s,
   ul_Reset_i      => ul_Reset_s,
   l_Button_i      => l_Button_i,
   ul_Tick_o       => ul_Tick_s);
   
   -- Baud Rate -- 
   BaudRate_inst : e_BaudRate
   port map(
   ul_Clock12MHz_i => ul_Clock12MHz_s,
   ul_Reset_i      => ul_Reset_s,
   ul_BaudRate_o   => ul_BaudRate_s);
   
   -- Transmission --
   Transmission_inst : e_Transmission
   port map(
   ul_Clock12MHz_i => ul_Clock12MHz_s,
   ul_Reset_i      => ul_Reset_s,
   ul_BaudRate_i   => ul_BaudRate_s,
   ul_Button_i     => ul_Tick_s,
   l_Data_o        => l_Data_o);
   

end a_TOP;
