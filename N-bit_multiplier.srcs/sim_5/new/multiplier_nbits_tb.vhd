library IEEE;
use IEEE.Std_logic_1164.all;
use IEEE.Numeric_Std.all;

entity multiplier_nbits_tb is
end;

architecture bench of multiplier_nbits_tb is

    -- signals, components..
    constant N: integer := 3;
    -- num of combination for each N bit number:
    constant num_of_combination: integer := (2**N)-1;

  component multiplier_nbits
      generic (N : INTEGER := N);
      port (
          A : in STD_LOGIC_VECTOR(N - 1 downto 0);
          B : in STD_LOGIC_VECTOR(N - 1 downto 0);
          multiplier_out : out STD_LOGIC_VECTOR(2 * N - 1 downto 0)
      );
  end component;

  signal A: STD_LOGIC_VECTOR(N - 1 downto 0);
  signal B: STD_LOGIC_VECTOR(N - 1 downto 0);
  signal multiplier_out: STD_LOGIC_VECTOR(2 * N - 1 downto 0) ;

begin

  -- Insert values for generic parameters !!
  uut: multiplier_nbits generic map ( N              =>  N)
                           port map ( A              => A,
                                      B              => B,
                                      multiplier_out => multiplier_out );

  stimulus: process
  begin
  
  report "Starting test";
  
    A <= (others=>'1');
    B <= (others=>'1');

    report "A and B set to 1";
    
    wait for 100ns;
    
    report "Output is " & integer'image(to_integer(unsigned(multiplier_out)));


    wait;
  end process;


end;


--    A <= std_logic_vector(to_unsigned(A_value, A'length));
--    B <= std_logic_vector(to_unsigned(B_value, B'length));
    
--    product <= unsigned(A)*unsigned(B);
--    expected_output := std_logic_vector(to_unsigned(A_value * B_value, expected_output'length));
    
--    assert (multiplier_out = expected_output)
--    report "Output mismatch - when input A = " & integer'image(A_value) & " and B = " & integer'image(B_value)
--    severity error;

--    for A_value in 0 to num_of_combination loop
--        for B_value in 0 to num_of_combination loop
            
--            -- set uut inputs to A/B_value by converting the int value to a N wide vector:
--            A <= std_logic_vector(to_unsigned(A_value, A'length));
--            B <= std_logic_vector(to_unsigned(B_value, B'length));
            
--              wait for 10ps;
--            -- expected output is of size 2N (same as multiplier_out):
--            expected_output := std_logic_vector(to_unsigned(A_value * B_value, expected_output'length));
            
--            assert (multiplier_out = expected_output)
--            report "Output mismatch - when input A = " & integer'image(A_value) & " and B = " & integer'image(B_value)
--            severity failure;
            
--        end loop;
--    end loop;
