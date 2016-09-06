library ieee;
use ieee.std_logic_1164.all; 
use ieee.std_logic_unsigned.all; 
entity uart_tx is
      port(clk : in  std_logic;                        --ϵͳʱ��
           rst_n: in std_logic;                        --��λ�ź�
           rs232_tx: out std_logic;                    --RS232���������ź�
           clk_bps: in std_logic;                      --��ʱclk_bps�ĸߵ�ƽΪ�������ݵĲ�����
           bps_start:out std_logic;                    --���յ����ݺ󣬲�����ʱ��������λ 
           rx_data: in std_logic_vector(7 downto 0);   --�������ݼĴ���������ֱ����һ����������
           rx_int: in std_logic                        --���������ж��źţ����������ڼ�ʱ��Ϊ�ߵ�ƽ
           ); 
end uart_tx;
  
architecture behav of uart_tx is
           signal    rx_int0: std_logic;          
           signal    rx_int1: std_logic;          
           signal    rx_int2: std_logic;     
           signal    neg_rx_int:std_logic;          
           signal    bps_start_r:std_logic;     
           signal    num:integer;           
           signal    tx_data:std_logic_vector(7 downto 0);  --���ڽ������ݼĴ���������ֱ����һ�����ݵ���
        
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
                    if(neg_rx_int='1') then     --���յ�����������rs232_rx���½��ر�־�ź�
                         bps_start_r<='1';      --��������׼�����ݽ���      
                         tx_data<=rx_data;      --���������ж��ź�ʹ��      
                    else if((num= 15) and (clk_bps='1')) then --����������������Ϣ          
                             bps_start_r<='0';  --���ݽ�����ϣ��ͷŲ����������ź�        
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
                             when  2=>rs232_tx<=tx_data(0);--���͵�1bit         
                             when  3=>rs232_tx<=tx_data(1);--���͵�2bit         
                             when  4=>rs232_tx<=tx_data(2);--���͵�3bit         
                             when  5=>rs232_tx<=tx_data(3);--���͵�4bit         
                             when  6=>rs232_tx<=tx_data(4);--���͵�5bit         
                             when  7=>rs232_tx<=tx_data(5);--���͵�6bit         
                             when  8=>rs232_tx<=tx_data(6);--���͵�7bit         
                             when  9=>rs232_tx<=tx_data(7);--���͵�8bit         
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