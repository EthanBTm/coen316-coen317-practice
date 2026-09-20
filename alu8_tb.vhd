library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- ============================================================
-- Testbench for alu8
--
-- A testbench has no external ports because it exists only
-- inside the simulator.
-- ============================================================

entity alu8_tb is
end alu8_tb;


architecture Simulation of alu8_tb is

    -- Signals that connect the testbench to our ALU.

    signal A      : std_logic_vector(7 downto 0);
    signal B      : std_logic_vector(7 downto 0);

    signal ALU_OP : std_logic_vector(1 downto 0);

    signal RESULT : std_logic_vector(7 downto 0);
    signal ZERO   : std_logic;

begin

    -- ========================================================
    -- DEVICE UNDER TEST
    -- ========================================================

    DUT : entity work.alu8

        port map(
            A      => A,
            B      => B,
            ALU_OP => ALU_OP,
            RESULT => RESULT,
            ZERO   => ZERO
        );


    -- ========================================================
    -- TEST PROCESS
    -- ========================================================

    process
    begin

        --------------------------------------------------------
        -- TEST 1: ADDITION
        --
        -- 5 + 3 = 8
        --------------------------------------------------------

        A <= "00000101";       -- 5
        B <= "00000011";       -- 3

        ALU_OP <= "00";        -- ADD

        wait for 10 ns;

        -- Expected:
        --
        -- RESULT = 00001000
        -- ZERO   = 0


        --------------------------------------------------------
        -- TEST 2: SUBTRACTION
        --
        -- 10 - 4 = 6
        --------------------------------------------------------

        A <= "00001010";       -- 10
        B <= "00000100";       -- 4

        ALU_OP <= "01";        -- SUBTRACT

        wait for 10 ns;

        -- Expected:
        --
        -- RESULT = 00000110
        -- ZERO   = 0


        --------------------------------------------------------
        -- TEST 3: AND
        --------------------------------------------------------

        A <= "10101010";
        B <= "11110000";

        ALU_OP <= "10";        -- AND

        wait for 10 ns;

        --       10101010
        -- AND   11110000
        --       --------
        --       10100000
        --
        -- Expected RESULT = 10100000


        --------------------------------------------------------
        -- TEST 4: OR
        --------------------------------------------------------

        A <= "10101010";
        B <= "00001111";

        ALU_OP <= "11";        -- OR

        wait for 10 ns;

        --       10101010
        -- OR    00001111
        --       --------
        --       10101111
        --
        -- Expected RESULT = 10101111


        --------------------------------------------------------
        -- TEST 5: ZERO FLAG
        --
        -- 7 - 7 = 0
        --------------------------------------------------------

        A <= "00000111";
        B <= "00000111";

        ALU_OP <= "01";

        wait for 10 ns;

        -- Expected:
        --
        -- RESULT = 00000000
        -- ZERO   = 1


        --------------------------------------------------------
        -- TEST 6:
        -- AND operation also produces zero.
        --------------------------------------------------------

        A <= "11110000";
        B <= "00001111";

        ALU_OP <= "10";

        wait for 10 ns;

        --       11110000
        -- AND   00001111
        --       --------
        --       00000000
        --
        -- Expected:
        --
        -- RESULT = 00000000
        -- ZERO   = 1


        --------------------------------------------------------
        -- Stop changing inputs.
        --------------------------------------------------------

        wait;

    end process;

end Simulation;