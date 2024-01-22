library IEEE;
use IEEE.STD_LOGIC_1164.all;
use ieee.numeric_std.all;

entity multiplier_nbits is
    generic (N : INTEGER := 2);
    port (
        A : in STD_LOGIC_VECTOR(N - 1 downto 0);
        B : in STD_LOGIC_VECTOR(N - 1 downto 0);
        multiplier_out : out STD_LOGIC_VECTOR(2 * N - 1 downto 0)
    );
end multiplier_nbits;

architecture Behavioral of multiplier_nbits is

    -- signals, componenets import..
    signal result : STD_LOGIC_VECTOR(2 * N - 1 downto 0) := (others => '0');
    signal temp_result : STD_LOGIC_VECTOR(2 * N - 1 downto 0) := (others => '0');
    signal adder_input_A : STD_LOGIC_VECTOR(2 * N - 1 downto 0) := (others => '0');
    signal adder_input_B : STD_LOGIC_VECTOR(2 * N - 1 downto 0) := (others => '0');

    component FullAdder_nbits
        generic (num_of_bit : INTEGER := 2 * N);
        port (
            A : in STD_LOGIC_VECTOR (2 * N - 1 downto 0);
            B : in STD_LOGIC_VECTOR (2 * N - 1 downto 0);
            Cin : in STD_LOGIC;
            Sum : out STD_LOGIC_VECTOR (2 * N - 1 downto 0);
            Cout : out STD_LOGIC
        );
    end component;

begin
    -- logic, variables inside processes, port map to componenets..
    FA1 : FullAdder_nbits
    port map(
        A => adder_input_A,
        B => adder_input_B,
        Cin => '0',
        Sum => temp_result,
        Cout => open -- leave unconnected
    );

    mul_op : process
        -- variables if needed..
    begin
        wait for 1 ns;
        -- loop from LSB to MSB:
        for B_index in B'range loop
            -- Left-Shift op:
            if B_index /= B'length-1 then
                report "Current Result is " & INTEGER'image(to_integer(unsigned(result)));
                result <= result(result'length - 2 downto 0) & '0';
                report "New Result is " & INTEGER'image(to_integer(unsigned(result)));
    
                wait for 1 ns;
            end if;

            if B(B_index) = '1' then
                report "Bit is 1. Sending " & INTEGER'image(to_integer(unsigned(A))) & " to adder_input_A";
                -- Cast A from N to 2*N:
                adder_input_A <= STD_LOGIC_VECTOR(resize(unsigned(A), adder_input_A'length));
                adder_input_B <= result;

            else
                report "Bit is 0";
            end if;

            wait for 1 ns;
            
            report "Assigning temp result to result. Temp Result is " & INTEGER'image(to_integer(unsigned(temp_result)));
            result <= temp_result;

        end loop;
    end process mul_op;

     multiplier_out <= result;

end Behavioral;