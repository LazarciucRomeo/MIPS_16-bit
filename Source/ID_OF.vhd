----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03.04.2020 12:55:33
-- Design Name: 
-- Module Name: ID_OF - Behavioral
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

entity ID_OF is
  Port ( 
  RegWrite: in STD_LOGIC;
  RData1:out STD_LOGIC_VECTOR(15 downto 0);
  RData2: out STD_LOGIC_VECTOR(15 downto 0);
  ExtendedImmediate:out STD_LOGIC_VECTOR(15 downto 0);
  func:out STD_LOGIC_VECTOR(2 downto 0);
  sa:out STD_LOGIC;
  clk: in STD_LOGIC;
  InstructiuneID:in STD_LOGIC_VECTOR(15 downto 0);
     RegDst: STD_LOGIC;
 enableID:STD_LOGIC;
  ExtOP: STD_LOGIC;
  WD_ID:in STD_LOGIC_VECTOR(15 downto 0)
  );
  
 end ID_OF;

architecture Behavioral of ID_OF is
signal IesireMux:STD_LOGIC_VECTOR(2 downto 0); 
--Semnale de control


  
 signal reset:STD_LOGIC;



component REGFILE is
    Port ( RegWr : in STD_LOGIC;
           RA1 : in  STD_LOGIC_VECTOR (2 downto 0);
           RA2 : in  STD_LOGIC_VECTOR (2 downto 0);
        WA : in STD_LOGIC_VECTOR (2 downto 0);
            CE:in STD_LOGIC;
        
           clk : in STD_LOGIC;
          Digits: out STD_LOGIC_VECTOR(15 downto 0);
          WD : in STD_LOGIC_VECTOR (15 downto 0);
          Digits2:out STD_LOGIC_VECTOR(15 downto 0));
end component;
begin
IesireMux <=InstructiuneID(9 downto 7)  when RegDst='0' else InstructiuneID(6 downto 4);
func<=InstructiuneID(2 downto 0);
sa<=InstructiuneID(3);

RegMap:REGFILE port map(RegWrite,InstructiuneID(12 downto 10 ),InstructiuneID(9 downto 7),IesireMux,enableID,clk,RData1,WD_ID,RData2);
 ExtendedImmediate<="0000000000000" & InstructiuneID(2 downto 0) when ExtOP='0' else "0000000000000" & InstructiuneID(2 downto 0);
end Behavioral;
