library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL; 

entity ADDER_TREE is

    generic (N : integer := 8);
    
    port (A,B,C,D : in std_logic_vector(N-1 downto 0);
        sum_out    : out std_logic_vector(N+1 downto 0));
end ADDER_TREE;

architecture structural of ADDER_TREE is 

    component RCA is 
        generic (N : integer := 8);
       
        port (A_in,B_in    : in  std_logic_vector(N-1 downto 0);
            C_in    : in  std_logic;                     
            Sum     : out std_logic_vector(N-1 downto 0); 
            C_out   : out std_logic);
    end component RCA; 

    signal PS1,PS2 : std_logic_vector(N-1 downto 0);
    signal P_Cout_1,P_Cout_2,L2_Cout : std_logic;
    signal L2_PS1,L2_PS2,L2_SUM : std_logic_vector(N downto 0);

begin

    RCA0_L1 : RCA generic map (N => N) 
        port map (A_in => A,B_in => B,C_in => '0', Sum => PS1,C_out => P_Cout_1);

    RCA1_L0 : RCA generic map (N => N) 
        port map (A_in    => C,B_in => D,C_in => '0', Sum => PS2,C_out => P_Cout_2);

    L2_PS1 <= P_Cout_1 & PS1;
    L2_PS2 <= P_Cout_2 & PS2;

    RCA_L2 : RCA generic map (N => N + 1) 
        port map (A_in => L2_PS1,B_in => L2_PS2,C_in => '0',Sum => L2_SUM,C_out => L2_Cout);
        
    sum_out <= L2_Cout & L2_SUM;

end architecture structural;