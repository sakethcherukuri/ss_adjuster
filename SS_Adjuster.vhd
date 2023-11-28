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
use IEEE.numeric_std.all;
Library UNISIM;
use UNISIM.vcomponents.all;
library xil_defaultlib;

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


------------------------- MOSI ----------------------------

type t_state_mosi is (s_IDLE, s_GEN_ADJ_SIGNALS, s_ONE_LAST_CYCLE, s_STOP_CLK2);
signal state, next_state : t_state_mosi := s_IDLE;

-- flags and we are currently only interested in AF_Flag.
signal AF_Flag, AE_Flag, Full_flag, Empty_flag : std_logic := '0';
-- Signals for setting the Data valid lines on the FIFO
signal s_Wr_DV_mosi, s_Rd_DV_mosi : std_logic := '0';

------------------------- MOSI ----------------------------


------------------------- MISO ----------------------------

type t_state_miso is (s_IDLE_miso, s_READ_from_FIFO_miso);
signal state_miso : t_state_miso := s_IDLE_miso;
-- Miso flags
signal AF_Flag_miso, miso_start_flag : std_logic := '0';
-- Signals for setting the Data valid lines on the FIFO
signal s_Wr_DV_miso, s_Rd_DV_miso : std_logic := '0';
------------------------- MISO ----------------------------

-- Signals that count
signal count_clk2, count_spi_clk, count_to_gen_clk2, count : integer := 0;

-- Write or Read control bit
signal cmd_write : std_logic := '0';

signal start_clk2, stop_clk2, clk2 : std_logic := '0';

signal s_mosi, s_miso, s_a_mosi, s_a_miso : std_logic_vector(0 downto 0) :=  "0" ;

constant g_WIDTH : integer := 1;
constant g_DEPTH : integer := 16;

begin
					
MOSI_FIFO: entity xil_defaultlib.FIFO_ss 
    generic map(
        WIDTH => g_WIDTH,
        DEPTH => g_DEPTH
    )
    port map(
        i_Rst_L => rst,
        i_wClk   => spi_clk,
        i_Wr_DV    => ss_n,
        i_Wr_Data  => s_mosi,
        i_AF_Level => 10,
        o_AF_Flag  => AF_Flag,
        o_Full     => Full_flag,

        -- Read Side
        i_rClk   => clk2,
        i_Rd_En    => s_Rd_DV_mosi,
        o_Rd_DV    => AE_Flag,
        o_Rd_Data  => s_a_mosi,
        i_AE_Level => 1,
        o_AE_Flag  => AE_Flag,
        o_Empty   =>  Empty_flag
    );

MISO_FIFO: entity xil_defaultlib.FIFO_ss
    generic map (
        WIDTH => g_WIDTH,
        DEPTH => 8
    )
    port map (
        i_Rst_L => rst,
        i_wClk   => spi_clk,
        i_Wr_DV    => miso_start_flag,
        i_Wr_Data  => s_miso,
        i_AF_Level => 5,
        o_AF_Flag  => AF_Flag_miso,
        o_Full     => Full_flag,

        -- Read Side
        i_rClk   => clk2,
        i_Rd_En    => s_Rd_DV_miso,
        o_Rd_DV    => AE_Flag,
        o_Rd_Data  => s_a_miso,
        i_AE_Level => 1,
        o_AE_Flag  => AE_Flag,
        o_Empty   =>  Empty_flag
    );

p_mosi: process (clk)
begin
    if rising_edge(clk) then
        if rst = '0' then
            s_Wr_DV_mosi <= '0';
            s_Rd_DV_mosi <= '0';
            start_clk2 <= '0';
        else
            -- State Transition logic
            --state <= next_state;

            case state is
                when s_IDLE =>
                    if AF_Flag = '1' then
                        --next_state <= s_GEN_ADJ_SIGNALS;
                        state <= s_GEN_ADJ_SIGNALS;
                        start_clk2 <= '1';
                        s_Rd_DV_mosi <= AF_Flag;
                    
                    else 
                        --next_state <= s_IDLE;
                        state <= s_IDLE;
                    end if;

                when s_GEN_ADJ_SIGNALS  =>
                    --if (count_clk2 = 16) then
                    if (count = 32) then
                        --next_state <= s_ONE_LAST_CYCLE;
                        state <= s_ONE_LAST_CYCLE;
                        s_Rd_DV_mosi <= '0';
                    else
                        --next_state <= s_GEN_ADJ_SIGNALS;
                        state <= s_GEN_ADJ_SIGNALS;
                    end if;
                when s_ONE_LAST_CYCLE =>
                    --if (count_clk2 = 17) then
                    if (count = 33) then
                        --next_state <= s_IDLE;
                        state <= s_IDLE;
                        start_clk2 <= '0';
                        s_Wr_DV_mosi <= '0';
                        s_Rd_DV_mosi <= '0';
                    else
                        --next_state <= s_ONE_LAST_CYCLE;
                        state <= s_ONE_LAST_CYCLE;
                    end if;                   
                when others => 
                    --next_state <= s_IDLE;
                    state <= s_IDLE;
                    start_clk2 <= '0';
                    s_Wr_DV_mosi <= '0';
                    s_Rd_DV_mosi <= '0';
            end case;
        end if;
    end if;
