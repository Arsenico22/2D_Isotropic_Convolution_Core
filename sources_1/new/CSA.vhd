library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.all;

entity CSA is
    port(Molt_W, Molt_WL, Molt_WC : in std_logic_vector(17 downto 0);
        pixel_out : out std_logic_vector(19 downto 0));
end CSA;

architecture Behavioral of CSA is

    component FA is
        port(A, B, Cin : in std_logic;
            S, Cout : out std_logic);
    end component FA;

    component RCA is
        generic (N:integer:=8);
        port(A_in, B_in : in std_logic_vector(N-1 downto 0);
            C_in : in std_logic;
            Sum : out std_logic_vector(N-1 downto 0);
            C_out : out std_logic);
    end component;

    signal Csa_Sum, Csa_Carry : std_logic_vector(17 downto 0);
    signal Molt_W_signed, Molt_WL_signed, Molt_WC_signed : signed(17 downto 0);
    signal Csa_Sum_signed, Csa_Carry_signed : signed(17 downto 0);
    
    signal RCA_A_signed, RCA_B_signed, RCA_sum_signed : signed (19 downto 0);
    signal Final_sum : std_logic_vector (19 downto 0);

begin

    Molt_WC_signed<=signed(Molt_WC);
    Molt_WL_signed<=signed(Molt_WL);
    Molt_W_signed<=signed(Molt_W);

    Stage1 : for i in 0 to 17 generate
        FA_i: FA port map (A=>Molt_WC_signed(i),B=>Molt_WL_signed(i),Cin=>Molt_W_signed(i), S=>Csa_Sum(i),Cout=>Csa_Carry(i));
    end generate;

    Csa_Sum_signed<=signed(Csa_Sum);
    Csa_Carry_signed<=signed(Csa_Carry);

    RCA_A_signed<=resize(Csa_Sum_signed,20);
    RCA_B_signed<=resize(Csa_Carry_signed & '0',20);

    Final_Adder: RCA generic map(N=>20)
    
    port map(A_in=>std_logic_vector(RCA_A_signed), B_in=>std_logic_vector(RCA_B_signed), C_in=>'0', Sum=>Final_sum, C_out=>open);

    RCA_sum_signed<=signed(Final_sum);
    pixel_out<=std_logic_vector(RCA_sum_signed);

end Behavioral;