library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_TEXTIO.ALL;
use STD.TEXTIO.ALL;


entity TB_TOP_ELABORATION is
end TB_TOP_ELABORATION;

architecture Behavioral of TB_TOP_ELABORATION is

component TOP_ELABORATION is

  Port(
        clk, rst, Start, Load_Kernel, Valid_Kernel : in std_logic;
        Load_WC, Load_WL, Load_W : in std_logic_vector(7 downto 0);
        Pixel_in : in std_logic_vector(7 downto 0);
        Pixel_out : out std_logic_vector(19 downto 0);
        Valid : out std_logic
    );
end component;

signal TB_clk,TB_rst,TB_Start,TB_Load_Kernel,TB_Valid_Kernel : std_logic:='0';
signal TB_Load_WC,TB_Load_WL,TB_Load_W,TB_Pixel_in: std_logic_vector(7 downto 0):=(others => '0');
signal TB_Valid: std_logic;
signal TB_Pixel_out: std_logic_vector(19 downto 0);
constant clk_period : time:=6ns;

begin

uut: TOP_ELABORATION 
            port map ( clk => TB_clk, rst => TB_rst, Start => TB_Start,
            Load_Kernel => TB_Load_Kernel, Valid_Kernel   => TB_Valid_Kernel,
            Load_W => TB_Load_W, Load_WL => TB_Load_WL, Load_WC => TB_Load_WC,
            Pixel_in => TB_Pixel_in, Pixel_out=> TB_Pixel_out,
            Valid => TB_Valid
            );

process
    begin
        wait for clk_period/2;
        TB_clk<=not(TB_clk);
end process;

process 
        variable rdline : line;
        variable tmp : integer;
        file Read_file : text open read_mode is "C:\\Users\\Danil\\Desktop\\lena64.txt";
        begin 
        wait for 100*clk_period; 
        TB_Load_Kernel<='1';
        wait for 2*clk_period;
        TB_Load_Kernel<='0';
        TB_Valid_Kernel<='1';
        
        TB_Load_WC<="00000001"; --0
        TB_Load_WL<="00000010"; -- -1
        TB_Load_W<= "00000100"; -- 4
        
        wait for 2*clk_period;
        TB_Valid_Kernel<='0'; 
        TB_Load_WC<=(others=>'0');
        TB_Load_WL<=(others=>'0');
        TB_Load_W<=(others=>'0');
        wait for 5*clk_period;
        TB_Start<='1';
        wait for clk_period;
        TB_Start<='0';
        
        while not endfile(Read_file) loop   
                readline(Read_file, rdline);
                read(rdline, tmp);
                TB_Pixel_in<=std_logic_vector(to_unsigned(tmp,8));
             wait for clk_period;
             end loop;
         wait;
end process;

process
       variable wrline:line;
       file result_file:text open write_mode is "C:\\Users\\Danil\\Desktop\\ElabXX.txt";
       begin
       if(TB_Valid='1') then
        
            write(wrline,TB_Pixel_out,right);
            writeline(result_file,wrline);
      end if;
      wait for clk_period;
end process;   


end Behavioral;
