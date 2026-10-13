library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity BL is
    Port(
        Pixel_in : in std_logic_vector(7 downto 0);
        clk, rst : in std_logic;
        P00, P01, P02, P10, P11, P12, P20, P21, P22 : out std_logic_vector(7 downto 0) 
        );
end BL;

architecture Behavioral of BL is

    component REG_8BIT is
        Port(
            clk, rst : in std_logic;
            D : in std_logic_vector(7 downto 0);
            Q : out std_logic_vector(7 downto 0)
            );
    end component;

    component SHIFT_REG is
        Port(
            clk, rst : in std_logic;
            pixel_in : in std_logic_vector(7 downto 0);
            pixel_out : out std_logic_vector(7 downto 0)
            );
    end component;

    signal P00_int, P01_int, P02_int,P10_int, P11_int, P12_int,P20_int, P21_int, P22_int : std_logic_vector(7 downto 0);
    signal SR1_out, SR2_out : std_logic_vector(7 downto 0);

begin

    REG00: REG_8BIT port map(clk => clk, rst => rst, D => Pixel_in, Q => P00_int);
    REG01: REG_8BIT port map(clk => clk, rst => rst, D => P00_int, Q => P01_int);
    REG02: REG_8BIT port map(clk => clk, rst => rst, D => P01_int, Q => P02_int);

    SHIFT1: SHIFT_REG port map(clk => clk, rst => rst, pixel_in => P02_int, pixel_out => SR1_out);

    REG10: REG_8BIT port map(clk => clk, rst => rst, D => SR1_out, Q => P10_int);
    REG11: REG_8BIT port map(clk => clk, rst => rst,  D => P10_int, Q => P11_int);
    REG12: REG_8BIT port map(clk => clk, rst => rst, D => P11_int, Q => P12_int);

    SHIFT2: SHIFT_REG port map(clk => clk, rst => rst,  pixel_in => P12_int, pixel_out => SR2_out);

    REG20: REG_8BIT port map(clk => clk, rst => rst,  D => SR2_out, Q => P20_int);
    REG21: REG_8BIT port map(clk => clk, rst => rst, D => P20_int, Q => P21_int);
    REG22: REG_8BIT port map(clk => clk, rst => rst, D => P21_int, Q => P22_int);

    P00 <= P00_int;  P01 <= P01_int;  P02 <= P02_int;
    P10 <= P10_int;  P11 <= P11_int;  P12 <= P12_int;
    P20 <= P20_int;  P21 <= P21_int;  P22 <= P22_int;

end Behavioral;