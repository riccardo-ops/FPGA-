---------------------------------------------------------------------
-- Project : UART                              
-- Author : Riccardo Rossi                     
-- Date : 19-09-2025                           
-- Description : Aim of this module is to debounce a buttons
---------------------------------------------------------------------


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity e_Button is 

generic (c_MAX_i : integer := 240000);           -- Max to reach for debouncing --> 20 ms == 240.000 clock cycles # 12 MHz  

port (ul_Clock12MHz_i   : in  std_ulogic;        -- System clock @ 12 MHz 
      ul_Reset_i        : in  std_ulogic;        -- Reset signal from PLL's module 
      l_Button_i        : in  std_logic;         -- Button signal 
      ul_Tick_o         : out std_ulogic);       -- Output Reset signal debounced 
end entity e_Button;


architecture a_Button of e_Button is 

   signal u18_Counter_s : unsigned(17 downto 0);         -- Counter for debouncing operation
   signal ul_Button1_s  : std_ulogic;                    -- debouncing signal
   signal ul_Button2_s  : std_ulogic;                    -- debouncing signal

begin 

   -- Process to debounce the buttons 
   p_Debounce : process(ul_Clock12MHz_i)
   
   begin 
      
      if (ul_Reset_i = '1') then 
      
         u18_Counter_s    <= (others => '0');
         ul_Tick_o       <= '0';
         ul_Button1_s    <= '0';
         ul_Button2_s    <= '0';
      
      elsif rising_edge(ul_Clock12MHz_i) then 
      
         ul_Button1_s <= l_Button_i;
         ul_Button2_s <= ul_Button1_s;
      
         if (ul_Button2_s = '1') then 
            
            if (u18_Counter_s = to_unsigned(c_MAX_i, u18_Counter_s'length)) then 
            
               u18_Counter_s <= (others => '0');
               ul_Tick_o <= '1';
               
            else 
            
               u18_Counter_s <= u18_Counter_s + 1;
               ul_Tick_o <= '0';
               
            end if;
         
         else 
         
            u18_Counter_s    <= (others => '0');
            ul_Tick_o       <= '0';
            
         end if;
         
      end if;
   
   end process;

end a_Button;