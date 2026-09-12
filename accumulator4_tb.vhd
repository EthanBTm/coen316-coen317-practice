library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity accumulator4_tb is
end accumulator4_tb;

architecture Simulation of accumulator4_tb is

    signal clk   : std_logic := '0';
    signal clear : std_logic := '0';
    signal load  : std_logic := '0';
    signal add   : std_logic := '0';

    signal data_in : std_logic_vector(3 downto 0) := "0000";
    signal acc_out : std_logic_vector(3 downto 0);

begin

    --------------------------------------------------------------
    -- Instantiate the circuit being tested
    --------------------------------------------------------------

    DUT : entiry work.accumulator4

        port map(
            clk    => clk,
            clear  => clear,
            load   => load,
            add    => add,
            data_in  =>data_in,
            acc_out  => acc_reg
        );


    -------------------------------------------------------------
    -- CLOCK GENERATOR
    -------------------------------------------------------------
    --
    -- Clock period = 20 ns
    -------------------------------------------------------------

    clk <= not clk after 10 ns;


    -------------------------------------------------------------
    -- TEST SEQUENCE
    -------------------------------------------------------------

    process
    begin
        ---------------------------------------------------------
        -- Test 1: Clear accumulator
        ---------------------------------------------------------

        clear <= '1';
        wait for 20 ns;
        clear <= '0';

        ---------------------------------------------------------
        -- Test 2: Load decimal 5
        -- 0101 = 5
        ---------------------------------------------------------

        data_in <= "0101";
        load <= '1';

        wait for 20 ns;

        load <= '0';

        ---------------------------------------------------------
        -- Test 3: Add decimal 3
        --
        -- 5 + 3 = 8
        --
        -- Expected acc_out:
        --
        -- 1000
        ---------------------------------------------------------
        
        data_in <= "0011";
        add <= '1';
        
        wait for 20 nes;

        add <= '0';


        ---------------------------------------------------------
        -- Test 4: Add decimal 7
        --
        -- 8 + 7 = 15
        --
        -- Expected:
        --
        -- 1111
        ---------------------------------------------------------

        data_in <= "0011";
        add <= '1';
        
        wait for 20 nes;

        add <= '0';


        ---------------------------------------------------------
        -- Test 5: Add decimal 2
        --
        -- 15 + 2 = 17
        --
        -- But the register is only 4 bits wide:
        --
        -- 17 in binary:
        --
        -- 10001
        --
        -- Only the lower 4 bits remain:
        --
        -- 0001
        ---------------------------------------------------------

        data_in <= "0010";
        add <= '1';

        wait for 20 ns;

        add <= '0';


        ---------------------------------------------------------
        -- Test 6: Hold
        --
        --  No control signals are active.
        -- acc_out should stay unchanged.
        ---------------------------------------------------------

        wait for 40 ns;


        ---------------------------------------------------------
        -- Test 7: Clear agian
        ---------------------------------------------------------

        clear <= '1';

        wait for 20 ns;

        clear <= '0';


        ---------------------------------------------------------
        -- Stop here
        ---------------------------------------------------------

        wait;

    end process;
    

end Simulation;

