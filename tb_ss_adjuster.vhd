----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 21.11.2023 13:23:06
-- Design Name: 
-- Module Name: tb_ss_adjuster - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity tb_ss_adjuster is
--  Port ( );
end tb_ss_adjuster;

architecture Behavioral of tb_ss_adjuster is

component SS_Adjuster
    port(
        rst : in STD_LOGIC;
        clk : in STD_LOGIC;
        ss_n : in STD_LOGIC;
        spi_clk : in STD_LOGIC;
        mosi : in STD_LOGIC;
        miso : in STD_LOGIC;
        a_ss_n : out STD_LOGIC;
        a_spi_clk : out STD_LOGIC;
        a_mosi : out STD_LOGIC;
        a_miso : out STD_LOGIC
    );

end component;


signal 
begin


end Behavioral;
