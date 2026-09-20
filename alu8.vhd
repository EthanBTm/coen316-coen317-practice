library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

-- ============================================================
-- COEN 316 Weekend Practice
-- 8-bit Arithmetic Logic Unit (ALU)
--
-- Inputs:
--      A, B   = two 8-bit operands
--      ALU_OP = selects the operation
--
-- ALU_OP:
--      "00" -> A + B
--      "01" -> A - B
--      "10" -> A AND B
--      "11" -> A OR B
--
-- Outputs:
--      RESULT = result of the selected operation
--      ZERO   = '1' when RESULT = 00000000
--
-- This is combinational logic:
-- there is NO clock and NO register yet.
-- ============================================================

entity alu8 is

    port(
        A       : in  std_logic_vector(7 downto 0);
        B       : in  std_logic_vector(7 downto 0);

        ALU_OP  : in  std_logic_vector(1 downto 0);

        RESULT  : out std_logic_vector(7 downto 0);
        ZERO    : out std_logic
    );

end alu8;


architecture Behavioral of alu8 is

    -- Internal result signal.
    --
    -- We use an internal signal because RESULT is also needed
    -- when calculating the ZERO flag.
    signal alu_result : std_logic_vector(7 downto 0);

begin

    -- ========================================================
    -- ALU PROCESS
    --
    -- Because this is combinational logic, every signal read
    -- inside the process belongs in the sensitivity list.
    -- ========================================================

    process(A, B, ALU_OP)
    begin

        case ALU_OP is

            ----------------------------------------------------
            -- ADD
            ----------------------------------------------------

            when "00" =>

                -- std_logic_vector itself is just a collection
                -- of logic bits.
                --
                -- numeric_std lets us interpret those bits as
                -- unsigned binary numbers for arithmetic.

                alu_result <=
                    std_logic_vector(
                        unsigned(A) + unsigned(B)
                    );


            ----------------------------------------------------
            -- SUBTRACT
            ----------------------------------------------------

            when "01" =>

                alu_result <=
                    std_logic_vector(
                        unsigned(A) - unsigned(B)
                    );


            ----------------------------------------------------
            -- BITWISE AND
            ----------------------------------------------------

            when "10" =>

                -- Arithmetic conversion is unnecessary here.
                -- AND operates directly on each pair of bits.

                alu_result <= A AND B;


            ----------------------------------------------------
            -- BITWISE OR
            ----------------------------------------------------

            when "11" =>

                alu_result <= A OR B;


            ----------------------------------------------------
            -- Defensive default
            ----------------------------------------------------

            when others =>

                alu_result <= (others => '0');

        end case;

    end process;


    -- Send our internal result to the entity output.

    RESULT <= alu_result;


    -- ========================================================
    -- ZERO FLAG
    --
    -- CPUs often generate status flags from ALU results.
    --
    -- ZERO = 1 when every result bit is zero.
    -- ========================================================

    ZERO <= '1'
            when alu_result = "00000000"
            else '0';


end Behavioral;