----------------------------------------------------------------
-- Project : Time
-- Author : Riccardo Rossi
-- Date : 01-09-2025
-- Description : Activates buzzer for a fixed time after trigger
----------------------------------------------------------------


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity e_DriverBuzzer is 

generic (c_Max_i : integer);

port (
      ul_Clock50MHz_i  : in  std_ulogic;
      l_Reset_i        : in  std_logic;
      l_Enable_i       : in  std_logic;
      l_Buzz_o         : out std_logic
      );
      
end entity e_DriverBuzzer;


architecture a_DriverBuzzer of e_DriverBuzzer is 

   signal u_Counter_s : unsigned(22 downto 0);

begin 

   -- Process to count until 1/10th of a second and keep the buzz active
   p_BuzzActive : process(ul_Clock50MHz_i, l_Reset_i)
   
   begin 
   
      if (l_Reset_i = '1') then 
      
         u_Counter_s <= (others => '0');
         l_Buzz_o <= '0';
         
      elsif rising_edge(ul_Clock50MHz_i) then 
      
         if (l_Enable_i = '1') then 
      
            if (u_Counter_s = to_unsigned(c_Max_i, u_Counter_s'length)) then 
            
               u_Counter_s <= (others => '0');
               l_Buzz_o <= '0';
            
            else 
            
               l_Buzz_o <= '1';
               u_Counter_s <= u_Counter_s + 1;
            
            end if;
            
         else 
         
            l_Buzz_o <= '0';
            
         end if;
         
      end if;
   
   end process;

end a_DriverBuzzer;