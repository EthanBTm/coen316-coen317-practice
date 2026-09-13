library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity mux_register_tb is
end mux_register_tb;


architecture Simulation of mux_register_tb is

    signal clk    : std_logic := '0';
    signal reset : std_logic := '0';

    signal select_in : std_logic_vector(1 downto 0);

    signal data0    : std_logic_vector(7 downto 0);
    signal data0    : std_logic_vector(7 downto 0);
    signal data0    : std_logic_vector(7 downto 0);
    signal data0    : std_logic_vector(7 downto 0);

    signal output_reg : std_logic_vector(7 downto 0);

begin

    --------------------------------------------------------------------------
    -- Instantiate the circuit
    --------------------------------------------------------------------------

    DUT : entity work.mux_register

        port map(
            clk        => clk,
            reset      => reset,
            select_in  => select_in,

            data0      => data0,
            data1      => data1,
            data2      => data2,
            data3      => data3,

            output_reg => output_reg
        );


        ----------------------------------------------------------------------
        -- Clock generator
        --
        -- Full clock period = 20 ns
        ----------------------------------------------------------------------

        clk <= not clk after 10 ns;


        ----------------------------------------------------------------------
        -- Test sequecne
        ----------------------------------------------------------------------

        process
        begin

            ------------------------------------------------------------------
            -- Give each input a different value
            ------------------------------------------------------------------

            data0 <= "00000001"; -- 1
            data1 <= "00000101"; -- 5
            data2 <= "00001010"; -- 10
            data3 <= "00001111"; -- 15


            ------------------------------------------------------------------
            -- Reset register
            ------------------------------------------------------------------

            reset <= '1';

            wait for 20 ns;

            reset <= '0';


            ------------------------------------------------------------------
            -- Select data0
            --
            -- mux_output becomes 1
            -- regsiter stores it on next rising edge
            ------------------------------------------------------------------

            select_in <= "00";

            wait for 20 ns;


            ------------------------------------------------------------------
            -- Select data2
            --
            -- Expected output after next clock:
            --
            -- 00001010 = 10
            ------------------------------------------------------------------

            select_in <= "10";

            wait for 20 ns;


            ------------------------------------------------------------------
            -- Select data3
            --
            -- Expected:
            --
            -- 00001111 = 15
            ------------------------------------------------------------------

            select_in <= "11";

            wait for 20 ns;


            ------------------------------------------------------------------
            -- Change data3 while it is selected
            ------------------------------------------------------------------

            data3 <= "11110000";

            wait for 20 ns;


            ------------------------------------------------------------------
            -- Select data1
            ------------------------------------------------------------------

            select_in <= "01";

            wait for 20 ns;


            ------------------------------------------------------------------
            -- End simulation
            ------------------------------------------------------------------

            wait;

        end process;

end Simulation;