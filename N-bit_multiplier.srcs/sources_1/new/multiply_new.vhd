library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.ALL;

entity multiplier_nbits is
  generic (N : integer := 16);
  port (
    A : in std_logic_vector(N-1 downto 0);
    B : in std_logic_vector(N-1 downto 0);
    multiplier_out : out std_logic_vector(2*N-1 downto 0)
  );
end multiplier_nbits;

architecture Behavioral of multiplier_nbits is

    -- signals, componenets import..
    signal result: std_logic_vector(2*N-1 downto 0) := (others => '0');
    signal adder_input_A: std_logic_vector(N-1 downto 0) := (others => '0');
    signal adder_input_B: std_logic_vector(N-1 downto 0) := (others => '0');
    
    component FullAdder_nbits
        generic (num_of_bit : integer := N);
        port (
            A    : in  STD_LOGIC_VECTOR (N-1 downto 0);
            B    : in  STD_LOGIC_VECTOR (N-1 downto 0);
            Cin  : in  STD_LOGIC;
            Sum  : out STD_LOGIC_VECTOR (N-1 downto 0);
            Cout : out STD_LOGIC
        );
    end component;

begin

    -- logic, variables inside processes, port map to componenets..

    FA1: FullAdder_nbits
    port map(
        A => adder_input_A,
        B => adder_input_B,
        Cin => '0',
        Sum => result(N-1 downto 0),
        Cout => open -- leave unconnected
    );

    add_op: process (A, B)
        -- variables if needed..
    begin
        -- loop from LSB to MSB:
        for B_index in N-1 downto 0 loop
            if B(B_index) = '1' then
                -- add operation:
                adder_input_A <= A;
                adder_input_B <= result(N-1 downto 0);
                
                -- left shift:
                result <= result(result'length-2 downto 0) & '0';
s                
            -- right shift operation:
--            result <= result(result'length - 1) & result(result'length-1 downto 1);
            
            end if;

        end loop;
        
    end process add_op;
    
    multiplier_out <= result;

end Behavioral;
