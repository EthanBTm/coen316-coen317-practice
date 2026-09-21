library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity accumulator8_tb is
end accumulator8_tb;


architecture Simulation of accumulator8_tb is

    signal CLK     : std_logic := '0';
    signal RESET   : std_logic := '0';

    signal OP      : std_logic_vector(1 downto 0) := "00";
    signal DATA_IN : std_logic_vector(7 downto 0) := (others => '0');

    signal ACC_OUT : std_logic_vector(7 downto 0);
    signal ZERO    : std_logic;

begin

    -- ========================================================
    -- DEVICE UNDER TEST
    -- ========================================================

    DUT : entity work.accumulator8

        port map(
            CLK     => CLK,
            RESET   => RESET,
            OP      => OP,
            DATA_IN => DATA_IN,
            ACC_OUT => ACC_OUT,
            ZERO    => ZERO
        );


    -- ========================================================
    -- CLOCK GENERATOR
    --
    -- CLK starts at 0.
    --
    -- Every 5 ns it flips:
    --
    --      0 -> 1 -> 0 -> 1 ...
    --
    -- Therefore:
    --
    --      clock period = 10 ns
    --
    -- Rising edges occur every 10 ns.
    -- ========================================================

    CLK <= not CLK after 5 ns;


    -- ========================================================
    -- TEST SEQUENCE
    -- ========================================================

    process
    begin

        --------------------------------------------------------
        -- TEST 1: RESET
        --------------------------------------------------------

        RESET <= '1';

        wait for 10 ns;

        RESET <= '0';

        -- Expected after rising edge:
        --
        -- ACC_OUT = 00000000
        -- ZERO    = 1


        --------------------------------------------------------
        -- TEST 2: LOAD 5
        --------------------------------------------------------

        DATA_IN <= "00000101";     -- 5
        OP      <= "01";           -- LOAD

        wait for 10 ns;

        -- Expected:
        --
        -- ACC_OUT = 00000101
        -- ZERO    = 0


        --------------------------------------------------------
        -- TEST 3: ADD 3
        --
        -- Current value = 5
        --
        -- 5 + 3 = 8
        --------------------------------------------------------

        DATA_IN <= "00000011";     -- 3
        OP      <= "10";           -- ADD

        wait for 10 ns;

        -- Expected:
        --
        -- ACC_OUT = 00001000
        --
        -- decimal 8


        --------------------------------------------------------
        -- TEST 4: ADD 4
        --
        -- Current value = 8
        --
        -- 8 + 4 = 12
        --------------------------------------------------------

        DATA_IN <= "00000100";     -- 4
        OP      <= "10";

        wait for 10 ns;

        -- Expected:
        --
        -- ACC_OUT = 00001100
        --
        -- decimal 12


        --------------------------------------------------------
        -- TEST 5: HOLD
        --------------------------------------------------------

        OP <= "00";

        -- DATA_IN deliberately changes.
        --
        -- Since OP = HOLD, this should NOT affect
        -- the accumulator.

        DATA_IN <= "11111111";

        wait for 10 ns;

        -- Expected:
        --
        -- ACC_OUT is STILL:
        --
        --     00001100
        --
        -- decimal 12


        --------------------------------------------------------
        -- TEST 6: LOAD
        --
        -- Replace 12 with 20.
        --------------------------------------------------------

        DATA_IN <= "00010100";     -- 20
        OP      <= "01";

        wait for 10 ns;

        -- Expected:
        --
        -- ACC_OUT = 00010100


        --------------------------------------------------------
        -- TEST 7: CLEAR
        --------------------------------------------------------

        OP <= "11";

        wait for 10 ns;

        -- Expected:
        --
        -- ACC_OUT = 00000000
        -- ZERO    = 1


        --------------------------------------------------------
        -- TEST 8: HOLD ZERO
        --------------------------------------------------------

        OP <= "00";

        wait for 10 ns;

        -- Expected:
        --
        -- ACC_OUT remains 00000000
        -- ZERO remains 1


        --------------------------------------------------------
        -- Stop applying new tests.
        --------------------------------------------------------

        wait;

    end process;


end Simulation;