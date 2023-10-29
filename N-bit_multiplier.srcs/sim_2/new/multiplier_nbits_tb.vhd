-- Testbench created online at:
--   https://www.doulos.com/knowhow/perl/vhdl-testbench-creation-using-perl/
-- Copyright Doulos Ltd

library IEEE;
use IEEE.Std_logic_1164.all;
use IEEE.Numeric_Std.all;

entity multiplier_nbits_tb is
end;

architecture bench of multiplier_nbits_tb is

  component multiplier_nbits
      Port ( A : in STD_LOGIC_VECTOR (1 downto 0);
             B : in STD_LOGIC_VECTOR (1 downto 0);
             S : out STD_LOGIC_VECTOR (3 downto 0)
             );
  end component;

  signal A: STD_LOGIC_VECTOR (1 downto 0);
  signal B: STD_LOGIC_VECTOR (1 downto 0);
  signal S: STD_LOGIC_VECTOR (3 downto 0) ;

begin

  uut: multiplier_nbits port map ( A => A,
                                   B => B,
                                   S => S );

  stimulus: process
  begin
  
    -- Put initialisation code here
         -- Test Case 1: 00, 00
        A <= "00";
        B <= "00";
        wait for 1 ns;
        
        -- Test Case 2: 00, 01
        A <= "00";
        B <= "01";
        wait for 1 ns;
        
        -- Test Case 3: 00, 10
        A <= "00";
        B <= "10";
        wait for 1 ns;
        
        -- Test Case 4: 00, 11
        A <= "00";
        B <= "11";
        wait for 1 ns;

        -- Test Case 5: 01, 00
        A <= "01";
        B <= "00";
        wait for 1 ns;

        -- Test Case 6: 01, 01
        A <= "01";
        B <= "01";
        wait for 1 ns;

        -- Test Case 7: 01, 10
        A <= "01";
        B <= "10";
        wait for 1 ns;

        -- Test Case 8: 01, 11
        A <= "01";
        B <= "11";
        wait for 1 ns;

        -- Test Case 9: 10, 00
        A <= "10";
        B <= "00";
        wait for 1 ns;

        -- Test Case 10: 10, 01
        A <= "10";
        B <= "01";
        wait for 1 ns;

        -- Test Case 11: 10, 10
        A <= "10";
        B <= "10";
        wait for 1 ns;

        -- Test Case 12: 10, 11
        A <= "10";
        B <= "11";
        wait for 1 ns;

        -- Test Case 13: 11, 00
        A <= "11";
        B <= "00";
        wait for 1 ns;

        -- Test Case 14: 11, 01
        A <= "11";
        B <= "01";
        wait for 1 ns;

        -- Test Case 15: 11, 10
        A <= "11";
        B <= "10";
        wait for 1 ns;

        -- Test Case 16: 11, 11
        A <= "11";
        B <= "11";
        wait for 1 ns;


    wait;
  end process;


end;