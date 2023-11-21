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
signal count_clk2, count_spi_clk, count_to_gen_clk2 : integer := 1;
signal s_Wr_DV, s_Rd_DV : std_logic := '0';
signal start_clk2, clk2 : std_logic := '0';

signal s_mosi, s_miso : std_logic_vector(0 downto 0);

component FIFO_ss
    generic (
        WIDTH    : integer := 8;
        DEPTH     : integer := 256);
      port (
        i_Rst_L : in std_logic;
    
        -- Write Side
        i_wClk   : in std_logic;
        i_Wr_DV    : in  std_logic;
        i_Wr_Data  : in  std_logic_vector(WIDTH-1 downto 0);
        i_AF_Level : in  integer;
        o_AF_Flag  : out std_logic;
        o_Full     : out std_logic;
    
        -- Read Side
        i_rClk   : in std_logic;
        i_Rd_En    : in  std_logic;
        o_Rd_DV    : out std_logic;
        o_Rd_Data  : out std_logic_vector(WIDTH-1 downto 0);
        i_AE_Level : in  integer;
        o_AE_Flag  : out std_logic;
        o_Empty    : out std_logic);
end component;


begin
					
MOSI_FIFO: FIFO_ss 
    generic map(
        WIDTH => 1,
        DEPTH => 16
    )
    port map(
        i_Rst_L => rst,
        i_wClk   => spi_clk,
        i_Wr_DV    => s_Wr_DV,
        i_Wr_Data  => s_mosi,
        i_AF_Level => 10,
        o_AF_Flag  => AF_Flag,
        o_Full     => Full_flag,

        -- Read Side
        i_rClk   => clk2,
        i_Rd_En    => s_Rd_DV,
        o_Rd_DV    => AE_Flag,
        o_Rd_Data  => s_mosi,
        i_AE_Level => 1,
        o_AE_Flag  => AE_Flag,
        o_Empty   =>  Empty_flag
    );


process (spi_clk, clk2)
begin

    -- At every rising edge of spi_clk send the MOSI data to FIFO if the chip select is high.
    if (ss_n = '1') then 
        state <= s_MOSI_to_FIFO;
    end if;

    -- After the sending of data has started, when the FIFO is filled till 10 bits assert the
    -- Almost Full flag with which we can start a adjusted signals.
    if (AF_Flag = '1') then
        state <= s_GEN_ADJ_SIGNALS;
    end if;

    -- At every rising edge of the faster clock i.e clk2, increment the counter value by '1' and when
    -- the counter reaches a value of '16' set the state to IDLE
    count_clk2 <= count_clk2 + 1;
    if (count_clk2 = 17) then
        state <= s_IDLE;
    end if;

end process;

process(clk)
begin
    if rising_edge(clk) then
        case state is 
            when s_IDLE =>
                s_Wr_DV <= '1';
                s_Rd_DV <= '0';
                start_clk2 <= '0';
            when s_MOSI_to_FIFO =>
                s_Wr_DV <= ss_n;
            when s_GEN_ADJ_SIGNALS =>
                a_ss_n <= '1';
                start_clk2 <= '1';
                s_Rd_DV <= AF_Flag;
            when others =>
                s_Wr_DV <= '1';
                s_Rd_DV <= '0';
                start_clk2 <= '0';
        end case;
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
        else 
            clk2 <= '0';
        end if;
    end if;

end process;

a_spi_clk <= clk2;
s_mosi(0) <= mosi;
s_mosi(0) <= miso;

end Behavioral;
