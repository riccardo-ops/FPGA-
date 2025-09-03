-------------------------------------------------------------------
-- Project : Time
-- Author  : Riccardo Rossi
-- Date    : 02-09-2025
-- Description : Time counter with range: 0.0 → 9.9, then it resets
-------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity e_TimeCounter is
port (ul_Clock_i     : in  std_logic;                    -- System clock @ 50 MHz
      ul_Reset_i     : in  std_logic;                    -- Global reset 
      ul_Tick10Hz_i  : in  std_logic;                    -- Tick every 0.1 s from ClockDivider module
      ul_ResetBtn_i  : in  std_logic;                    -- Reset button 
      u4_Seconds_o   : out unsigned(3 downto 0);         -- Seconds (0-9)
      u4_Tenth_o     : out unsigned(3 downto 0));        -- 1/10th of seconds (0-9)
        
end entity e_TimeCounter;

architecture a_TimeCounter of e_TimeCounter is

    signal u4_Seconds_s : unsigned(3 downto 0) := (others => '0');    -- Seconds counter 
    signal u4_Tenth_s   : unsigned(3 downto 0) := (others => '0');    -- Tenths counter 

begin
   
   -- Process to count the ticks from ClockDivider module --
   p_Counter : process(ul_Clock_i, ul_Reset_i)
   
   begin
   
      if (ul_Reset_i = '1') then
      
         u4_Seconds_s <= (others => '0');
         u4_Tenth_s  <= (others => '0');
   
      elsif rising_edge(ul_Clock_i) then
      
         if (ul_ResetBtn_i = '1') then
         
            u4_Seconds_s <= (others => '0');
            u4_Tenth_s  <= (others => '0');
   
         elsif (ul_Tick10Hz_i = '1') then
         
            if (u4_Tenth_s = 9) then

               u4_Tenth_s <= (others => '0');
   
               if (u4_Seconds_s = 9) then

                  u4_Seconds_s <= (others => '0');

               else
               
                  u4_Seconds_s <= u4_Seconds_s + 1;
                  
               end if;
   
            else
            
               u4_Tenth_s <= u4_Tenth_s + 1;
               
            end if;
           
         end if;
       
      end if;
   
   end process;


    -- Combinational assignment -- 
    u4_Seconds_o <= u4_Seconds_s;
    u4_Tenth_o  <= u4_Tenth_s;

end architecture a_TimeCounter;
