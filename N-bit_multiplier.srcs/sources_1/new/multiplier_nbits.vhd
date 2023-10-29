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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity multiplier_nbits is
    Port ( A : in STD_LOGIC_VECTOR (1 downto 0);
           B : in STD_LOGIC_VECTOR (1 downto 0);
           S : out STD_LOGIC_VECTOR (3 downto 0)
           );
end multiplier_nbits;

architecture Behavioral of multiplier_nbits is
    
    signal andgate_1 : STD_LOGIC := '0';
    signal andgate_2 : STD_LOGIC := '0';
    signal andgate_3 : STD_LOGIC := '0';
    signal andgate_4 : STD_LOGIC := '0';
    
    signal internal_sum : std_logic_vector (1 downto 0);
        
    COMPONENT FullAdder_nbits 
            generic (
                num_of_bit: integer := 2 
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

    andgate_1 <= A(0) AND B(0);
    andgate_2 <= A(0) AND B(1);
    andgate_3 <= A(1) AND B(0);
    andgate_4 <= A(1) AND B(1);
    
    S(0) <= andgate_1;
    
        FA: FullAdder_nbits
        port map (
            A(0)    => andgate_2,
            A(1)    => andgate_4,
            B(0)    => andgate_3,
            B(1)    => '0',
            Cin  => '0',
            Sum  => internal_sum,
            Cout => S(3)
        );
        
        S(1) <= internal_sum(0);
        S(2) <= internal_sum(1);
    

end Behavioral;
