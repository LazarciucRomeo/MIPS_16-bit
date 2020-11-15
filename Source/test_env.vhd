----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/28/2020 12:41:25 AM
-- Design Name: 
-- Module Name: test_env - Behavioral
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

entity test_env is
    Port ( clk : in STD_LOGIC;
           btn : in STD_LOGIC_VECTOR(4 downto 0);
           sw : in STD_LOGIC_VECTOR(15 downto 0);
           led : out STD_LOGIC_VECTOR (15 downto 0);
           an : out STD_LOGIC_VECTOR (3 downto 0);
           cat : out STD_LOGIC_VECTOR (6 downto 0));
end test_env;

architecture Behavioral of test_env is

signal S : STD_LOGIC_VECTOR(15 downto 0);
signal alu : STD_LOGIC_VECTOR(15 downto 0);
signal rom1 : STD_LOGIC_VECTOR(15 downto 0);
signal enable : STD_LOGIC;
signal enable2:STD_LOGIC;
signal reset:STD_LOGIC;
signal count_pt_memoria_ram: STD_LOGIC_VECTOR(3 downto 0) :="0000";
signal count_2 : STD_LOGIC_VECTOR(1 downto 0) :="00";
signal count_4 : STD_LOGIC_VECTOR(3 downto 0) :="0000";
signal memory_counter_8bit : STD_LOGIC_VECTOR(7 downto 0) :=x"00";
signal iesire_regfile: STD_LOGIC_VECTOR(15 downto 0);
signal Digits:  STD_LOGIC_VECTOR(15 downto 0);
signal shiftl:  STD_LOGIC_VECTOR(15 downto 0);
signal output_pt_RAM:STD_LOGIC_VECTOR(15 downto 0); 
--pentru IF (nu toate,pot folosi din celelalte)


signal Jump : STD_LOGIC;
signal  PCSrc: STD_LOGIC;
signal JumpA: STD_LOGIC_VECTOR(15 downto 0):=x"0000";
signal  PCSrcA: STD_LOGIC_VECTOR(15 downto 0);
signal Instructiune: STD_LOGIC_VECTOR(15 downto 0);
signal PC: STD_LOGIC_VECTOR(15 downto 0);
-- semnale pentru lab 6 ID_OF
signal RegDst: STD_LOGIC:='0';
signal ExtOp: STD_LOGIC:='0';
signal AluSrc: STD_LOGIC:='0';
signal Branch: STD_LOGIC:='0';
signal JumpU: STD_LOGIC:='0';
signal ALUOp: STD_LOGIC_VECTOR(2 downto 0);
signal MemWrite: STD_LOGIC:='0';
signal MemtoReg: STD_LOGIC:='0';
signal RegWrite: STD_LOGIC:='0';
signal RD1: STD_LOGIC_VECTOR(15 downto 0);
signal RD2: STD_LOGIC_VECTOR(15 downto 0);
signal ExtendedImmediate:STD_LOGIC_VECTOR(15 downto 0); 
signal func :STD_LOGIC_VECTOR(2 downto 0);
signal sa:STD_LOGIC;
signal WD: STD_LOGIC_VECTOR(15 downto 0);
signal Afisare_SSD :STD_LOGIC_VECTOR(15 downto 0);
--Semnale pentu lab 7-8 terminarea procesorului 
signal MemData:STD_LOGIC_VECTOR(15 downto 0);
signal AluRes: STD_LOGIC_VECTOR(15 downto 0); 
signal iesire_WB: STD_LOGIC_VECTOR(15 downto 0);
signal zero : STD_LOGIC;


