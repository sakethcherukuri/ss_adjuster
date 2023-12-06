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
signal test : std_logic := '0';


constant spi_clk_period : time := 160 ns;
constant clk_period : time := 10 ns;
constant i : integer := 1;


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

process 
begin
    for i in 1 to 16 loop
        test <= '0';
        wait for 20 ns;
        test <= '1';
        wait for 20 ns;
    end loop; -- spi_clk_loop
        wait;
end process;

process
begin
    s_rst <= '0';
    wait for 35 ns;
    s_rst <= '1';
    wait for 45 ns;
    
    -- set the ss_n to high
    s_ss_n <= '1';
    wait for 1000 ns;
    
    -- starting the spi_clk of 6.25 MHz. Hence toggling every 80 ns.
    -- 1st rising edge
    s_spi_clk <= '1';
    wait for 320 ns;
    s_spi_clk <= '0';
    wait for 320 ns;
    
    -- 2nd rising edge
    s_spi_clk <= '1';
    wait for 320 ns;
    s_spi_clk <= '0';
    wait for 320 ns;
    
    -- 3rd rising edge
    s_spi_clk <= '1';
    wait for 320 ns;
    s_spi_clk <= '0';
    wait for 320 ns;
    
    -- 4th rising edge
    s_spi_clk <= '1';
    wait for 320 ns;
    s_spi_clk <= '0';
    wait for 320 ns;
    
    -- 5th rising edge
    s_spi_clk <= '1';
    wait for 320 ns;
    s_spi_clk <= '0';
    wait for 320 ns;
    
    -- 6th rising edge
    s_spi_clk <= '1';
    wait for 320 ns;
    s_spi_clk <= '0';
    wait for 320 ns;
    
    -- 7th rising edge
    s_spi_clk <= '1';
    wait for 320 ns;
    s_spi_clk <= '0';
    wait for 320 ns;
    
    -- 8th rising edge
    s_spi_clk <= '1';
    wait for 320 ns;
    s_spi_clk <= '0';
    wait for 320 ns;
    
    -- 9th rising edge
    s_spi_clk <= '1';
    wait for 320 ns;
    s_spi_clk <= '0';
    wait for 320 ns;
    
    -- 10th rising edge
    s_spi_clk <= '1';
    wait for 320 ns;
    s_spi_clk <= '0';
    wait for 320 ns;
    
    -- 11th rising edge
    s_spi_clk <= '1';
    wait for 320 ns;
    s_spi_clk <= '0';
    wait for 320 ns;
    
    -- 12th rising edge
    s_spi_clk <= '1';
    wait for 320 ns;
    s_spi_clk <= '0';
    wait for 320 ns;
    
    -- 13th rising edge
    s_spi_clk <= '1';
    wait for 320 ns;
    s_spi_clk <= '0';
    wait for 320 ns;
    
    -- 14th rising edge
    s_spi_clk <= '1';
    wait for 320 ns;
    s_spi_clk <= '0';
    wait for 320 ns;
    
    -- 15th rising edge
    s_spi_clk <= '1';
    wait for 320 ns;
    s_spi_clk <= '0';
    wait for 320 ns;
    
    -- 16th rising edge
    s_spi_clk <= '1';
    wait for 320 ns;
    s_spi_clk <= '0';
    wait for 320 ns;

    s_ss_n <= '0';
    wait for 200 ns;
    s_ss_n <= '1';
    wait for 480 ns;
    
    ------------------------------------------------------------------------------------
    -------------------------------- Second Transcation --------------------------------
    ------------------------------------------------------------------------------------

    s_spi_clk <= '1';
    wait for 320 ns;
    s_spi_clk <= '0';
    wait for 320 ns;
    
    -- 2nd rising edge
    s_spi_clk <= '1';
    wait for 320 ns;
    s_spi_clk <= '0';
    wait for 320 ns;
    
    -- 3rd rising edge
    s_spi_clk <= '1';
    wait for 320 ns;
    s_spi_clk <= '0';
    wait for 320 ns;
    
    -- 4th rising edge
    s_spi_clk <= '1';
    wait for 320 ns;
    s_spi_clk <= '0';
    wait for 320 ns;
    
    -- 5th rising edge
    s_spi_clk <= '1';
    wait for 320 ns;
    s_spi_clk <= '0';
    wait for 320 ns;
    
    -- 6th rising edge
    s_spi_clk <= '1';
    wait for 320 ns;
    s_spi_clk <= '0';
    wait for 320 ns;
    
    -- 7th rising edge
    s_spi_clk <= '1';
    wait for 320 ns;
    s_spi_clk <= '0';
    wait for 320 ns;
    
    -- 8th rising edge
    s_spi_clk <= '1';
    wait for 320 ns;
    s_spi_clk <= '0';
    wait for 320 ns;
    
    -- 9th rising edge
    s_spi_clk <= '1';
    wait for 320 ns;
    s_spi_clk <= '0';
    wait for 320 ns;
    
    -- 10th rising edge
    s_spi_clk <= '1';
    wait for 320 ns;
    s_spi_clk <= '0';
    wait for 320 ns;
    
    -- 11th rising edge
    s_spi_clk <= '1';
    wait for 320 ns;
    s_spi_clk <= '0';
    wait for 320 ns;
    
    -- 12th rising edge
    s_spi_clk <= '1';
    wait for 320 ns;
    s_spi_clk <= '0';
    wait for 320 ns;
    
    -- 13th rising edge
    s_spi_clk <= '1';
    wait for 320 ns;
    s_spi_clk <= '0';
    wait for 320 ns;
    
    -- 14th rising edge
    s_spi_clk <= '1';
    wait for 320 ns;
    s_spi_clk <= '0';
    wait for 320 ns;
    
    -- 15th rising edge
    s_spi_clk <= '1';
    wait for 320 ns;
    s_spi_clk <= '0';
    wait for 320 ns;
    
    -- 16th rising edge
    s_spi_clk <= '1';
    wait for 320 ns;
    s_spi_clk <= '0';
    wait for 1660 ns;
    wait;


