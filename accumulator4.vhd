library IEEE:
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

-- COEN 316 Weekend Mini-Project:
-- 4-bit Accumulator with Load, Add, Clear, and Hold
--
-- This combines several VHDL ideas that shows up often in CPU/datapath design:
--
--  * entity / architecture
--  * std_logic and std_logic_vector
--  * unsigned arithmetic
--  * clocked processes
--  * registers
--  * control signals
--  * simple signals
--
-- On each rising edge of the clock:
--
--  clear = '1' -> accumulator becomes 0000
--  load  = '1' -> accumulator loads data_in
--  add   = '1' -> accumulator + data_in
--  otherwise.  -> accumulator keeps its old value
--
-- Priority:
--
--  clear > load > add > hold

entity accumulator4 is
    
    port(
        clk   : in std_logic;
        clear : in std_logic;
        load  : in std_logic;
        add   : in std_logic;

        -- 4-bit input value
        data_in : in std_logic_vector(3 downto 0);

        -- Current value stored in the accumulator
        acc_out : out std_logic_vector(3 downto 0)
    );

end accumulator4;

architecture Behavioral of accumulator4 is

    -- Internal register
    --
    -- We use unsigned internally because arithmetic
    -- such as addition is easier with unsigned values.
    signal acc_reg : unsigned(3 downto 0) := (others => '0');

begin

    -------------------------------------------------------------
    -- CLOCKED PROCESS
    -------------------------------------------------------------
    --
    -- This process runs whenever clk changes.
    -- We only perform register updates on the rising edge.
    -------------------------------------------------------------

    process(clk)
    begin

        if rising_edge(clk) then

            -----------------------------------------------------
            -- CLEAR
            -----------------------------------------------------
            --
            -- Highest priority operation.
            -----------------------------------------------------
            if clear = '1' then

                acc_reg <= (others => '0');


            -----------------------------------------------------
            -- LOAD
            -----------------------------------------------------
            --
            -- data_in is std_logic_vector.
            -- acc_reg is unsigned.
            -- Convert before assigning.
            -----------------------------------------------------
            elsif load = '1' then

                acc_reg <= unsigned(data_in);


            -----------------------------------------------------
            -- ADD
            -----------------------------------------------------
            --
            -- accumulator = accumulator + input
            -----------------------------------------------------
            elsif add = '1' then
                acc_reg <= acc_reg + unsigned(data_in);


            -----------------------------------------------------
            -- HOLD
            -----------------------------------------------------
            --
            -- No assignment means the register keeps
            -- its previous value
            -----------------------------------------------------
            else
                null;

            end if;
        end if;
    end process;

    -------------------------------------------------------------
    -- OUTPUT CONNECTION
    -------------------------------------------------------------
    --
    -- Convert the internal unsigned register back into
    -- std_logic_vector for the output port.
    -------------------------------------------------------------

    acc_out <= std_logic_vector(acc_reg);
end Behavioral;