--type MEM_256x16 is array (0 to 255) of std_logic_vector(0 to 15);
--signal RAM : MEM_256x16 :=(
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

component MPG
    port(clock, btn : in STD_LOGIC;
            en: out STD_LOGIC);
end component;

component SSD
    port(   sel : in STD_LOGIC_VECTOR(15 downto 0);
            clk : in STD_LOGIC;
            an : out STD_LOGIC_VECTOR (3 downto 0);
            cat : out STD_LOGIC_VECTOR (6 downto 0));
end component; 
--component REGFILE
--    Port ( RegWr : in STD_LOGIC;
--          CE:in STD_LOGIC;
--           reset:in STD_LOGIC;
--           clk : in STD_LOGIC;
--          Digits: out STD_LOGIC_VECTOR(15 downto 0));
--end component; 
component REGFILE 
    Port ( Wr : in STD_LOGIC;
           CE: in STD_LOGIC;
           clk : in STD_LOGIC;
           En : in STD_LOGIC;
           Digits : out STD_LOGIC_VECTOR(15 downto 0);
           reset : in STD_LOGIC
           );
end component;
component InstructionFetch is
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
end component;
component ID_OF is
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
  ExtOP:STD_LOGIC;
  WD_ID:in STD_LOGIC_VECTOR(15 downto 0)
  );
  
 end component;
component MEM is
    Port ( AluRes: in STD_LOGIC_VECTOR(15 downto 0);
          RD2: in STD_LOGIC_VECTOR(15 downto 0);
           clk : in STD_LOGIC;
           MemWrite : in STD_LOGIC;
           enable: in STD_LOGIC;
        MemData: out STD_LOGIC_VECTOR(15 downto 0)
           );
end component;
component EX is
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
end component;
begin



--process (clk,btn,sw,S)
--begin
--   if clk='1' and clk'event then
--   if enable='1' then
--      if sw(0)='1' then
--         S <= S + 1;
--      else
--         S <= S - 1;
--      end if;
--   end if;
--   end if;
--end process;

                                                          --ALU 
--  A: mpg port map(clk,btn(0),enable);
--  B1: SSD port map(alu,clk,an,cat);
--  led(7)<='1' when alu =x"0000" else '0';

-- process(clk)
-- begin
 
--  if clk'event and clk='1' then
  
-- if enable='1' then
--   count_2 <=count_2 +1; 
-- end if;
 
-- end if;
-- end process;
-- process(count_2 ,sw)
-- begin 
-- case count_2  is
--  when "00"   => alu   <=x"000" &( (sw(7 downto 4)+ sw(3 downto 0)));
--  when "01"   => alu   <=x"000" & ((sw(3 downto 0)- sw(7 downto 4)));
--  when "10"   => alu   <= x"00" & sw(5 downto 0 ) & "00";
--  when others => alu   <="00"& (x"00" & sw(7 downto 2));
-- end case;
-- end process;

                                                           --BLOC MEMORIE ROM
--process(clk, memory_counter_8bit, enable)
--begin
--    if clk='1' and clk'event then
--    if enable='1' then
--        memory_counter_8bit <= memory_counter_8bit + 1;
--    end if;
--    end if;
--end process;

--rom1 <= ROM(conv_integer(memory_counter_8bit));

--B: SSD port map(rom1, clk ,an ,cat);
                                                               --BLOC REFFILE
--A1: MPG port map(clk, btn(0), enable);
--A2: MPG port map (clk,btn(1),enable2);
--C1: REGFILE port map (enable,enable2,btn(3),clk,Digits);
--B1: SSD port map(Digits, clk ,an ,cat);
                                                             --BLOC MEMORIE RAM
--A1: MPG port map(clk, btn(0), enable);
--A2: MPG port map (clk,btn(1),enable2);
--C1: REGFILE port map (enable2,enable,clk,sw(0),Digits,btn(3));
--B1: SSD port map(Digits, clk ,an ,cat);
                                                             --Afisare Memorie RAM
                                                             
-- process (clk)
--        begin
--   if clk='1' and clk'event and enable = '1' then
--       count_pt_memoria_ram <= count_pt_memoria_ram + 1;
      
--      end if;
      
--end process;
-- output_pt_Ram <= RAM(conv_integer(unsigned(count_pt_memoria_ram)));
--A1: MPG port map(clk, btn(0), enable);
--B1: SSD port map(output_pt_Ram, clk ,an ,cat);

                                                            --Test_IF                                                        
