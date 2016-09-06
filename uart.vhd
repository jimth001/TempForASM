library ieee;
use ieee.std_logic_1164.all; 
use ieee.std_logic_arith.all; 
use ieee.std_logic_unsigned.all; 
entity uart is
      port(clk : in  std_logic;                        --ϵͳʱ��
           rst_n: in std_logic;                        --��λ�ź�
           rs232_rx: in std_logic;                     --RS232���������ź�;
           rs232_tx: out std_logic;                    --RS232���������ź�;
           seg_data1: OUT std_logic_vector(7 DOWNTO 0);  --���������
           seg_data2: OUT std_logic_vector(7 DOWNTO 0)  --���������
           );
end uart;
architecture behav of uart is
component uart_rx port(clk : in  std_logic;                   --ϵͳʱ��
                       rst_n: in std_logic;                   --��λ�ź�
                       rs232_rx: in std_logic;                --RS232���������ź�
                       clk_bps: in std_logic;                 --��ʱclk_bps�ĸߵ�ƽΪ�������ݵĲ�����
                       bps_start:out std_logic;               --���յ����ݺ󣬲�����ʱ��������λ
                       rx_data: out std_logic_vector(7 downto 0);  --�������ݼĴ���������ֱ����һ����������
                       rx_int: out std_logic;                      --���������ж��źţ����������ڼ�ʱ��Ϊ�ߵ�ƽ
                       seg_data1: OUT std_logic_vector(7 DOWNTO 0);  --���������
                       seg_data2: OUT std_logic_vector(7 DOWNTO 0)  --���������
                       );
end component;

component speed_select port(clk : in  std_logic;               --ϵͳʱ��
                            rst_n: in std_logic;               --��λ�ź�
                            clk_bps: out std_logic;            --��ʱclk_bps�ĸߵ�ƽΪ���ջ��߷�������λ���м������
                            bps_start:in std_logic             --�������ݺ󣬲�����ʱ�������ź���λ
                            );
end component;

component uart_tx port(clk : in  std_logic;                    --ϵͳʱ��
                       rst_n: in std_logic;                    --��λ�ź�
                       rs232_tx: out std_logic;                --RS232���������ź�
                       clk_bps: in std_logic;                  --��ʱclk_bps�ĸߵ�ƽΪ�������ݵĲ�����
                       bps_start:out std_logic;                --���յ����ݺ󣬲�����ʱ��������λ
                       rx_data: in std_logic_vector(7 downto 0);    --�������ݼĴ���������ֱ����һ����������
                       rx_int: in std_logic                         --���������ж��źţ����������ڼ�ʱ��Ϊ�ߵ�ƽ
                       );
end component;


signal bps_start_1:std_logic;  
signal bps_start_2:std_logic;  
signal clk_bps_1:std_logic;  
signal clk_bps_2:std_logic;   
signal rx_data:std_logic_vector(7 downto 0);  
signal rx_int:std_logic;

     
begin
   RX_TOP: uart_rx port map(clk=>clk, 
                            rst_n=>rst_n,
                            rs232_rx=>rs232_rx,
                            clk_bps=>clk_bps_1,
                            bps_start=>bps_start_1,
                            rx_data=>rx_data,
                            rx_int=>rx_int,
                            seg_data1=>seg_data1,
                            seg_data2=>seg_data2
                           );
   SPEED_TOP_RX: speed_select port map(clk=>clk,
                                       rst_n=>rst_n,
                                       clk_bps=>clk_bps_1,
                                       bps_start=>bps_start_1
                                      );
   TX_TOP:uart_tx port map(clk=>clk,                          --ϵͳʱ��
                           rst_n=>rst_n,                      --��λ�ź�
                           rs232_tx=>rs232_tx,        --RS232���������ź�
                           clk_bps=>clk_bps_2,               --��ʱclk_bps�ĸߵ�ƽΪ�������ݵĲ�����
                           bps_start=>bps_start_2,     --���յ����ݺ󣬲�����ʱ��������λ
                           rx_data=>rx_data,                 --�������ݼĴ���������ֱ����һ����������
                           rx_int=>rx_int                     --���������ж��źţ����������ڼ�ʱ��Ϊ�ߵ�ƽ
                           );
   SPEED_TOP_TX: speed_select port map(clk=>clk,
                                       rst_n=>rst_n,
                                       clk_bps=>clk_bps_2,
                                       bps_start=>bps_start_2
                                      );
end behav;    