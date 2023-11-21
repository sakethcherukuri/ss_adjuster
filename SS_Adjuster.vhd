----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 16.11.2023 13:49:57
-- Design Name: 
-- Module Name: SS_Adjuster - Behavioral
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
Library UNISIM;
use UNISIM.vcomponents.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity SS_Adjuster is
    Port ( rst : in STD_LOGIC;
           clk : in STD_LOGIC;
           ss_n : in STD_LOGIC;
           spi_clk : in STD_LOGIC;
           mosi : in STD_LOGIC;
           miso : in STD_LOGIC;
           a_ss_n : out STD_LOGIC;
           a_spi_clk : out STD_LOGIC;
           a_mosi : out STD_LOGIC;
           a_miso : out STD_LOGIC);
end SS_Adjuster;

architecture Behavioral of SS_Adjuster is

type t_state is (s_IDLE, s_MOSI_to_FIFO, s_GEN_ADJ_SIGNALS, s_READ_from_FIFO);
signal state : t_state := s_IDLE;
signal AF_Flag, AE_Flag, Full_flag, Empty_flag, miso_flag : std_logic := '0';
signal count_clk2, count_spi_clk, count_to_gen_clk2 : integer := 0;
signal s_Wr_DV, s_Rd_DV : std_logic := '0';
signal start_clk2 : std_logic := '0';
signal clk2 : std_logic := '0';

begin
					
MOSI_FIFO: entity work.FIFO 
    generic map(
        WIDTH => 1,
        DEPTH => 16
    )
    port map(
        i_Rst_L => rst,
        i_wClk   => spi_clk,
        i_Wr_DV    => s_Wr_DV,
        i_Wr_Data  => mosi,
        i_AF_Level => 10,
        o_AF_Flag  => AF_Flag,
        o_Full     => Full_flag,

        -- Read Side
        i_rClk   => a_spi_clk,
        i_Rd_En    => s_Rd_DV,
        o_Rd_DV    => AE_Flag,
        o_Rd_Data  => a_mosi,
        i_AE_Level => 1,
        o_AE_Flag  => AE_Flag,
        o_Empty   =>  Empty_flag);
    );

MISO_FIFO: entity work.FIFO
    generic map(
        WIDTH => 1,
        DEPTH => 8   
    )
    port map(

    )

process (spi_clk)
begin

    -- At every rising edge of spi_clk send the MOSI data to FIFO if the chip select is high.
    if (ss_n = '1') then 
        state => s_MOSI_to_FIFO;
    end if;

    -- After the sending of data has started, when the FIFO is filled till 10 bits assert the
    -- Almost Full flag with which we can start a adjusted signals.
    if (AF_Flag = '1') then
        state => s_GEN_ADJ_SIGNALS;
    end if;

    if (count_clk2 = 16) then
        state => s_IDLE;
    end if;

end process;

process(clk)
begin
    if rising_edge(clk) then
        case state is 
            when s_IDLE =>
                s_Wr_DV <= '0';
                s_Rd_DV <= '0';
            when s_MOSI_to_FIFO =>
                s_Wr_DV <= ss_n;
            when s_GEN_ADJ_SIGNALS =>
                a_ss_n <= '1';
                start_clk2 <= '1';
                state <= s_READ_from_FIFO;
            when s_READ_from_FIFO =>
                s_Rd_DV <= AF_Flag;
    end if;
end process;


process(clk)
begin
    if rising_edge(clk)then
        if (start_clk2 = '1') then
            count_to_gen_clk2 <= count_to_gen_clk2 + 1;
            if (count_to_gen_clk2 = 8) then
                clk2 <= not clk2;
            end if;
        end if;

end process;

end Behavioral;