--M1: MPG port map(clk, btn(0), enable);
--M2: MPG port map(clk, btn(1), reset);
--I: InstructionFetch port map (JumpA ,PCSrcA ,clk ,sw(0),sw(1),Instructiune ,enable , reset ,PC);

--Digits<=Instructiune when sw(7)='0' else PC;
--S1: SSD port map(Digits, clk ,an ,cat);
                                                        --ID_OF_Lab6
    M1: MPG port map(clk, btn(0), enable); 
    M2: MPG port map(clk, btn(1), reset);   
    I: InstructionFetch port map (JumpA ,PCSrcA ,clk ,Jumpu,PcSrc,Instructiune ,enable , reset ,PC); 
   -- I2: InstructionFetch port map (JumpA ,PCSrcA ,clk ,sw(0),sw(1),Instructiune2 ,enable , reset ,PC); 
    ID:ID_OF port map(RegWrite,RD1,RD2,ExtendedImmediate,func,sa,clk,Instructiune,RegDst,enable,ExtOP, WD);
    ALU1: EX port map(RD1,RD2,sa,func,ExtendedImmediate,AluSrc,ALUOP,zero,AluRes);
    Mem1:MEM port map (AluRes,RD2,clk,MemWrite,enable,MemData);
     S1: SSD port map(Afisare_SSD, clk ,an ,cat);

    process(clk,Instructiune(15 downto 13),sw(7 downto 5))
   begin
    MemtoReg<='0'; RegDst<='0'; RegWrite<='0'; ExtOp<='0'; Jumpu<='0';Branch<='0';MemWrite<='0';ALUOp<="000";AluSrc<='0';
    case Instructiune(15 downto 13) is
    when "000" =>  RegWrite  <='1'; RegDst<='1';
           
     when "001" => RegWrite<='1';   ALUOp<="001"; AluSrc<='1';ExtOp<='1';
     
      when "010" =>  RegWrite<='1';  ALUOp<="010"; MemtoReg<='1'; AluSrc<='1';ExtOp<='1';
      
       when "011" =>   ALUOp<="011"; MemWrite<='1'; AluSrc<='1';ExtOp<='1';
       
        when "100" =>    ALUOp<="100"; Branch<='1'; ExtOp<='1';
        
         when "101" => RegWrite<='1';  ALUOp<="101"; AluSrc<='1';ExtOp<='1';
         
          when "110" =>  RegWrite<='1';  ALUOp<="110"; AluSrc<='1';ExtOp<='1';
          
           when others => Jumpu<='1'; 
           
        end case;
   
   case sw(7 downto 5) is 
     when "000" =>Afisare_SSD <=Instructiune;
                
      when "001" =>Afisare_SSD <=PC;
       when "010" =>Afisare_SSD <=RD1;
        when "011" =>Afisare_SSD <=RD2;
         when "100" =>Afisare_SSD <= ExtendedImmediate;
         when "101" =>Afisare_SSD <= AluRes;
         when "110" =>Afisare_SSD <= MemData;
         when "111" =>Afisare_SSD <=WD;
         when others =>Afisare_SSD <=x"AAAA";
   end case;
                                          

  
  led(15)<=  RegDst;
  led(14)<=  ExtOp;
  led(13)<= ALUSrc;
  led(12)<= Branch;
  led(11)<= Jumpu ;
 
  led(10)<= MemWrite ;
  led(9)<= MemtoReg ;
  led(8)<= RegWrite;

    led(6)<= ALUOp(2);
     led(5)<= ALUOp(1);
  led(4)<=ALUOp(0);
   end process;
  
   
    PcSrca<="00000000" & Instructiune(7 downto 0);
   JumpA<="000"& Instructiune(12 downto 0); 
    PCSrc<=Branch and zero; 
    WD<=MemData when MemtoReg='1' else AluRes;
end Behavioral;