end process;

p_miso: process (clk)
begin
    if rising_edge(clk) then
        if rst = '0' then
            s_Wr_DV_miso <= '0';
            s_Rd_DV_miso <= '0';
        else
            if (cmd_write = '0') then
                case state_miso is
                    when s_IDLE_miso => 
                        --if (AF_Flag_miso = '1' and count_clk2 = 8) then
                        if (AF_Flag_miso = '1' and count = 16) then
                            state_miso <= s_READ_from_FIFO_miso;
                            s_Rd_DV_miso <= AF_Flag_miso;
                        else
                            state_miso <= s_IDLE_miso;
                        end if;
                    
                        when s_READ_from_FIFO_miso =>
                            --if count_clk2 = 16 then
                            if (count = 32) then
                                state_miso <= s_IDLE_miso;
                                s_Wr_DV_miso <= '0';
                                s_Rd_DV_miso <= '0';
                            else 
                                state_miso <= s_READ_from_FIFO_miso;
                            end if;
                    when others =>
                            state_miso <= s_IDLE_miso;
                            s_Wr_DV_miso <= '0';
                            s_Rd_DV_miso <= '0';
                
                end case;
            end if;
        end if;
    end if;
end process;

--process (spi_clk, clk2)
--begin
--    if rising_edge(spi_clk) then
        -- At every rising edge of spi_clk send the MOSI data to FIFO if the chip select is high.
--        if (ss_n = '1') then 
--            state <= s_MOSI_to_FIFO;
--        end if;

        -- After the sending of data has started, when the FIFO is filled till 10 bits assert the
        -- Almost Full flag with which we can start a adjusted signals.
--        if (AF_Flag = '1') then
--            state <= s_GEN_ADJ_SIGNALS;
--        end if;

--        if (stop_clk2 = '1') then
 --           state <= s_IDLE;
--        end if;
--    end if;
--end process;

--process(clk)
--begin
--    if rising_edge(clk) then
--        case state is 
--            when s_IDLE =>
--                s_Wr_DV <= '0';
--                s_Rd_DV <= '0';
--                start_clk2 <= '0';
--            when s_MOSI_to_FIFO =>
--                s_Wr_DV <= ss_n;
--            when s_GEN_ADJ_SIGNALS =>
--                start_clk2 <= '1';
--                s_Rd_DV <= AF_Flag;
--            when others =>
--                s_Wr_DV <= '0';
--                s_Rd_DV <= '0';
--                start_clk2 <= '0';
--        end case;
--    end if;
--end process;


process(clk)
begin
    if rising_edge(clk)then
        if (start_clk2 = '1') then
            count_to_gen_clk2 <= count_to_gen_clk2 + 1;
            if (count_to_gen_clk2 = 3) then
                clk2 <= not clk2;
                count_to_gen_clk2 <= 0;
                count <= count + 1;
            end if;
        else 
            clk2 <= '0';
            count <= 0;
        end if;
    end if;

end process;

process(clk2)
begin
    -- At every rising edge of the faster clock i.e clk2, increment the counter value by '1'
    if rising_edge(clk2) then
    --    if (count_clk2 < 16) then
        count_clk2 <= count_clk2 + 1;
        if start_clk2 = '0' then
            count_clk2 <= 0;
        end if;
    end if;
end process;


process (spi_clk)
begin
    if rising_edge(spi_clk) then
        if (count_spi_clk = 0 and mosi = '1') then
            cmd_write <= '1';
        elsif (count_spi_clk = 0 and mosi = '0') then
            cmd_write <= '0';
        end if;
        --if count_spi_clk < 15 then
        count_spi_clk <= count_spi_clk + 1;
        if count_spi_clk = 15 then
            count_spi_clk <= 0;
            cmd_write <= '0';
        end if;
        
    end if;
end process;

a_spi_clk <= clk2;
s_mosi(0) <= mosi;
s_miso(0) <= miso;
a_miso <= s_a_miso(0);
a_mosi <= s_a_mosi(0);
a_ss_n <= start_clk2;
miso_start_flag <= '1' when (count_spi_clk > 7 and count_spi_clk < 17) else '0';

end Behavioral;
