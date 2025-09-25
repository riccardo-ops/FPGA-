---------------------------------------------------------------------
-- Project : UART                              
-- Author : Riccardo Rossi                     
-- Date : 19-09-2025                           
-- Description : Aim of this module is to wrap the PLL IP from Xilinx
---------------------------------------------------------------------


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity e_PLLWrapper is 

port (l_Clock12MHz_i   : in  std_logic;         -- System clock @ 12 MHz 
      ul_Locked_o      : out std_ulogic;        -- Locked signal  
      ul_Clock12MHz_o  : out std_ulogic);       -- Output clock @ 12 MHz    
end entity e_PLLWrapper;


architecture a_PLLWrapper of e_PLLWrapper is 

   component clk_wiz_0
   port(clk_out1          : out    std_logic;
        locked            : out    std_logic;
        clk_in1           : in     std_logic);
   end component;

begin 

   PLL_inst : clk_wiz_0
   port map (clk_out1 => ul_Clock12MHz_o,
             locked   => ul_Locked_o,
             clk_in1  => l_Clock12MHz_i);

end a_PLLWrapper;
