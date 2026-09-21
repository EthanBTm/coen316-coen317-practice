library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

-- ============================================================
-- COEN 316 Weekend Practice
-- 8-bit Accumulator Register
--
-- The accumulator is an 8-bit register that can:
--
--   OP = "00"  -> HOLD current value
--   OP = "01"  -> LOAD DATA_IN
--   OP = "10"  -> ADD DATA_IN to current value
--   OP = "11"  -> CLEAR to zero
--
-- Example:
--
--   Current accumulator = 5
--   DATA_IN             = 3
--   OP                  = "10"
--
--   After the next rising clock edge:
--
--       accumulator = 8
--
-- Important idea:
--
--   The value changes ONLY on a rising clock edge.
-- ============================================================


entity accumulator8 is

    port(
        CLK      : in  std_logic;
        RESET    : in  std_logic;

        OP       : in  std_logic_vector(1 downto 0);
        DATA_IN  : in  std_logic_vector(7 downto 0);

        ACC_OUT  : out std_logic_vector(7 downto 0);
        ZERO     : out std_logic
    );

end accumulator8;


architecture Behavioral of accumulator8 is

    -- Internal register.
    --
    -- This signal actually remembers the accumulator value
    -- between clock edges.

    signal accumulator :
        std_logic_vector(7 downto 0) := (others => '0');

begin

    -- ========================================================
    -- CLOCKED PROCESS
    --
    -- Because this is sequential logic, CLK is in the
    -- sensitivity list.
    --
    -- Nothing inside the rising_edge section happens until
    -- CLK changes from 0 to 1.
    -- ========================================================

    process(CLK)
    begin

        if rising_edge(CLK) then

            ----------------------------------------------------
            -- SYNCHRONOUS RESET
            ----------------------------------------------------
            --
            -- RESET is checked INSIDE rising_edge(CLK).
            --
            -- Therefore RESET does not immediately clear the
            -- register.
            --
            -- It clears the register on the next rising edge.
            ----------------------------------------------------

            if RESET = '1' then

                accumulator <= (others => '0');


            else

                ------------------------------------------------
                -- SELECT ACCUMULATOR OPERATION
                ------------------------------------------------

                case OP is

                    --------------------------------------------
                    -- 00 = HOLD
                    --------------------------------------------

                    when "00" =>

                        -- No assignment is actually required.
                        --
                        -- A register naturally keeps its old
                        -- value if we do not assign a new one.

                        null;


                    --------------------------------------------
                    -- 01 = LOAD
                    --------------------------------------------

                    when "01" =>

                        -- Copy DATA_IN directly into the
                        -- accumulator.

                        accumulator <= DATA_IN;


                    --------------------------------------------
                    -- 10 = ADD
                    --------------------------------------------

                    when "10" =>

                        -- std_logic_vector is converted to
                        -- unsigned so numeric_std can perform
                        -- arithmetic.
                        --
                        -- The result is converted back into
                        -- std_logic_vector for storage.

                        accumulator <=
                            std_logic_vector(
                                unsigned(accumulator)
                                +
                                unsigned(DATA_IN)
                            );


                    --------------------------------------------
                    -- 11 = CLEAR
                    --------------------------------------------

                    when "11" =>

                        accumulator <= (others => '0');


                    when others =>

                        null;

                end case;

            end if;

        end if;

    end process;


    -- ========================================================
    -- OUTPUT
    -- ========================================================

    ACC_OUT <= accumulator;


    -- ========================================================
    -- ZERO FLAG
    --
    -- This part is combinational.
    --
    -- ZERO automatically reflects the current contents of
    -- the accumulator.
    -- ========================================================

    ZERO <= '1'
            when accumulator = "00000000"
            else '0';


end Behavioral;