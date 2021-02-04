for ((i=1;i<=600;i++)); 
do 
   sleep 0.1
   netstat -tnp >> log.txt
done
sort -u log.txt > log.txt
