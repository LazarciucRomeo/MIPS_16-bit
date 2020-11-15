----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 27.03.2020 16:25:25
-- Design Name: 
-- Module Name: InstructionFetch - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL; 

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity InstructionFetch is
  Port ( 
         JumpA:in STD_LOGIC_VECTOR(15 downto 0);
         PCSrcA:in  STD_LOGIC_VECTOR(15 downto 0);
         clk : in STD_LOGIC;
          Jump: in STD_LOGIC;
          PCSrc: in STD_LOGIC;
         Instructiune: out STD_LOGIC_VECTOR(15 downto 0);
          enable: STD_LOGIC;
            reset: STD_LOGIC;
        PC: out STD_LOGIC_VECTOR(15 downto 0)
        );
end InstructionFetch;

architecture Behavioral of InstructionFetch is

signal program_count: STD_LOGIC_VECTOR(15 downto 0) :="0000000000000000";
signal mux1:STD_LOGIC_VECTOR(15 downto 0) :="0000000000000000"; 
signal iesire_muxfinal:STD_LOGIC_VECTOR(15 downto 0) :="0000000000000000";

type ram_array is array(0 to 255) of STD_LOGIC_VECTOR(15 downto 0);
signal RAM : ram_array :=(
B"000_001_010_011_0_000", --add $1,$2,$3
B"000_001_010_011_0_001", --sub $1,$2,$3 
B"000_001_000_010_1_010", --sll $1,$0,$2
B"000_001_000_010_1_011", --srl $1,$0,$2
B"000_001_010_011_0_100", --and $1,$2,$3
B"000_001_010_011_0_101", --or $1,$2,$3
B"000_001_010_011_0_110", --xor $1,$2,$3
B"000_001_000_010_1_111", --sra $1,$0,$2  
--Tip I
B"001_001_010_0000001", -- addi  $1,$2,1  
   
B"010_001_010_0000001", -- lw   $2,imm($1)
B"011_001_010_0000001", -- sw   $2,imm($1)
B"100_001_010_0000011", -- beq  $1,$2,3
B"101_001_010_0000111", -- andi $1,$2,7
B"110_001_010_0000001", --xori  $1,$2,1  
--Tip J
B"111_0000000000001",   --jm target_address
others=>x"AAAA"
); begin
 process (clk,enable,reset)
        begin
   if clk='1' and clk'event then
      if(enable = '1') then
        program_count <= iesire_muxfinal;
        end if;
      if(reset='1') then 
        program_count <= "0000000000000000";  
      end if;
      end if;
      end process;
      
      
      
      
Instructiune <= RAM(conv_integer(program_count(7 downto 0)));
PC<=program_count+1;
mux1 <= program_count+1 when PCSrc='0' else PCSrcA;
iesire_muxfinal <=mux1 when Jump='0' else JumpA;




end Behavioral;
