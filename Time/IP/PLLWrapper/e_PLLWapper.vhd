------------------------------------------------
-- Project : Time
-- Author : Riccardo Rossi
-- Date : 01-09-2025
-- Description : Wrapper per l'IP del PLL Altera
------------------------------------------------


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity e_PLLWapper is 

port (l_Clock50MHz_i   : in  std_logic;      -- System clock @ 50 MHz 
      ul_Locked_o      : out std_ulogic;     -- Output locked signal 
      ul_Clock50MHz_o  : out std_ulogic);    -- Output stable clock @ 50 MHz 
      
end entity e_PLLWapper;


architecture a_PLLWrapper of e_PLLWapper is 

   component PLL
   port(c0          : out    std_logic;         
        locked      : out    std_logic;         
        inclk0      : in     std_logic);         
   end component;

begin 

   PLLWrapper_inst : PLL
   
   port map(c0        => ul_Clock50MHz_o,
            locked    => ul_Locked_o,
            inclk0    => l_Clock50MHz_i
            );

end architecture a_PLLWrapper;