library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity TOP_ELABORATION is

    Port(
        clk, rst, Start, Load_Kernel, Valid_Kernel : in std_logic;
        Load_WC, Load_WL, Load_W : in std_logic_vector(7 downto 0);
        Pixel_in : in std_logic_vector(7 downto 0);
        Pixel_out : out std_logic_vector(19 downto 0);
        Valid : out std_logic
    );
end TOP_ELABORATION;

architecture Behavioral of TOP_ELABORATION is

    signal WC_int, WL_int, W_int : std_logic_vector(7 downto 0);
   
    signal P00_int, P01_int, P02_int, P10_int, P11_int, P12_int, P20_int, P21_int, P22_int : std_logic_vector(7 downto 0);

    component FSM is
        Port(
            clk, rst, Start, Load_Kernel, Valid_Kernel : in std_logic;
            Load_W, Load_WL, Load_WC : in std_logic_vector(7 downto 0);
            W, WL, WC : out std_logic_vector(7 downto 0);
            Valid : out std_logic
        );
    end component;

    component BL is
        Port(
            clk, rst: in std_logic;
            Pixel_in : in std_logic_vector(7 downto 0);
            P00, P01, P02, P10, P11, P12, P20, P21, P22 : out std_logic_vector(7 downto 0)
        );
    end component;

    component CONV_ISO is
        port (
            clk, rst : in std_logic;
            Pixel_0, Pixel_1, Pixel_2, Pixel_3, Pixel_4, Pixel_5, Pixel_6, Pixel_7, Pixel_8 : in std_logic_vector(7 downto 0);
            W_in, WL_in, WC_in : in std_logic_vector(7 downto 0);
            Pixel_out : out std_logic_vector(19 downto 0)
        );
    end component;

begin

    F_S_M : FSM
        port map(
            clk => clk, rst => rst, Start => Start, Load_Kernel => Load_Kernel, Valid_Kernel => Valid_Kernel,
            Load_W => Load_W, Load_WL => Load_WL, Load_WC => Load_WC,
            W => W_int, WL => WL_int, WC => WC_int,
            Valid => Valid
        );

    B_L : BL
        port map(
            Pixel_in => Pixel_in, clk => clk, rst => rst,
            P00 => P00_int, P01 => P01_int, P02 => P02_int,
            P10 => P10_int, P11 => P11_int, P12 => P12_int,
            P20 => P20_int, P21 => P21_int, P22 => P22_int
        );

    C_I : CONV_ISO
        port map(
            clk => clk, rst => rst,
            Pixel_0 => P00_int, Pixel_1 => P01_int, Pixel_2 => P02_int,
            Pixel_3 => P10_int, Pixel_4 => P11_int, Pixel_5 => P12_int,
            Pixel_6 => P20_int, Pixel_7 => P21_int, Pixel_8 => P22_int,
            W_in => W_int, WL_in => WL_int,WC_in => WC_int, Pixel_out => Pixel_out
        );

end Behavioral;