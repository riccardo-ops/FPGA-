--------------------------------------------------------------------------
-- Project : UART                              
-- Author : Riccardo Rossi                     
-- Date : 19-09-2025                           
-- Description : Aim of this module is to generate the baud rate at 115200
--------------------------------------------------------------------------


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity e_BaudRate is 

generic (c_CYCLES_i : integer := 104);           -- Max to reach for baud rate -> 104 clock cycles

port (ul_Clock12MHz_i   : in  std_ulogic;        -- System clock @ 12 MHz 
      ul_Reset_i        : in  std_ulogic;        -- Reset signal from PLL's module 
      ul_BaudRate_o     : out std_ulogic);       -- Output Baud Rate signal to the Transmitter
end entity e_BaudRate;


architecture a_BaudRate of e_BaudRate is 

   signal u7_Counter_s : unsigned(6 downto 0);

begin 

   ---------------------------------------------------------------------
   -- Process to generate the Baud Rate signal every 104 clock cycles --
   ---------------------------------------------------------------------

   p_BaudGen : process(ul_Clock12MHz_i, ul_Reset_i)
   
   begin 
   
      if (ul_Reset_i = '1') then 
      
         u7_Counter_s <= (others => '0');
         ul_BaudRate_o <= '0';
         
      elsif rising_edge(ul_Clock12MHz_i) then 
      
         if (u7_Counter_s = to_unsigned(c_CYCLES_i, u7_Counter_s'length)) then 
         
            ul_BaudRate_o <= '1';
            u7_Counter_s <= (others => '0');
         
         else 
         
            ul_BaudRate_o <= '0';
            u7_Counter_s <= u7_Counter_s + 1;
         
         end if;
      
      end if;
   
   end process;




end a_BaudRate;
