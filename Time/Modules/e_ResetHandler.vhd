------------------------------------------------
-- Progetto : Time
-- Autore : Riccardo Rossi
-- Data : 1-09-2025
-- Descrizione : Aim of this module is to reset  
--               the system according to locked 
------------------------------------------------


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity e_ResetHandler is 

generic (c_MaxTime_i : integer);                -- 200 ms integer number  

port (ul_Locked_i       : in  std_ulogic;       -- Locked signal from PLL module 
      ul_Clock50MHz_i   : in  std_ulogic;       -- System clock @ 50 MHz 
      ul_Reset_o        : out std_ulogic);      -- Output global reset signal 

end entity e_ResetHandler;


architecture a_ResetHandler of e_ResetHandler is 

   signal u22_Counter_s : unsigned(21 downto 0);         -- Counter signal used to count up until 200 ms

begin 

   -- Process to validate the locked signal --
   p_Count : process(ul_Locked_i, ul_Clock50MHz_i)
   
   begin  
         
      if rising_edge(ul_Clock50MHz_i) then 
      
         if (ul_Locked_i = '0') then 
      
            ul_Reset_o <= '1';
            u22_Counter_s <= (others => '0');
         
         else 
         
            if (u22_Counter_s = to_unsigned(c_MaxTime_i, u22_Counter_s'length)) then 
            
               ul_Reset_o <= '0';
               u22_Counter_s <= (others => '0');
               
            else 
            
               u22_Counter_s <= u22_Counter_s + 1;
               
            end if;
            
         end if;
         
      end if;
   
   end process;

end architecture a_ResetHandler;