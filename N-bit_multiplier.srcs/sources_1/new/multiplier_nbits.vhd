library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity multiplier_nbits is
    generic (
        n : integer := 3
    );
    Port ( A : in STD_LOGIC_VECTOR (n-1 downto 0);
           B : in STD_LOGIC_VECTOR (n-1 downto 0);
           multiplier_output : out STD_LOGIC_VECTOR (2*n downto 0) -- max output length = 2*n
           );
end multiplier_nbits;

architecture Behavioral of multiplier_nbits is
    
    signal adder_input_A : STD_LOGIC_VECTOR(n-1 downto 0) := (others => '0');
    signal adder_input_B : STD_LOGIC_VECTOR(n-1 downto 0) := (others => '0');
    -- output value from one adder block (n-1 sum bits + Cout):
    signal adder_output : STD_LOGIC_VECTOR(n downto 0) := (others => '0');
        
    COMPONENT FullAdder_nbits 
            generic (
                num_of_bit: integer := n
            );
            Port (
            A    : in  std_logic_vector(num_of_bit-1 downto 0) ;
            B    : in  std_logic_vector(num_of_bit-1 downto 0);
            Cin  : in  STD_LOGIC;
            Sum  : out  std_logic_vector(num_of_bit-1 downto 0);
            Cout : out STD_LOGIC
        );
    end COMPONENT;
    
begin
    process
        variable adder_input_A_index : integer := 0;
        variable adder_input_B_index : integer := 0;
        -- max number of adder needed for nbit multiplier must be = n-1:
        variable adder_counter : integer := 0;
        -- max number of adder outputs needed for nbit multiplier must be = n (n-1 sum bits + Cout):
        variable adder_output_index : integer := 0;
    begin
        -- make adder inputs (AND gates outputs):

        for B_index in 0 to n-1 loop
            for A_index in 0 to n-1 loop
            
                if B_index = 0 then
                    -- Calculate B0 * A
                    adder_input_A(adder_input_A_index) <= A(A_index) AND B(B_index);
                    -- Calculate B1 * A
                    adder_input_B(adder_input_B_index) <= A(A_index) AND B(B_index+1);
                
                -- for every thing else:
                elsif (B_index /= 1) then
                    -- Calculate B2 * A then B3 *A and so on:
                    adder_input_B(adder_input_B_index) <= A(A_index) AND B(B_index);
                end if;
                
                adder_input_A_index := adder_input_A_index + 1; -- might have to be inside the if statement
                adder_input_B_index := adder_input_B_index + 1;
                
            end loop; -- end A_index loop
        
        wait for 1 ps;

        -- reset the index for the next iteration:
        adder_input_A_index := 0;
        adder_input_B_index := 0;

        -- map first AND gate output to multiplier output:
        if adder_counter = 0 then
            multiplier_output(adder_counter) <= adder_input_A(0);
            -- shift adder_input_A and add 0 to the MSB (this is the A input to the first adder):
            -- adder_input_A <= adder_input_A >> 1; -- this might be wrong
            adder_input_A <= '0' & adder_input_A(n-1 downto 1);
        else
            -- map first adder output to multiplier output:
            multiplier_output(adder_counter) <= adder_output(0);
        end if;

        -- perform addition:
        FA: FullAdder_nbits
            port map (
                A    => adder_input_A,
                B    => adder_input_B,
                Cin  => '0',
                Sum  => adder_output(n-1 downto 0),
                Cout => adder_output(n)
            );

        wait for 1 ps;

        -- map output from previous adder to input of next adder:
        if adder_counter \= n-1 then
            adder_input_A <= adder_output(n downto 1);

        else
            -- map last adder output to multiplier output:
            for multiplier_output_index in adder_counter to 2*n-1 loop
                multiplier_output(multiplier_output_index) <= adder_output(adder_output_index);
                adder_output_index := adder_output_index + 1;
            end loop;

        end if;

        -- decrement the adder counter:
        adder_counter := adder_counter + 1;


        end loop; -- end B_index loop
    end process;
    
end Behavioral;
