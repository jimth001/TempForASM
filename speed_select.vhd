library ieee;  
use ieee.std_logic_1164.all; 
use ieee.std_logic_arith.all; 
use ieee.std_logic_unsigned.all; 
entity speed_select is
      port(clk : in  std_logic;                        --ϵͳʱ��
           rst_n: in std_logic;                        --��λ�ź�
           clk_bps: out std_logic;                     --��ʱclk_bps�ĸߵ�ƽΪ���ջ��߷�������λ���м������ 
           bps_start:in std_logic;        --�������ݺ󣬲�����ʱ�������ź���λ���߿�ʼ��������ʱ��������ʱ�������ź���λ
           sw:in std_logic
           );
end speed_select;
   
architecture behav of speed_select is

signal cnt:std_logic_vector(12 downto 0); 
signal clk_bps_r:std_logic;  
shared variable BPS_PARA:integer:=5207; 
shared variable BPS_PARA_2:integer:=2603;  
--shared variable BPS:integer:=5207;
--shared variable BPS1:integer:=2603; 

begin
    process(sw)
		begin
			if (sw='0')then
				BPS_PARA:=5207;
				BPS_PARA_2:=2603;
			else
				BPS_PARA:=2603;
				BPS_PARA_2:=1301;
			end if;
	end process;
    
    process(clk,rst_n)
        begin
             if (rst_n='0')then
                  cnt<="0000000000000";
             else
                 if (rising_edge(clk)) then
                       if((cnt=BPS_PARA)or(bps_start='0')) then
                           cnt<="0000000000000";   --�����ʼ���������
                       else       cnt<=cnt+'1';    --������ʱ�Ӽ������� 
                       end if;
                 end if;
             end if;
    end process;
    
    process(clk,rst_n)
        begin
             if (rst_n='0')then
                  clk_bps_r<='0';
             else
                 if (rising_edge(clk)) then
                       if(cnt=BPS_PARA_2) then
                          clk_bps_r<='1';   --clk_bps_r�ߵ�ƽΪ��������λ���м�����㣬ͬʱҲ��Ϊ�������ݵ����ݸı�� 
                       else       clk_bps_r<='0';   --�����ʼ���������
                       end if;
                 end if; 
             end if; 
             clk_bps<=clk_bps_r;
    end process;
end behav; 