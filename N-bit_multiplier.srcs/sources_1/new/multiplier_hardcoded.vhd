library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity multiplier_nbits is
    generic (
        n : INTEGER := 3
    );
    port (
        A : in STD_LOGIC_VECTOR (n - 1 downto 0);
        B : in STD_LOGIC_VECTOR (n - 1 downto 0);
        multiplier_output : out STD_LOGIC_VECTOR (2 * n downto 0) -- max output length = 2*n
    );
end multiplier_nbits;

architecture Behavioral of multiplier_nbits is

    -- input values to one adder block:
    signal adder_input_A : STD_LOGIC_VECTOR(n - 1 downto 0) := (others => '0');
    signal adder_input_B : STD_LOGIC_VECTOR(n - 1 downto 0) := (others => '0');
    --! input values for the second adder block:
    signal adder_input_A2 : STD_LOGIC_VECTOR(n - 1 downto 0) := (others => '0');
    signal adder_input_B2 : STD_LOGIC_VECTOR(n - 1 downto 0) := (others => '0');
    -- output value from one adder block (n-1 sum bits + Cout):
    signal adder_output : STD_LOGIC_VECTOR(n downto 0) := (others => '0');
    --! output value for the second adder block:
    signal adder_output2 : STD_LOGIC_VECTOR(n downto 0) := (others => '0');

    component FullAdder_nbits
        generic (
            num_of_bit : INTEGER := n
        );
        port (
            A : in STD_LOGIC_VECTOR(num_of_bit - 1 downto 0);
            B : in STD_LOGIC_VECTOR(num_of_bit - 1 downto 0);
            Cin : in STD_LOGIC;
            Sum : out STD_LOGIC_VECTOR(num_of_bit - 1 downto 0);
            Cout : out STD_LOGIC
        );
    end component;

begin

    FA1 : FullAdder_nbits
    port map(
        A => adder_input_A,
        B => adder_input_B,
        Cin => '0',
        Sum => adder_output(n - 1 downto 0),
        Cout => adder_output(n)
    );

    FA2 : FullAdder_nbits
    port map(
        A => adder_input_A2,
        B => adder_input_B2,
        Cin => '0',
        Sum => adder_output2(n - 1 downto 0),
        Cout => adder_output2(n)
    );

    -- wait for 1 ps;

    -- always first bit of multiplier output is the first AND gate output:
    -- multiplier_output(0) <= adder_input_A(0);
    -- -- right shift:
    -- adder_input_A <= '0' & adder_input_A(n - 1 downto 1);

    --! all signals that affect the output are included in the sensitivity list. 
    process (adder_input_A, adder_input_B, adder_input_A2, adder_input_B2)
        variable adder_input_A_index : INTEGER := 0;
        variable adder_input_B_index : INTEGER := 0;
        variable multipliter_index : INTEGER := 0;
        -- -- max number of adder needed for nbit multiplier must be = n-1:
        -- variable adder_counter : INTEGER := 0;
        -- -- max number of adder outputs needed for nbit multiplier must be = n (n-1 sum bits + Cout):
        -- variable adder_output_index : INTEGER := 0;
    begin
        for B_index in 0 to n - 1 loop

            for A_index in 0 to n - 1 loop
                -- if this is the first adder:
                if B_index = 0 then
                    -- Calculate B0 * A:
                    adder_input_B(adder_input_B_index) <= A(A_index) and B(B_index);
                    -- Calculate B1 * A:
                    -- we only update A input with the AND gate output if this is the first adder:
                    adder_input_A(adder_input_A_index) <= A(A_index) and B(B_index + 1);

                    -- take first AND gate output to final output:
                    multiplier_output(multipliter_index) <= adder_input_B(0);
                    adder_input_B <= '0' & adder_input_B(n - 1 downto 1);

                    adder_input_A_index := adder_input_A_index + 1;
                    

                    -- for every thing else:
                elsif (B_index /= 1) then
                    -- Calculate B2 * A then B3 *A and so on:
                    adder_input_B2(adder_input_B_index) <= A(A_index) and B(B_index);
                    -- take first bit from adder output to final multiplier output:
                    multiplier_output(multipliter_index) <= adder_output2(0);
                    adder_output2 <= '0' & adder_output2(n - 1 downto 1);

                end if;

                adder_input_B_index := adder_input_B_index + 1;
                multipliter_index := multipliter_index + 1;

            end loop; -- end A_index loop

            --wait for 1 ps;

            -- reset the index for the next iteration:
            adder_input_A_index := 0;
            adder_input_B_index := 0;

        end loop; -- end B_index loop
    end process;

end Behavioral;