library IEEE;
use IEEE.Std_logic_1164.all;
use IEEE.Numeric_Std.all;

entity multiplier_nbits_tb is
end;

architecture bench of multiplier_nbits_tb is

  constant num_of_bit : integer := 2;

  component multiplier_nbits
   
      Port ( A : in STD_LOGIC_VECTOR (num_of_bit-1 downto 0);
             B : in STD_LOGIC_VECTOR (num_of_bit-1 downto 0);
             S : out STD_LOGIC_VECTOR ((num_of_bit*2)-1 downto 0)
             );
  end component;

  signal A: STD_LOGIC_VECTOR (num_of_bit-1 downto 0);
  signal B: STD_LOGIC_VECTOR (num_of_bit-1 downto 0);
  signal S: STD_LOGIC_VECTOR ((num_of_bit*2)-1 downto 0) ;

begin

  uut: multiplier_nbits port map ( A => A,
                                   B => B,
                                   S => S );

 stimulus: process
  
   
  variable num_of_combination : integer := (2**num_of_bit)-1;
  
  -- output is of size 2x number of bits:
  variable expected_sum : std_logic_vector(2*num_of_bit-1 downto 0) := (others => '0');
 
  begin

    for A_value in 0 to num_of_combination loop
        for B_value in 0 to num_of_combination loop
           
                -- convert A/B_value to unsigned (num_of_bits) bit number. We don't use signed values. 
                -- Then convert to std logic vector and asign to bus A/B.
                A <= std_logic_vector(to_unsigned(A_value, num_of_bit));
                B <= std_logic_vector(to_unsigned(B_value, num_of_bit));
               
                
                -- wait for results:
                wait for 10 ns;
                
                -- Calculate the expected sum. It should have '2 * num_of_bit' bits to avoid overflow.
                expected_sum := std_logic_vector(to_unsigned(A_value * B_value, 2 * num_of_bit));

    -- Check the result:
    -- Here we compare only the least significant 'num_of_bit' bits of the expected sum with S.
    -- Adjust the range if S has a different bit width.
--    assert expected_sum(num_of_bit * 2 - 1 downto num_of_bit) = S
--        report "Mismatch: expected: " & integer'image(to_integer(unsigned(expected_sum(num_of_bit * 2 - 1 downto num_of_bit))))  & ", got: " & integer'image(to_integer(unsigned(S)))
--        severity error;

                    
         end loop;
     end loop;
      
     report "Simulation finished !!"
     severity note;
     wait;
     
end process;

end;