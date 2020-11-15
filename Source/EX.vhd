----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10.04.2020 16:46:38
-- Design Name: 
-- Module Name: EX - Behavioral
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

entity EX is
  Port ( 
         RD1:in STD_LOGIC_VECTOR(15 downto 0);
         RD2:in  STD_LOGIC_VECTOR(15 downto 0);
        sa : in STD_LOGIC;
      func : in STD_LOGIC_VECTOR(2 downto 0);
      Ext_Imm: in STD_LOGIC_VECTOR(15 downto 0);
       ALUSrc:in STD_LOGIC;
       AluOP: in STD_LOGIC_VECTOR(2 downto 0);
      zero :  out STD_LOGIC;
      
       
      
        AluRes: out STD_LOGIC_VECTOR(15 downto 0)
        );
end EX;

architecture Behavioral of EX is
signal iesire_mux : STD_LOGIC_VECTOR(15 downto 0);
signal iesire_case_2: STD_LOGIC_VECTOR(2 downto 0);
signal ALUCtrl:  STD_LOGIC_VECTOR(3 downto 0);
signal AluRezultat: STD_LOGIC_VECTOR(15 downto 0); 
begin
iesire_mux <= RD2 when ALUSrc='0' else Ext_Imm;
process(ALUCtrl,func,iesire_case_2)
begin
case AluOP is  
when "001" => ALUCtrl<= "0000";
when "010" => ALUCtrl<="0001" ;
when "011" => ALUCtrl<="0010" ;
when "100" => ALUCtrl<="0011" ;
when "101" => ALUCtrl<="0100" ;
when "110" => ALUCtrl<="0101" ;
when "111" => ALUCtrl<="0110" ;
        when others => case func is
        
                when "000" => ALUCtrl <= "0000";
                 when "001" => ALUCtrl<= "0111";
                  when "010" => ALUCtrl<= "1000";
                   when "011" => ALUCtrl<= "1001";
                    when "100" => ALUCtrl<= "0100";
                     when "101" => ALUCtrl<= "1010";
                      when "110" =>  ALUCtrl<= "0101";
                       when others => ALUCtrl<= "1011";
                       end case;
                     end case;
       
                  
                       
 
end process;
process(AluCtrl)
begin
  case ALUCtrl is 
         when "0000" => AluRezultat <=RD1+iesire_mux;
          when "0001" => AluRezultat <=Ext_Imm+RD1;--activare zero 1
           when "0010" => AluRezultat <=Ext_Imm+RD1;--zeroooo 1
            when "0011" => AluRezultat <= RD1-RD2 ;--activare zero 1
             when "0100" => AluRezultat <=RD1 and iesire_mux;
              when "0101" => AluRezultat <=RD1 xor iesire_mux;
               when "0110" => AluRezultat <=x"0001";
                when "0111" => AluRezultat <=RD1-iesire_mux;
                 when "1000" => AluRezultat <=RD1(14 downto 0) & '0' ;
                  when "1001" => AluRezultat <='0' & RD1(15 downto 1);
                   when "1010" => AluRezultat<=RD1 or RD2;
                    when others =>  AluRezultat <=RD1(0) & RD1(15 downto 1) ;
                    end case;
                    AluRes<= AluRezultat ;
  if(AluRezultat = x"0000") then  zero <='1'; else zero<='0';
  end if; 
 if(AluRezultat=x"0000" ) then zero<='1'; else zero<='0';
 end if;
 
end process;

end Behavioral;
