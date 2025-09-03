--------------------------------------------------------
-- Project : Time
-- Author : Riccardo Rossi
-- Date : 02-09-2025
-- Description : Dynamic Driver for 7 segment display
--               Uses 2 digits: seconds and tenths
--------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity e_DriverSSD is

port (ul_Clock_i      : in  std_logic;                       -- System clock @ 50 MHz 
      ul_Reset_i      : in  std_logic;                       -- Global reset
      u4_Seconds_i    : in  unsigned(3 downto 0);            -- BCD seconds
      u4_Tenths_i     : in  unsigned(3 downto 0);            -- BCD tenths 
      lv8_Seg_o       : out std_logic_vector(7 downto 0);    -- Segments (a-g + dp)
      lv4_DigitSel_o  : out std_logic_vector(3 downto 0));   -- Digits selector

end entity e_DriverSSD;


architecture a_DisplayDriver of e_DriverSSD is

    -- Function to convert BCD to 7-segment code
    function f_BcdToSeg(bcd : unsigned(3 downto 0); dp : std_logic) return std_logic_vector is
        variable seg : std_logic_vector(7 downto 0);
    begin
        case bcd is
            when "0000" => seg := "11000000"; -- 0
            when "0001" => seg := "11111001"; -- 1
            when "0010" => seg := "10100100"; -- 2
            when "0011" => seg := "10110000"; -- 3
            when "0100" => seg := "10011001"; -- 4
            when "0101" => seg := "10010010"; -- 5
            when "0110" => seg := "10000010"; -- 6
            when "0111" => seg := "11111000"; -- 7
            when "1000" => seg := "10000000"; -- 8
            when "1001" => seg := "10010000"; -- 9
            when others => seg := "11111111"; -- OFF
        end case;
        seg(7) := dp; -- DP is MSB
        return seg;
    end function;

    -- Multiplexing counter for scanning digits
    signal u_MuxCounter_s : unsigned(15 downto 0) := (others => '0');
    signal u_DigitIndex_s : unsigned(1 downto 0)  := (others => '0');

begin

    -- Process to slow down digit scanning
    p_MuxCounter : process(ul_Clock_i, ul_Reset_i)
    begin
        if ul_Reset_i = '1' then
            u_MuxCounter_s <= (others => '0');
            u_DigitIndex_s <= (others => '0');
        elsif rising_edge(ul_Clock_i) then
            u_MuxCounter_s <= u_MuxCounter_s + 1;
            
            -- Switch digit every 1 kHz (50 MHz / 50k)
            if u_MuxCounter_s = 50000 - 1 then
                u_MuxCounter_s <= (others => '0');
                u_DigitIndex_s <= u_DigitIndex_s + 1;
            end if;
        end if;
    end process;

    -- Process to activate digits and assign segments
    p_Display : process(u_DigitIndex_s, u4_Seconds_i, u4_Tenths_i)
    begin
        case u_DigitIndex_s is
            when "00" =>  -- Tenths' digit
                lv8_Seg_o      <= f_BcdToSeg(u4_Tenths_i, '1'); -- DP off
                lv4_DigitSel_o <= "1110";                        -- Activate only digit0
            when "01" =>  -- Seconds' digit
                lv8_Seg_o      <= f_BcdToSeg(u4_Seconds_i, '0'); -- DP on
                lv4_DigitSel_o <= "1101";                         -- Activate only digit1
            when others =>
                lv8_Seg_o      <= (others => '1'); -- Turn off
                lv4_DigitSel_o <= "1111";          -- All digits off
        end case;
    end process;

end architecture a_DisplayDriver;
