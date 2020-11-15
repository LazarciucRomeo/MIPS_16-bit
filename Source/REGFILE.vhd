----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/13/2020 02:45:51 PM
-- Design Name: 
-- Module Name: REGFILE - Behavioral
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

entity REGFILE is
    Port ( RegWr : in STD_LOGIC;
           RA1 : in  STD_LOGIC_VECTOR (2 downto 0);
           RA2 : in  STD_LOGIC_VECTOR (2 downto 0);
        WA : in STD_LOGIC_VECTOR (2 downto 0);
            CE:in STD_LOGIC;
          reset:in STD_LOGIC;
           clk : in STD_LOGIC;
          Digits: out STD_LOGIC_VECTOR(15 downto 0);
          WD : in STD_LOGIC_VECTOR (15 downto 0);
          Digits2:out STD_LOGIC_VECTOR(15 downto 0));
end REGFILE;

architecture Behavioral of REGFILE is
signal adunare_RD:STD_LOGIC_VECTOR(15 downto 0);
signal count3:STD_LOGIC_VECTOR(2 downto 0);
--signal WDsemnal: STD_LOGIC_VECTOR(15 downto 0);
  


signal  RD1 :  STD_LOGIC_VECTOR (15 downto 0);
 signal  RD2 :  STD_LOGIC_VECTOR (15 downto 0);
--signal Digits:STD_LOGIC_VECTOR (15 downto 0);
type ram_array is array(0 to 255) of STD_LOGIC_VECTOR(15 downto 0);
signal RAM : ram_array :=(
B"000_000_000_000_0_001", 
B"000_000_000_000_0_011", 
B"000_000_000_000_0_001", 
B"000_000_000_010_0_011", 
B"000_000_010_011_0_100",
B"000_000_010_011_0_101", 
B"000_000_010_011_0_110",
B"000_000_000_010_1_111", 
 
others=>x"AAAA"
);
begin
--process(clk,count3,CE)
--begin 
--if rising_edge(clk) then
--if CE='1' then
--        count3<=count3+1;
--        end if;
--        if(reset='1') then
--        count3<="000";
--      end if;
--      end if;
--  end process;
--  RA1 <= count3;
--  RA2 <= count3;
--  WA <= count3;

process(clk)
begin
if rising_edge(clk) then
    if RegWr = '1' and CE='1' then
            RAM(conv_integer(WA)) <= WD;
     end if;
end if;
end process;

  
RD1 <= RAM(conv_integer(RA1));
RD2 <= RAM(conv_integer(RA2));

Digits<=RD1;
 Digits2<=RD2;

end Behavioral;
                                                                   --  BLOC RAM
   
--entity REGFILE is
--    Port ( Wr : in STD_LOGIC;
--           CE: in STD_LOGIC;
--           clk : in STD_LOGIC;
--           En : in STD_LOGIC;
--           Digits : out STD_LOGIC_VECTOR(15 downto 0);
--           reset : in STD_LOGIC
--           );
--end REGFILE;

--architecture Behavioral of REGFILE is
--signal WA :  STD_LOGIC_VECTOR (3 downto 0);
--signal WD :  STD_LOGIC_VECTOR (15 downto 0);
--signal rd : std_logic_vector(15 downto 0);
--type ram_array is array(0 to 255) of STD_LOGIC_VECTOR(15 downto 0);
--signal RAM : ram_array :=(
--B"000_001_010_011_0_000", --add $1,$2,$3
--B"000_001_010_011_0_001", --sub $1,$2,$3
--B"000_001_000_010_1_010", --sll $1,$0,$2
--B"000_001_000_010_1_011", --srl $1,$0,$2
--B"000_001_010_011_0_100", --and $1,$2,$3
--B"000_001_010_011_0_101", --or $1,$2,$3
--B"000_001_010_011_0_110", --xor $1,$2,$3
--B"000_001_000_010_1_111", --sra $1,$0,$2  
----Tip I
--B"001_001_010_0000001", -- addi  $1,$2,1     
--B"010_001_010_0000001", -- lw   $2,imm($1)
--B"011_001_010_0000001", -- sw   $2,imm($1)
--B"100_001_010_0000001", -- beq  $1,$2,1
--B"101_001_010_0000111", -- andi $1,$2,7
--B"110_001_010_0000001", --xori  $1,$2,1  
----Tip J
--B"111_0000000000001",   --j target_address
--others=>x"AAAA"
--);

--signal count4:STD_LOGIC_VECTOR(3 downto 0):="0000";
--signal shiftrd : std_logic_vector(15 downto 0);
--begin

--process(clk, count4, CE, reset)
--begin
--   if clk='1' and clk'event then
--    if CE='1' then
--        count4 <= count4 + 1;
--    end if;
--     if reset='1' then
--        count4 <= "0000";
--    end if;
   
--    end if;
--end process;
--WA <= count4;

--process(clk)
--begin
--    if(clk'event and clk = '1') then
--        if(en = '1') then
--            if(Wr = '1') then
--                RAM(conv_integer(unsigned(WA))) <= WD;
--                rd <= WD;
--            else
--                rd <= RAM(conv_integer(unsigned(WA)));
--            end if;
--        end if;
--    end if;
--end process;
--shiftrd <= rd(13 downto 0) & "00";
--WD <= shiftrd;
--Digits <= shiftrd;
--end Behavioral;


   