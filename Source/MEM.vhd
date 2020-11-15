----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10.04.2020 20:11:51
-- Design Name: 
-- Module Name: MEM - Behavioral
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

entity MEM is
    Port ( AluRes: in STD_LOGIC_VECTOR(15 downto 0);
          RD2: in STD_LOGIC_VECTOR(15 downto 0);
           clk : in STD_LOGIC;
           MemWrite : in STD_LOGIC;
           enable: in STD_LOGIC;
        MemData: out STD_LOGIC_VECTOR(15 downto 0)
           );
end MEM;

architecture Behavioral of MEM is
type ram_array is array(0 to 128) of STD_LOGIC_VECTOR(15 downto 0);
signal RAM : ram_array :=(
B"000_000_000_000_0_001", 
B"000_000_000_000_0_011", 
B"000_000_000_000_0_100", 
B"000_000_000_010_0_011", 
B"000_000_010_011_0_100",
B"000_000_010_011_0_101", 
B"000_000_010_011_0_110",
B"000_000_000_010_1_111", 
 
others=>x"AAAA"

);
begin
process(clk,enable)
begin
if rising_edge(clk) then
    if(MemWrite = '1') and enable='1' then 
            RAM( conv_integer( AluRes( 7 downto 0) )) <= RD2;
     end if;
end if;
end process;
MemData<= RAM(conv_integer(AluRes(7 downto 0)));


end Behavioral;
