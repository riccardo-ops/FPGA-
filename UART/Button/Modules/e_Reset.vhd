---------------------------------------------------------------------
-- Project : UART                              
-- Author : Riccardo Rossi                     
-- Date : 19-09-2025                           
-- Description : Aim of this module is to connect Reset to Locked 
---------------------------------------------------------------------


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity e_Reset is 
generic (c_MAX_i : integer := 240000);      -- This generic constant is set to 20 ms (240000 clock cycles at 12 MHz) 
port (ul_Clock12MHz_i   : in  std_ulogic;        -- System clock @ 12 MHz from PLL 
      ul_Locked_i       : in  std_ulogic;        -- Locked signal  
      ul_Reset_o        : out std_ulogic);       -- Output Reset  
end entity e_Reset;


architecture e_Reset of e_Reset is 

   signal u18_Counter_s : unsigned(17 downto 0);

begin 

   p_Count : process(ul_Clock12MHz_i, ul_Locked_i)
   begin 
      
      if rising_edge(ul_Clock12MHz_i) then
      
         if ul_Locked_i = '1' then
         
            if u18_Counter_s < to_unsigned(c_MAX_i, u18_Counter_s'length) then
            
               u18_Counter_s <= u18_Counter_s + 1;
                ul_Reset_o    <= '1';
            
            else
            
               ul_Reset_o    <= '0';
            
            end if;
        
         else
        
            u18_Counter_s <= (others => '0');
            ul_Reset_o    <= '1';   
        
         end if;
    
      end if;
   
   end process;

end e_Reset;
