library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity multiplier_nbits_tb is
    -- Testbench doesn't have ports
end multiplier_nbits_tb;

architecture behavior of multiplier_nbits_tb is
    -- Component Declaration for the Unit Under Test (UUT)
    component multiplier_nbits
        generic (
            n : INTEGER := 3
        );
        port (
            A : in STD_LOGIC_VECTOR (n - 1 downto 0);
            B : in STD_LOGIC_VECTOR (n - 1 downto 0);
            multiplier_output : out STD_LOGIC_VECTOR (2 * n downto 0)
        );
    end component;

    -- Constants
    constant n : INTEGER := 3; -- Same as your generic parameter in multiplier_nbits

    -- Signals
    signal A : STD_LOGIC_VECTOR (n - 1 downto 0);
    signal B : STD_LOGIC_VECTOR (n - 1 downto 0);
    signal multiplier_output : STD_LOGIC_VECTOR (2 * n downto 0);
begin 
    -- Instantiate the Unit Under Test (UUT)
    uut: multiplier_nbits
        generic map (
            n => n
        )
        port map (
            A => A,
            B => B,
            multiplier_output => multiplier_output
        );


    -- Stimulus process
    stim_proc: process
    begin
        -- Apply inputs
        A <= "000";
        B <= "000";
        wait for 1 ns;

        A <= "001";
        B <= "010";
        wait for 1 ns;

        A <= "010";
        B <= "011";
        wait for 1 ns;

        A <= "100";
        B <= "101";
        wait for 1 ns;

        A <= "111";
        B <= "111";
        wait for 1 ns;

        -- Add more test cases as needed

        wait; -- will wait forever
    end process;
end behavior;
