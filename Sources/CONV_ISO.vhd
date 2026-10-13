library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.all;

entity CONV_ISO is
    port (
        clk, rst : in std_logic;
        Pixel_0, Pixel_1, Pixel_2, Pixel_3, Pixel_4, Pixel_5, Pixel_6, Pixel_7, Pixel_8 : in std_logic_vector(7 downto 0);
        W_in, WL_in, WC_in : in std_logic_vector(7 downto 0);
        Pixel_out : out std_logic_vector(19 downto 0)
    );
end CONV_ISO;

architecture RTL_level of CONV_ISO is

    component ADDER_TREE is
        port (
            A,B,C,D : in std_logic_vector(7 downto 0);
            sum_out : out std_logic_vector(9 downto 0)
        );
    end component;

    component MULTIPLIER is
        Port(
            MoltA: in std_logic_vector(9 downto 0);
            MoltB: in std_logic_vector(7 downto 0);
            Ris_Molt: out std_logic_vector(17 downto 0));
    end component;

    component CSA is
        port (
            Molt_W, Molt_WL, Molt_WC  : in std_logic_vector(17 downto 0);
            pixel_out : out std_logic_vector(19 downto 0)
        );
    end component;

    signal Pixel_center : std_logic_vector(7 downto 0);
    signal pixel_center_10bit : std_logic_vector(9 downto 0);

    signal Pixel_L_sum, Pixel_C_sum, Pixel_L_sum_reg, Pixel_C_sum_reg : std_logic_vector(9 downto 0);

    signal Pixel_L_int, Pixel_C_int,Pixel_CENTER_int : std_logic_vector(17 downto 0);

    signal center_reg, lateral_reg, corner_reg : std_logic_vector(17 downto 0);

    signal Pixel_out_int,Pixel_out_reg : std_logic_vector(19 downto 0);

begin

    ADDER_WL : ADDER_TREE port map(A => Pixel_1, B => Pixel_3, C => Pixel_5, D => Pixel_7, sum_out => Pixel_L_sum);
    ADDER_WC : ADDER_TREE port map(A => Pixel_0, B => Pixel_2, C => Pixel_6, D => Pixel_8, sum_out => Pixel_C_sum);

    pixel_center_10bit <= std_logic_vector(resize(unsigned(Pixel_center), 10));

    Mult_W  : MULTIPLIER port map(MoltA => pixel_center_10bit, MoltB => W_in,  Ris_Molt => Pixel_CENTER_int);
    Mult_WL : MULTIPLIER port map(MoltA => Pixel_L_sum_reg, MoltB => WL_in, Ris_Molt => Pixel_L_int);
    Mult_WC : MULTIPLIER port map(MoltA => Pixel_C_sum_reg, MoltB => WC_in, Ris_Molt => Pixel_C_int);

    Final_Adder : CSA port map( Molt_W => center_reg, Molt_WL => lateral_reg, Molt_WC => corner_reg, pixel_out => Pixel_out_int);

    process(clk, rst)
    
    begin
    
        if rst = '1' then
        
            Pixel_center    <= (others => '0');
            Pixel_L_sum_reg <= (others => '0');
            Pixel_C_sum_reg <= (others => '0');
            center_reg  <= (others => '0');
            lateral_reg <= (others => '0');
            corner_reg  <= (others => '0');
           
            Pixel_out_reg <= (others => '0');
            
        elsif rising_edge(clk) then
           
                Pixel_center    <= Pixel_4;
                Pixel_L_sum_reg <= Pixel_L_sum;
                Pixel_C_sum_reg <= Pixel_C_sum;
                
                center_reg  <= Pixel_CENTER_int;
                lateral_reg <= Pixel_L_int;
                corner_reg  <= Pixel_C_int;
                
                Pixel_out_reg <= Pixel_out_int;
         
        end if;
    end process;

    Pixel_out <= Pixel_out_reg;

end RTL_level ;