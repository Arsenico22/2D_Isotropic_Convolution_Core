library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;    
use STD.TEXTIO.ALL;         

entity TB_MULTIPLIER is
end TB_MULTIPLIER;

architecture Behavioral of TB_MULTIPLIER is

component MULTIPLIER is
generic(N: integer:=18);
Port(MoltA:in std_logic_vector(9 downto 0); 
     MoltB:in std_logic_vector(7 downto 0); 
     Ris_Molt:out std_logic_vector(N-1 downto 0));   
end component;

signal TB_MoltA: std_logic_vector(9 downto 0) := (others => '0');
signal TB_MoltB: std_logic_vector(7 downto 0) := (others => '0');
signal TB_Ris_Molt: std_logic_vector(17 downto 0) := (others => '0');

begin

uut: MULTIPLIER 
generic map (N => 18)
port map (MoltA => TB_MoltA, MoltB => TB_MoltB, Ris_Molt => TB_Ris_Molt
);

process
    variable wrline:line;
    file result_file:text open write_mode is "C:\Users\Danil\desktop\progetto\Molt.txt";
    
    begin
    wait for 104 ns; 

    write(wrline, string'("MoltA_int | MoltB_int | Ris_Molt_int"));
    writeline(result_file, wrline);
    write(wrline, string'("----------|-----------|--------------"));
    writeline(result_file, wrline);

    for i in 0 to 1023 loop
        for j in 0 to 255 loop
            TB_MoltA <= std_logic_vector(to_unsigned(i,10));
            TB_MoltB <= std_logic_vector(to_signed(j,8));
            
            wait for 5 ns;
            
            write(wrline, to_integer(unsigned(TB_MoltA)), right, 5); 
            write(wrline, string'(" | "));
            write(wrline, to_integer(signed(TB_MoltB)), right, 5);   
            write(wrline, string'(" | "));
            write(wrline, to_integer(signed(TB_Ris_Molt)), right, 10); 
            writeline(result_file, wrline);
        end loop;
    end loop;
    
    wait; 
end process;
    
end Behavioral;