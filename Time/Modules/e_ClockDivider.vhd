--------------------------------------------------------
-- Project : Time
-- Author : Riccardo Rossi
-- Date : 01-09-2025
-- Description : Logic for the clock divider. 
--               It creates 1 Hz and 10 Hz 
-------------------------------------------------------


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity e_ClockDivider is 

generic (c_Tick1Hz_i  : integer;       -- 1 second 
         c_Tick10Hz_i : integer;       -- 1/10th of a second 
         c_Max_i      : integer);      -- 10 seconds 

port (ul_Clock50MHz_i  : in  std_ulogic;   -- System clock @ 50 MHz 
      ul_Reset_i       : in  std_logic;    -- Global reset signal 
      ul_ResetBtn_i    : in  std_logic;    -- Button reset signal 
      ul_Tick10Hz_o    : out std_ulogic);  -- Tick signal, set as 0.1 every second 
      
end entity e_ClockDivider;


architecture a_ClockDivider of e_ClockDivider is 

   signal u_Counter1Hz_s  : unsigned(25 downto 0) := (others => '0');    -- Counter for 1 second 
   signal u_Counter10Hz_s : unsigned(22 downto 0) := (others => '0');    -- Counter for 0.1 second 

begin 

   p_Count : process(ul_Clock50MHz_i, ul_Reset_i)
   begin 
   
      if (ul_Reset_i = '1') then 
         u_Counter1Hz_s  <= (others => '0');
         u_Counter10Hz_s <= (others => '0');
         ul_Tick10Hz_o   <= '0';
      
      elsif rising_edge(ul_Clock50MHz_i) then 
         
         -- Reset da pulsante
         if (ul_ResetBtn_i = '1') then
            u_Counter1Hz_s  <= (others => '0');
            u_Counter10Hz_s <= (others => '0');
            ul_Tick10Hz_o   <= '0';
         
         else 
            -- Contatore 0.1 secondi
            if u_Counter10Hz_s = to_unsigned(c_Tick10Hz_i, u_Counter10Hz_s'length) then
               ul_Tick10Hz_o   <= '1';
               u_Counter10Hz_s <= (others => '0');
            else
               ul_Tick10Hz_o   <= '0';
               u_Counter10Hz_s <= u_Counter10Hz_s + 1;
            end if;
            
            -- Contatore 1 secondo
            if u_Counter1Hz_s = to_unsigned(c_Tick1Hz_i, u_Counter1Hz_s'length) then
               u_Counter1Hz_s <= (others => '0');
            else
               u_Counter1Hz_s <= u_Counter1Hz_s + 1;
            end if;

         end if;
         
      end if; 
      
   end process;

end a_ClockDivider;

