library ieee;
use ieee.std_logic_1164.all; 
use ieee.std_logic_arith.all; 
use ieee.std_logic_unsigned.all; 
entity uart is
      port(clk : in  std_logic;                        --系统时钟
           rst_n: in std_logic;                        --复位信号
           rs232_rx: in std_logic;                     --RS232接收数据信号;
           rs232_tx: out std_logic;                    --RS232发送数据信号;
           seg_data1: OUT std_logic_vector(7 DOWNTO 0);  --数码管数据
           seg_data2: OUT std_logic_vector(7 DOWNTO 0)  --数码管数据
           );
end uart;
architecture behav of uart is
component uart_rx port(clk : in  std_logic;                   --系统时钟
                       rst_n: in std_logic;                   --复位信号
                       rs232_rx: in std_logic;                --RS232接收数据信号
                       clk_bps: in std_logic;                 --此时clk_bps的高电平为接收数据的采样点
                       bps_start:out std_logic;               --接收到数据后，波特率时钟启动置位
                       rx_data: out std_logic_vector(7 downto 0);  --接收数据寄存器，保存直至下一个数据来到
                       rx_int: out std_logic;                      --接收数据中断信号，接收数据期间时钟为高电平
                       seg_data1: OUT std_logic_vector(7 DOWNTO 0);  --数码管数据
                       seg_data2: OUT std_logic_vector(7 DOWNTO 0)  --数码管数据
                       );
end component;

component speed_select port(clk : in  std_logic;               --系统时钟
                            rst_n: in std_logic;               --复位信号
                            clk_bps: out std_logic;            --此时clk_bps的高电平为接收或者发送数据位的中间采样点
                            bps_start:in std_logic             --接收数据后，波特率时钟启动信号置位
                            );
end component;

component uart_tx port(clk : in  std_logic;                    --系统时钟
                       rst_n: in std_logic;                    --复位信号
                       rs232_tx: out std_logic;                --RS232接收数据信号
                       clk_bps: in std_logic;                  --此时clk_bps的高电平为接收数据的采样点
                       bps_start:out std_logic;                --接收到数据后，波特率时钟启动置位
                       rx_data: in std_logic_vector(7 downto 0);    --接收数据寄存器，保存直至下一个数据来到
                       rx_int: in std_logic                         --接收数据中断信号，接收数据期间时钟为高电平
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
   TX_TOP:uart_tx port map(clk=>clk,                          --系统时钟
                           rst_n=>rst_n,                      --复位信号
                           rs232_tx=>rs232_tx,        --RS232发送数据信号
                           clk_bps=>clk_bps_2,               --此时clk_bps的高电平为发送数据的采样点
                           bps_start=>bps_start_2,     --接收到数据后，波特率时钟启动置位
                           rx_data=>rx_data,                 --接收数据寄存器，保存直至下一个数据来到
                           rx_int=>rx_int                     --接收数据中断信号，接收数据期间时钟为高电平
                           );
   SPEED_TOP_TX: speed_select port map(clk=>clk,
                                       rst_n=>rst_n,
                                       clk_bps=>clk_bps_2,
                                       bps_start=>bps_start_2
                                      );
end behav;    