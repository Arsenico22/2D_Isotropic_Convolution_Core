library IEEE;
use iEEE.STD_LOGIC_1164.ALL;

entity REG_8bit is
    port (
        clk,rst: in  std_logic;
        D : in  std_logic_vector(7 downto 0);
        Q : out std_logic_vector(7 downto 0)
    );
end REG_8bit;

architecture Behavioral of REG_8bit is

begin

    process (clk, rst)
    begin
        if rst = '1' then
            Q <= (others => '0');
        elsif rising_edge(clk) then
          
                Q <= D;
          
        end if;
    end process;

end Behavioral;