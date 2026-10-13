library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity FSM is
    Port(
        clk, rst, Start, Load_Kernel, Valid_Kernel : in std_logic;
        Load_W, Load_WL, Load_WC : in std_logic_vector(7 downto 0);
        W, WL, WC : out std_logic_vector(7 downto 0);
        Valid : out std_logic
    );
end FSM;

architecture Behavioral of FSM is

    type state_type is (idle, kernel, load, pixel_valid, pixel_invalid);
    signal state : state_type;

    signal count_load : std_logic_vector(7 downto 0) := (others => '0');
    signal count_pixel_valid : std_logic_vector(5 downto 0) := (others => '0');
    signal count_pixel_invalid : std_logic_vector(2 downto 0) := (others => '0');
    signal count_line : std_logic_vector(6 downto 0) := (others => '0');

begin

    process(clk)
    
    begin
        if rising_edge(clk) then
            if rst = '1' then
                state <= idle;
                count_load <= (others => '0');
                count_pixel_valid <= (others => '0');
                count_pixel_invalid <= (others => '0');
                count_line <= (others => '0');
                W  <= (others => '0');
                WL <= (others => '0');
                WC <= (others => '0'); 
                
            else
                case state is

                    when idle =>
                        if Start = '1' then
                            state <= load;
                        elsif Load_Kernel = '1' then
                            state <= kernel;
                        else
                            state <= idle;
                        end if;

                    when kernel =>
                        if Valid_Kernel = '1' then
                        
                            W  <= Load_W;
                            WL <= Load_WL;
                            WC <= Load_WC;
                            
                            state <= idle;
                        else
                            state <= kernel;
                        end if;

                    when load =>
                    
                        if count_load = "10000101" then
                            state <= pixel_valid;
                            count_load <= (others => '0');
                        else
                            state <= load;
                            count_load <= count_load + 1;
                        end if;

                    when pixel_valid =>
                    
                        if count_pixel_valid = "111101" then
                            state <= pixel_invalid;
                            count_pixel_valid <= (others => '0');
                            count_line <= count_line + 1;
                        else
                            state <= pixel_valid;
                            count_pixel_valid <= count_pixel_valid + 1;
                        end if;

                    when pixel_invalid =>
                        if count_pixel_invalid = "001" then
                            count_pixel_invalid <= (others => '0');
                            state <= pixel_valid;
                        elsif count_line = "0111110" then
                            state <= idle;
                            count_line <= (others => '0');
                        else
                            state <= pixel_invalid;
                            count_pixel_invalid <= count_pixel_invalid + 1;
                        end if;

                end case;
            end if;
        end if;
    end process;

    process(state)
    begin
        case state is
            
                when idle => Valid <= '0';
                when kernel => Valid <= '0';
                when load => Valid <= '0';
                when pixel_valid => Valid <= '1';
                when pixel_invalid => Valid <= '0';
              
        end case;
    end process;

end Behavioral;