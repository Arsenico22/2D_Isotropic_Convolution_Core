
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity MULTIPLIER is

generic(N: integer:=18);

Port
    (MoltA:in std_logic_vector(9 downto 0); 
     MoltB:in std_logic_vector(7 downto 0);
     Ris_Molt:out std_logic_vector(N-1 downto 0)
     );
        
end MULTIPLIER;

architecture Behavioral of MULTIPLIER is

component RCA is
 
generic (N : integer := 8); 
port (
    A_in,B_in  : in  std_logic_vector(N-1 downto 0);
    C_in : in  std_logic;
    Sum : out std_logic_vector(N-1 downto 0);
    C_out : out std_logic
);
end component;

signal PPP0,PPP1,PPP2,PPP3,PPP4,PPP5,PPP6: std_logic_vector(17 downto 0) := (others => '0'); 
signal Ris_P01,Ris_P23,Ris_P45,Ris_P67: std_logic_vector(18 downto 0); 
signal Ris_P0123,Ris_P4567: std_logic_vector(19 downto 0); 

signal P7_temp, PPP7_inverted, PPP7_2s, PPP7_final : std_logic_vector(17 downto 0) := (others => '0');

signal Ris_Molt_int : std_logic_vector(20 downto 0);

begin

Gen_PP : for i in 0 to 9 generate

    PPP0(i) <= MoltA(i) AND MoltB(0);
    PPP1(i+1) <= MoltA(i) AND MoltB(1); 
    PPP2(i+2) <= MoltA(i) AND MoltB(2); 
    PPP3(i+3) <= MoltA(i) AND MoltB(3); 
    PPP4(i+4) <= MoltA(i) AND MoltB(4); 
    PPP5(i+5) <= MoltA(i) AND MoltB(5); 
    PPP6(i+6) <= MoltA(i) AND MoltB(6); 
end generate ;

P7_temp(16 downto 7) <= MoltA; 

PPP7_inverted <= not P7_temp;

Adder_2s: RCA generic map(18) 

    port map(A_in => PPP7_inverted, B_in => (0 => '1', others => '0'), C_in  => '0', Sum  => PPP7_2s,C_out => open);

PP7: process(MoltB(7), PPP7_2s)
begin
    if MoltB(7) = '1' then
        PPP7_final <= PPP7_2s;
    else
        PPP7_final <= (others => '0');
    end if;
end process PP7;

RCA0_L0: RCA generic map(18) 
    port map(A_in => PPP0, B_in => PPP1, C_in => '0', Sum => Ris_P01(17 downto 0), C_out => Ris_P01(18));
RCA1_L0: RCA generic map(18)
    port map(A_in => PPP2, B_in => PPP3, C_in => '0', Sum => Ris_P23(17 downto 0), C_out => Ris_P23(18));
RCA2_L0: RCA generic map(18)
    port map(A_in => PPP4, B_in => PPP5, C_in => '0', Sum => Ris_P45(17 downto 0), C_out => Ris_P45(18));
RCA3_L0: RCA generic map(18)
    port map(A_in => PPP6, B_in => PPP7_final, C_in => '0', Sum => Ris_P67(17 downto 0), C_out => Ris_P67(18));
RCA0_L1: RCA generic map(19) 
    port map(A_in => Ris_P01, B_in => Ris_P23, C_in => '0', Sum => Ris_P0123(18 downto 0), C_out => Ris_P0123(19));
RCA1_L1: RCA generic map(19)
    port map(A_in => Ris_P45, B_in => Ris_P67, C_in => '0', Sum => Ris_P4567(18 downto 0), C_out => Ris_P4567(19));
RCA_L2: RCA generic map(20) 
    port map(A_in => Ris_P0123, B_in => Ris_P4567, C_in => '0', Sum => Ris_Molt_int(19 downto 0), C_out => Ris_Molt_int(20));

Ris_Molt <= Ris_Molt_int(N-1 downto 0);

end Behavioral;