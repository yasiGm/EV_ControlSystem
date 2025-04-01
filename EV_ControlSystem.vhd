library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity EV_ControlSystem is
    Port (
        clk : in STD_LOGIC;
        reset : in STD_LOGIC;
        throttle_input : in STD_LOGIC_VECTOR(7 downto 0); 
        battery_voltage : in STD_LOGIC_VECTOR(7 downto 0); 
        motor_current : in STD_LOGIC_VECTOR(7 downto 0);
        motor_output : out STD_LOGIC_VECTOR(7 downto 0);  
        energy_efficiency : out STD_LOGIC_VECTOR(7 downto 0) 
    );
end EV_ControlSystem;

architecture Behavioral of EV_ControlSystem is
    signal throttle_reg : STD_LOGIC_VECTOR(7 downto 0);
    signal speed_control : STD_LOGIC_VECTOR(7 downto 0);
    signal efficiency : STD_LOGIC_VECTOR(7 downto 0);
    																				
    function control_speed(throttle, voltage: STD_LOGIC_VECTOR(7 downto 0)) return STD_LOGIC_VECTOR is
        variable result : STD_LOGIC_VECTOR(7 downto 0);
    begin
        result := (throttle * voltage) / 255;
        return result;
    end function;
    
    function calculate_efficiency(voltage, current: STD_LOGIC_VECTOR(7 downto 0)) return STD_LOGIC_VECTOR is
        variable result : STD_LOGIC_VECTOR(7 downto 0);
    begin
        if current /= "00000000" then
            result := (voltage * 100) / current;
        else
            result := (others => '0');
        end if;
        return result;
    end function;
        
begin
    process(clk, reset)
    begin
        if reset = '1' then
            throttle_reg <= (others => '0');
            speed_control <= (others => '0');
            efficiency <= (others => '0');
        elsif rising_edge(clk) then
            throttle_reg <= throttle_input;
            speed_control <= control_speed(throttle_input, battery_voltage);
            efficiency <= calculate_efficiency(battery_voltage, motor_current);
        end if;
    end process;
            
    motor_output <= speed_control;
    energy_efficiency <= efficiency;
    
end Behavioral;
