library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity SHIFT_REG is
    port (
        clk, rst : in  std_logic;
        pixel_in : in  std_logic_vector(7 downto 0);
        pixel_out : out std_logic_vector(7 downto 0)
    );
end entity SHIFT_REG;

architecture Behavioral of SHIFT_REG is
    type pixel_line is array (0 to 60) of std_logic_vector(7 downto 0);
    signal pixel_buffer : pixel_line := (others => (others => '0'));
begin

    process(clk, rst)
    
    begin
        if rst = '1' then
            pixel_buffer <= (others => (others => '0'));
            
        elsif rising_edge(clk) then
        
          
                pixel_buffer(0) <= pixel_in;
                for i in 1 to 60 loop
                    pixel_buffer(i) <= pixel_buffer(i - 1);
                end loop;
                
   
            
        end if;
        
    end process;

    pixel_out <= pixel_buffer(60);

end Behavioral;