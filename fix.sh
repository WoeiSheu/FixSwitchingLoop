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
#while [ "$iphead" == "192" ]
while [ "$iphead" != "10." ]
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
  sudo ifconfig eth0 down
  sudo ifconfig eth0 hw ether $newmac
  sudo ifconfig eth0 up

  ### wait some time to ensure that ip will change
  sleep 2
  
  ### find new ip address
  ip=`ifconfig eth0 | awk '{print $2}' | sed -n '2p'`
  echo $ip
  iphead=${ip:0:3}
done

echo $newmac >> newmac.txt
