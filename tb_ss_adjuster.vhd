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


signal s_rst : std_logic := '0';
signal s_clk : std_logic := '0';
signal s_ss_n : std_logic := '0';
signal s_spi_clk : std_logic := '0';
signal s_mosi : std_logic := '0';
signal s_miso : std_logic := '0';
signal s_a_ss_n : std_logic := '0';
signal s_a_spi_clk : std_logic := '0';
signal s_a_mosi : std_logic := '0';
signal s_a_miso : std_logic := '0';

constant spi_clk_period : time := 160 ns;
constant clk_period : time := 10 ns;


begin

DUT: entity work.SS_Adjuster 
    port map(
        rst => s_rst,
        clk => s_clk,
        ss_n => s_ss_n,
        spi_clk => s_spi_clk,
        mosi => s_mosi,
        miso => s_miso,
        a_ss_n => s_a_ss_n,
        a_spi_clk => s_a_spi_clk,
        a_mosi => s_a_mosi,
        a_miso => s_a_miso
    );

process
begin
    s_clk <= '0';
    wait for clk_period/2;
    s_clk <= '1';
    wait for clk_period/2;
end process;


end Behavioral;
