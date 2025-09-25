---------------------------------------------------------------------
-- Project : UART                              
-- Author : Riccardo Rossi                     
-- Date : 19-09-2025                           
-- Description : Aim of this module is to 
---------------------------------------------------------------------


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity e_Transmission is 

port (ul_Clock12MHz_i   : in  std_ulogic;        -- System clock @ 12 MHz 
      ul_Reset_i        : in  std_ulogic;        -- Reset signal from PLL's module 
      ul_BaudRate_i     : in  std_ulogic;        -- Baud rate signal generated every 104 clock cycles at 115200
      ul_Button_i       : in  std_ulogic;        -- Button signal debounced
      l_Data_o          : out std_logic);        -- Output serial data to pc   
end entity e_Transmission;


architecture a_Transmission of e_Transmission is 

   signal ulv10_Data_s : std_ulogic_vector(9 downto 0);     -- Parallel message to be transmitted
   signal u4_Counter_s : unsigned(3 downto 0);              -- Counter for the number of bit transmitted 
   
   type state_type is (st_IDLE, st_START, st_SEND);
   signal state : state_type;

   
   
begin 

   ------------------------------------------------------------------
   -- Process to implement a FSM with 3 states : IDLE, START, SEND --
   ------------------------------------------------------------------
   p_FSM : process(ul_Clock12MHz_i, ul_Reset_i)
   begin 
   
      if (ul_Reset_i = '1') then 
      
         l_Data_o <= '1';    -- idle state 
         ulv10_Data_s <= (others => '0');
         u4_Counter_s <= (others => '0');
         
         state <= st_IDLE;
         
      elsif rising_edge(ul_Clock12MHz_i) then 
      
         case state is

            when st_IDLE =>
            
               if (ul_Button_i = '1') then 
               
                  state <= st_START;
               
               else 
               
                  l_Data_o <= '1';
                  
                  state <= st_IDLE;
               
               end if;
            
            
            when st_START =>
            
               ulv10_Data_s <= "1111111110";
               
               state <= st_SEND;
            
            when st_SEND =>
            
               if (ul_BaudRate_i = '1') then 
               
                  if (u4_Counter_s = to_unsigned(9, u4_Counter_s'length)) then 
                  
                     u4_Counter_s <= (others => '0');
                     l_Data_o <= '1';                      -- Back to idle state
                     
                     state <= st_IDLE;
                  
                  else 
                  
                     u4_Counter_s <= u4_Counter_s + 1;
                     l_Data_o <= ulv10_Data_s(to_integer(u4_Counter_s));
                     
                     state <= st_SEND;
                  
                  end if;
                  
               else 
               
                  null;
                  
               end if;
            
            
            when others =>
               
               l_Data_o <= '1';
               ulv10_Data_s <= (others => '0');
               u4_Counter_s <= (others => '0');
         
               state <= st_IDLE;
             
         end case;
      
      end if;
      
   end process;




end a_Transmission;