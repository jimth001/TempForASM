library ieee;
use ieee.std_logic_1164.all; 
use ieee.std_logic_unsigned.all; 
entity uart_tx is
      port(clk : in  std_logic;                        --系统时钟
           rst_n: in std_logic;                        --复位信号
           rs232_tx: out std_logic;                    --RS232接收数据信号
           clk_bps: in std_logic;                      --此时clk_bps的高电平为接收数据的采样点
           bps_start:out std_logic;                    --接收到数据后，波特率时钟启动置位 
           rx_data: in std_logic_vector(7 downto 0);   --接收数据寄存器，保存直至下一个数据来到
           rx_int: in std_logic                        --接收数据中断信号，接收数据期间时钟为高电平
           ); 
end uart_tx;
  
architecture behav of uart_tx is
           signal    rx_int0: std_logic;          
           signal    rx_int1: std_logic;          
           signal    rx_int2: std_logic;     
           signal    neg_rx_int:std_logic;          
           signal    bps_start_r:std_logic;     
           signal    num:integer;           
           signal    tx_data:std_logic_vector(7 downto 0);  --串口接收数据寄存器，保存直至下一个数据到来
        
begin
     process(clk,rst_n) 
        begin           
             if (rst_n='0')then
                  rx_int0<='0';
                  rx_int1<='0';     
                  rx_int2<='0';    
             else
                 if (rising_edge(clk)) then
                       rx_int0<=rx_int;      
                       rx_int1<=rx_int0;      
                       rx_int2<=rx_int1;     
                 end if;   
             end if;    
             neg_rx_int <=not(rx_int1)and (rx_int2);    
     end process;       
     
     process(clk,rst_n)
     begin           
          if (rst_n='0')then
                  bps_start_r<='0';
                  tx_data<="00000000";
          else
              if (rising_edge(clk)) then
                    if(neg_rx_int='1') then     --接收到串口数据线rs232_rx的下降沿标志信号
                         bps_start_r<='1';      --启动串口准备数据接收      
                         tx_data<=rx_data;      --接收数据中断信号使能      
                    else if((num= 15) and (clk_bps='1')) then --接收完有用数据信息          
                             bps_start_r<='0';  --数据接收完毕，释放波特率启动信号        
                         end if;      
                    end if;
              end if;     
          end if;   
          bps_start<=bps_start_r;    
     end process;         

     process(clk,rst_n)      
     begin           
          if (rst_n='0')then 
                  rs232_tx<='1';     
                  num<=0;    
          else      
              if (rising_edge(clk)) then
                    if(clk_bps='1')then        
                         num<=num+1; 
                         case num is
                             when  1=>rs232_tx<='0';         
                             when  2=>rs232_tx<=tx_data(0);--发送第1bit         
                             when  3=>rs232_tx<=tx_data(1);--发送第2bit         
                             when  4=>rs232_tx<=tx_data(2);--发送第3bit         
                             when  5=>rs232_tx<=tx_data(3);--发送第4bit         
                             when  6=>rs232_tx<=tx_data(4);--发送第5bit         
                             when  7=>rs232_tx<=tx_data(5);--发送第6bit         
                             when  8=>rs232_tx<=tx_data(6);--发送第7bit         
                             when  9=>rs232_tx<=tx_data(7);--发送第8bit         
                             when  10=>rs232_tx<='1';         
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
end behav; 