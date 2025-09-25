---------------------------------------------------------------------
-- Project : UART                              
-- Author : Riccardo Rossi                     
-- Date : 19-09-2025                           
-- Description : Aim of this module is to test the top module :
--                1) verify that the baud rate signal is generated correctly
--                2) verify the debouncing
--                3) verify that the uart tx signal is sent serially
---------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity e_UartTb is
end entity e_UartTb;

architecture a_UartTb of e_UartTb is

  component e_TOP is
    port (
      l_Clock12MHz_i : in  std_logic;
      l_Button_i     : in  std_logic;
      l_Data_o       : out std_logic
    );
  end component;

  signal l_Clock12MHz_s : std_logic := '0';
  signal l_Button_s     : std_logic := '0';
  signal l_Data_s       : std_logic := '1';

begin

  TOP_inst : e_TOP
    port map(
      l_Clock12MHz_i => l_Clock12MHz_s,
      l_Button_i     => l_Button_s,
      l_Data_o       => l_Data_s
    );

  -- CLOCK GENERATION: 12 MHz (period = 83.333 ns)
  clk_gen : process
  begin
    while true loop
      l_Clock12MHz_s <= '0';
      wait for 41.666 ns;
      l_Clock12MHz_s <= '1';
      wait for 41.666 ns;
    end loop;
  end process;

  -- STIMULI PROCESS
  stimuli : process
  begin
    -- Power-up idle
    l_Button_s <= '0';
    wait for 21 ms;

    -- Single button press test (debounce)
    l_Button_s <= '1';
    wait for 21 ms;         -- Sufficient time for the debounce logic

    l_Button_s <= '0';      -- Release button
    wait for 2 ms;

    -- Second button press (optional, repeat test)
    l_Button_s <= '1';
    wait for 10 ms;
    l_Button_s <= '0';

    -- Wait and observe UART output
    wait for 3 ms;

    -- End simulation
    wait;
  end process;

  -- MONITOR: print UART tx value every time changes (for easier debug)
  monitor : process(l_Data_s)
  begin
    report "UART TX changes: " & std_logic'image(l_Data_s);
  end process;

end a_UartTb;
