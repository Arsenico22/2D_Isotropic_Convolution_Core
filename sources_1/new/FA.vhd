library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity FA is
    port(
        A, B, Cin : in std_logic;
        S, Cout : out std_logic
    );
end FA;

architecture Behavioral of FA is

    signal p : std_logic;
    
begin
    p <= A xor B;
    S <= p xor Cin;
    Cout <= (A and B) or (Cin and p);
    
end Behavioral;