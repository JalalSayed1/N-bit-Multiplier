-------------------------------------------------------------------------------
-- File Information:
--   Title:           N-bit Multiplier Module
--   File Name:       multiplier_nbits.vhdl
--   Author:          Jalal and Tamim
--   Date Created:    29-Oct-2023
--   Last Modified:   29-Oct-2023
--   Vivado Version:    2020.2
--   Company:         QCG
--   Project:         [Project Name]
--   Target Device:   [Target FPGA/ASIC Device]
--   Tool Version:    [EDA Tool Version]

-------------------------------------------------------------------------------
-- Description:
--   This file contains the behavioral description of an 2-bit multiplier
--   module. The multiplier takes two bit unsigned binary numbers as input
--   and produces a 2N-bit unsigned binary product.

-------------------------------------------------------------------------------
-- Dependencies:
--   None.

-------------------------------------------------------------------------------
-- Revision History:
--   Rev 0.01 - 29-Oct-2023 - File created by [Your Name]

-------------------------------------------------------------------------------
-- Known Issues:
--   None.

-------------------------------------------------------------------------------
-- Usage:
--   To use this module, instantiate it in your top-level file and connect
--   the input and output ports accordingly. Example instantiation:
--
--   MULTIPLIER_NBITS u_mult (
--       .a (input_a),
--       .b (input_b),
--       .p (output_product)
--   );

-------------------------------------------------------------------------------
-- Copyright Notice:
--   Copyright (C) 2023 by [Your Name or Your Company]. All rights reserved.
-------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity multiplier_nbits is
    generic (
        n : integer := 3
    );
    Port ( A : in STD_LOGIC_VECTOR (n-1 downto 0);
           B : in STD_LOGIC_VECTOR (n-1 downto 0);
           S : out STD_LOGIC_VECTOR (2*n downto 0) -- max output length = 2*n
           );
end multiplier_nbits;

architecture Behavioral of multiplier_nbits is
    
    -- we need n*n and gates for n bit multiplier:
    signal and_gates_outputs : STD_LOGIC_VECTOR(n*n - 1 downto 0) := (others => '0');
    
    signal internal_sum : STD_LOGIC_VECTOR(n*n - 1 downto 0) := (others => '0');
    
        
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
    
    variable and_gates_outputs_index : integer := 0;
    
    begin
        
        for B_index in 0 to n loop
            for A_index in 0 to n loop
                and_gates_outputs(and_gates_outputs_index) <= A(A_index) AND B(B_index);
                and_gates_outputs_index := and_gates_outputs_index + 1;
            end loop;
        end loop;
       
    wait for 1 ps;
    end process;
    
    -- first AND gates output goes to final output directly:
    S(0) <= and_gates_outputs(0);
    
    nbit_adders_gen: for adder_index in 0 to n-1 generate
    
    process
       
    -- index start from 1 because first AND gate output maps directly to final output:
    variable and_gates_outputs_index : integer := 1;
    variable internal_sum : STD_LOGIC_VECTOR (n-1 downto 0);
--    variable adder_input : STD_LOGIC_VECTOR (n-1 downto 0);
    
    begin
    
    -- only for the first adder:
    if adder_index = 0 then
    
--        adder_input := and_gates_outputs(and_gates_outputs_index) & and_gates_outputs(and_gates_outputs_index+1);
    
        FA: FullAdder_nbits
        port map (
            A    => and_gates_outputs(and_gates_outputs_index) & and_gates_outputs(and_gates_outputs_index+1) & '0',
            B    => and_gates_outputs(and_gates_outputs_index+2) & and_gates_outputs(and_gates_outputs_index+3) & and_gates_outputs(and_gates_outputs_index+4),
            Cin  => '0',
            Sum  => internal_sum, -- start work from here for the internal wires for inter-adder interface 
            Cout => 
        );
        
        -- increment index by the number of bits we already used:
        and_gates_outputs_index := and_gates_outputs_index + 5;
            
    else
           
        FA: FullAdder_nbits
        port map (
            A(0)    => ,
            A(1)    => ,
            B(0)    => ,
            B(1)    => ,
            Cin  => '0',
            Sum  => ,
            Cout => 
        );
            
    end if;
    end process;
        
        
    
    end generate nbit_adders_gen;
        
    S(1) <= internal_sum(0);
    S(2) <= internal_sum(1);
    

end Behavioral;