end process;

process
begin
    s_mosi <= '0';
    wait for 1040 ns;
    -- Control bit = 7th bit
    s_mosi <= '0';
    wait for 640 ns;
    
    -- A6 bit
    s_mosi <= '0';
    wait for 640 ns;
    
    -- A5 bit
    s_mosi <= '0';
    wait for 640 ns;
    
    -- A4 bit
    s_mosi <= '1';
    wait for 640 ns;
    
    -- A3 bit
    s_mosi <= '0';
    wait for 640 ns;
    
    -- A2 bit
    s_mosi <= '1';
    wait for 640 ns;
    
    -- A1 bit
    s_mosi <= '1';
    wait for 640 ns;
      
    -- A0 bit
    s_mosi <= '0';
    wait for 6400 ns;

    ------------------------------------------------------------------------------------
    -------------------------------- Second Transcation --------------------------------
    ------------------------------------------------------------------------------------

    s_mosi <= '1';
    wait for 640 ns;
    
    -- A6 bit
    s_mosi <= '0';
    wait for 640 ns;
    
    -- A5 bit
    s_mosi <= '0';
    wait for 640 ns;
    
    -- A4 bit
    s_mosi <= '0';
    wait for 640 ns;
    
    -- A3 bit
    s_mosi <= '0';
    wait for 640 ns;
    
    -- A2 bit
    s_mosi <= '0';
    wait for 640 ns;
    
    -- A1 bit
    s_mosi <= '1';
    wait for 640 ns;
      
    -- A0 bit
    s_mosi <= '0';
    wait for 640 ns;
    
    -- D7 bit
    s_mosi <= '1';
    wait for 640 ns;
    
    -- D6 bit
    s_mosi <= '1';
    wait for 640 ns;
    
    -- D5 bit
    s_mosi <= '0';
    wait for 640 ns;
    
    -- D4 bit
    s_mosi <= '1';
    wait for 640 ns;
    
    -- D3 bit
    s_mosi <= '0';
    wait for 640 ns;
    
    -- D2 bit
    s_mosi <= '1';
    wait for 640 ns;
    
    -- D1 bit
    s_mosi <= '1';
    wait for 640 ns;
      
    -- D0 bit
    s_mosi <= '0';
    wait for 640 ns;
    
    wait;
end process;


process
begin
    
    wait for 5895 ns;
    --D7 bit
    s_miso <= '1';
    wait for 40 ns;
        
    --D6 bit
    s_miso <= '0';
    wait for 40 ns;

    --D5 bit
    s_miso <= '0';
    wait for 40 ns;

    --D4 bit
    s_miso <= '0';
    wait for 40 ns;

    --D3 bit
    s_miso <= '1';
    wait for 40 ns;

    --D2 bit
    s_miso <= '0';
    wait for 40 ns;

    --D1 bit
    s_miso <= '0';
    wait for 40 ns;

    --D0 bit
    s_miso <= '1';
    wait for 40 ns;
    s_miso <= '0';

    wait;
end process;


end Behavioral;
