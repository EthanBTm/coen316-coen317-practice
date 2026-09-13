library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- COEN 316 Weekend Mini-Project
-- 4-to-1 Multiplexer with Registered Output
-- 
-- This project practices:
--
--   * entity / architecture
--   * std_logic_vector
--   * combinational process
--   * case statement
--   * multiplexer behavior 
--   * clocked process
--   * register behavior
--
-- The circuit has four 8-bits inputs:

--   data0
--   data1
--   data2
--   data3
--
-- A 2-bit select signal chooses one of them.
--
-- The selected value is not sent directly to the output.
-- Instead, it is stored into a register on the rising edge
-- of the clock.
--
-- This is similar to what happens in the CPU datapath:
--
--   combinational logic chooses a value
--   then a register stores that value

------------------------------------------------------------------------------------?
entity mux_register is

    port(
        clk    : in std_logic;
        reset  : in std_logic;

        select_in   : in std_logic_vector(1 downto 0);

        data0  : in std_logic_vector(7 downto 0);
        data0  : in std_logic_vector(7 downto 0);
        data0  : in std_logic_vector(7 downto 0);
        data0  : in std_logic_vector(7 downto 0);

        output_reg  : out std_logic_vector(7 downto 0);
    );

end mux_register;

architecture Behavioral of mux_register is

    -- This signal stores the output of the multiplexer
    -- before it reaches the register.
    signal mux_output : std_logic_vector(7 downto 0);

    -- Internal register signal
    signal reg_value : std_logic_vector(7 downto 0);

begin

    ---------------------------------------------------------------------
    -- COMBINATIONAL MULTIPLEXER
    ---------------------------------------------------------------------
    --
    -- This process reacts whenever any input used inside it
    -- changes.
    --
    -- The selected input is copied into mux_output.
    ---------------------------------------------------------------------

    process(select_in, data0, data1, data2, data3)
    begin

        case select_in is

            when "00" =>
                mux_output <= data0;

            when "01" =>
                mux_output <= data1;

            when "10" =>
                mux_output <= data2;

            when "11" =>
                mux_output <= data3;

            when others =>
                -- This branch is technically unreachable
                -- because select_in has exactly 2 bits,
                -- but including "others" is good practice.
                mux_output <= (others => '0');

        end case;

    end process;


    ---------------------------------------------------------------------
    -- REGISTER
    ---------------------------------------------------------------------
    --
    -- On every rising clock edge:
    --
    --   reset = '1' -> register becomes 00000000
    --   otherwise.  -> register stores mux_output
    ---------------------------------------------------------------------

    process(clk)
    begin

        if rising_edge(clk) then

            if reset = '1' then

                reg_value <= (others => '0');
            
            else

                reg_value <= mux_output;

            end if;

        end if;

    end process;


    ---------------------------------------------------------------------
    -- OUTPUT
    ---------------------------------------------------------------------

    output_reg <= reg_value;


end Behavioral;

