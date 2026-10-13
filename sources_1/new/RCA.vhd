library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity RCA is

     generic (N : integer := 8);
    port (
        A_in,B_in : in  std_logic_vector(N-1 downto 0);
        C_in : in  std_logic;
        Sum : out std_logic_vector(N-1 downto 0);
        C_out : out std_logic
    );
    
end RCA;

architecture Behavioral of RCA is

component FA is

port(
    A,B,Cin:in std_logic;
    S,Cout:out std_logic);
    
end component FA;

signal C:std_logic_vector(N downto 0);

begin

C(0) <= C_in;

GenFA:for i in 0 to N-1 generate

MapFA: FA port map (A => A_in(i),B => B_in(i),Cin => C(i),S => Sum(i),Cout => C(i+1));
      end generate;
      
C_out <= C(N);


end Behavioral;