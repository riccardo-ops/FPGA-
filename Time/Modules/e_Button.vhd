---------------------------------------------------------------------
-- Project : Time                              
-- Author : Riccardo Rossi                     
-- Date : 01-09-2025                           
-- Description : Aim of this module is to debounce reset push buttons
---------------------------------------------------------------------


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity e_Button is 

generic (c_Reset_i : integer);                  -- Max to reach for debouncing --> 200 ms  

port (ul_Clock50MHz_i   : in  std_ulogic;       -- System clock @ 50 MHz 
      ul_LockedReset_i  : in  std_logic;        -- Reset signal from PLL's module 
      l_Reset_i         : in  std_logic;        -- Input Reset from button 
      ul_Reset_o        : out std_ulogic);      -- Output Reset signal debounced 
      
end entity e_Button;


architecture a_Button of e_Button is 

   signal u_ResetCounter_s : unsigned(15 downto 0);         -- Counter for debouncing operation

begin 

   -- Process to debounce the buttons 
   p_Debounce : process(ul_Clock50MHz_i)
   
   begin 
   
      if (ul_LockedReset_i = '1') then 
      
         u_ResetCounter_s <= (others => '0');
         ul_Reset_o       <= '0';
      
      elsif rising_edge(ul_Clock50MHz_i) then 

         -- Reset button is pressed 
         if (l_Reset_i = '0') then 
            
            if (u_ResetCounter_s = to_unsigned(c_Reset_i, u_ResetCounter_s'length)) then 
            
               u_ResetCounter_s <= (others => '0');
               ul_Reset_o <= '1';
               
            else 
            
               u_ResetCounter_s <= u_ResetCounter_s + 1;
               ul_Reset_o <= '0';
               
            end if;
         
         else 
         
            u_ResetCounter_s <= (others => '0');
            ul_Reset_o <= '0';
            
         end if;
         
      end if;
   
   end process;

end a_Button;