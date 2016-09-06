library ieee;  
use ieee.std_logic_1164.all; 
use ieee.std_logic_unsigned.all; 
entity uart_rx is
      port(clk : in  std_logic;                        --系统时钟
           rst_n: in std_logic;                        --复位信号    
           rs232_rx: in std_logic;                     --RS232接收数据信号 
           clk_bps: in std_logic;                      --此时clk_bps的高电平为接收数据的采样点
           bps_start:out std_logic;        --接收到数据后，波特率时钟启动置位 
           rx_data: out std_logic_vector(7 downto 0);  --接收数据寄存器，保存直至下一个数据来到 
           rx_int: out std_logic;                      --接收数据中断信号，接收数据期间时钟为高电平
           seg_data1: OUT std_logic_vector(7 DOWNTO 0);  --数码管数据
           seg_data2: OUT std_logic_vector(7 DOWNTO 0)  --数码管数据
          );
end uart_rx;
    
architecture behav of uart_rx is
           signal    rs232_rx0: std_logic;
           signal    rs232_rx1: std_logic;          
           signal    rs232_rx2: std_logic;
           signal    rs232_rx3: std_logic;
           signal    neg_rs232_rx:std_logic;
           signal    bps_start_r:std_logic;
           signal    num:integer;
           signal    rx_data_r:std_logic_vector(7 downto 0);  --串口接收数据寄存器，保存直至下一个数据到来

begin
     
     process(clk,rst_n)
       begin
           if (rst_n='0')then
                   rs232_rx0<='0';
                   rs232_rx1<='0';
                   rs232_rx2<='0';
                   rs232_rx3<='0';
           else
               if (rising_edge(clk)) then
                      rs232_rx0<=rs232_rx; 
                      rs232_rx1<=rs232_rx0;
                      rs232_rx2<=rs232_rx1;
                      rs232_rx3<=rs232_rx2;
               end if;
           end if;
           neg_rs232_rx <=rs232_rx3 and rs232_rx2 and not(rs232_rx1)and not(rs232_rx0);
     end process;
     process(clk,rst_n)
        begin
            if (rst_n='0')then
                     bps_start_r<='0';
                     rx_int<='0';
            else
                if (rising_edge(clk)) then
                    if(neg_rs232_rx='1') then     --接收到串口数据线rs232_rx的下降沿标志信号
                         bps_start_r<='1';        --启动串口准备数据接收
                         rx_int<='1';             --接收数据中断信号使能
                    else if((num= 15) and (clk_bps='1')) then --接收完有用数据信息
                         bps_start_r<='0';        --数据接收完毕，释放波特率启动信号 
                         rx_int<='0';             --接收数据中断信号关闭
                         end if;
                    end if;
                end if;
            end if;
            bps_start<=bps_start_r;
     end process;


     process(clk,rst_n)
       begin
            if (rst_n='0')then
                    rx_data_r<="00000000";
                    rx_data<="00000000";
                    num<=0;
            else
                if (rising_edge(clk)) then
                       if(clk_bps='1')then
                               num<=num+1;
                               case num is
                                    when  1=>rx_data_r(0)<=rs232_rx;--锁存第0bit
                                    when  2=>rx_data_r(1)<=rs232_rx;--锁存第0bit
                                    when  3=>rx_data_r(2)<=rs232_rx;--锁存第0bit
                                    when  4=>rx_data_r(3)<=rs232_rx;--锁存第0bit 
                                    when  5=>rx_data_r(4)<=rs232_rx;--锁存第0bit 
                                    when  6=>rx_data_r(5)<=rs232_rx;--锁存第0bit 
                                    when  7=>rx_data_r(6)<=rs232_rx;--锁存第0bit 
                                    when  8=>rx_data_r(7)<=rs232_rx;--锁存第0bit 
                                    when  10=>rx_data<=rx_data_r;
                                    when  11=>num<=15;
                                    when  others=>null;
                               end case;
                               if(num=15) then
                                    num<=0;
                               end if;
                       end if;
                end if;
            end if;
     end process;
     
     process(rx_data_r)   --将接受的数据用数码管显示出来
         begin
              case rx_data_r(3 downto 0) is
                   when "0000" =>seg_data1<= "00000011"; --0   
                   when "0001" =>seg_data1<= "10011111"; --1  
                   when "0010" =>seg_data1<= "00100101"; --2  
                   when "0011" =>seg_data1<= "00001101"; --3      
                   when "0100" =>seg_data1<= "10011001"; --4   
                   when "0101" =>seg_data1<= "01001001"; --5  
                   when "0110" =>seg_data1<= "01000001"; --6   
                   when "0111" =>seg_data1<= "00011111"; --7   
                   when "1000" =>seg_data1<= "00000001"; --8    
                   when "1001" =>seg_data1<= "00001001"; --9   
                   when "1010" =>seg_data1<= "00010001"; --A   
                   when "1011" =>seg_data1<= "11000001"; --B   
                   when "1100" =>seg_data1<= "01100011"; --C   
                   when "1101" =>seg_data1<= "10000101"; --D  
                   when "1110" =>seg_data1<= "01100001"; --E   
                   when "1111" =>seg_data1<= "01110001"; --F    
                   when  others  =>seg_data1<= "11111111";          
              end case;
              case rx_data_r(7 downto 4) is
                   when "0000" =>seg_data2<= "00000011"; --0   
                   when "0001" =>seg_data2<= "10011111"; --1  
                   when "0010" =>seg_data2<= "00100101"; --2  
                   when "0011" =>seg_data2<= "00001101"; --3      
                   when "0100" =>seg_data2<= "10011001"; --4   
                   when "0101" =>seg_data2<= "01001001"; --5  
                   when "0110" =>seg_data2<= "01000001"; --6   
                   when "0111" =>seg_data2<= "00011111"; --7   
                   when "1000" =>seg_data2<= "00000001"; --8    
                   when "1001" =>seg_data2<= "00001001"; --9   
                   when "1010" =>seg_data2<= "00010001"; --A   
                   when "1011" =>seg_data2<= "11000001"; --B   
                   when "1100" =>seg_data2<= "01100011"; --C   
                   when "1101" =>seg_data2<= "10000101"; --D  
                   when "1110" =>seg_data2<= "01100001"; --E   
                   when "1111" =>seg_data2<= "01110001"; --F    
                   when  others  =>seg_data2<= "11111111";          
             end case;
     end process;
end behav;   