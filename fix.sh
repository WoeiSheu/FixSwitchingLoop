#!/usr/local/bin/bash

### save old mac address
oldmac=`ifconfig eth0 | awk '{print $2}' | sed -n '5p'`
echo $oldmac >> oldmac.txt

### find ip address
#ips=`hostname -I`
#iplist=($ips)
#ip=${iplist[0]}
ip=`ifconfig eth0 | awk '{print $2}' | sed -n '2p'`
echo $ip
iphead=${ip:0:3}

#ifconfig eth0 up
while [ "$iphead" != "192" ]
do
  ### generate new mac address
  rand=`cat /dev/urandom | sed 's/[^a-f0-9]//g' | strings -n 2 | head -n 6`
  #echo ${rand[@]}
  newmac=''
  for item in $rand
  do
    newmac=$newmac:$item
  done
  echo ${newmac:1}
  newmac=${newmac:1}

  ### change mac address
  ifconfig eth0 down
  ifconfig eth0 hw ether $newmac

  ### wait some time to ensure that ip will change
  sleep 6
  ifconfig eth0 up
  
  ### find new ip address
  ip=`ifconfig eth0 | awk '{print $2}' | sed -n '2p'`
  echo $ip
  iphead=${ip:0:3}
done

echo $newmac >> newmac.txt
