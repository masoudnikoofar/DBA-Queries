#!/bin/bash
#This script will kill other session than you
CRS_HOME=/u01/crs/oracle/product/11gr2
killsess() {
MT=`who am i|awk '{print $2}'`
for OT in `who|awk '{print $2}'|grep -v $MT`
    do
      pkill -KILL -t $OT
    done
pkill -KILL -t $MT
if (test ! `who|awk '{print $2}'`)
  then
     echo "There is not any other session"
else 
     echo "There are some open session!!!!!"
fi
}   

tzsp(){
      if (ls /usr/share/zoneinfo/Etc/GMT+4:30 > /dev/null)
       then
        cp /usr/share/zoneinfo/Etc/GMT+4:30 /etc/localtime
        if(ls /etc/timezone > /dev/null) then
           sed -i 's/GMT+3:30/GMT+4:30/' /etc/timezone 
           logger -t CHANGE_TIMEZONE The system timezone changed to Etc/GMT+4:30
        else 
           cp /home/Script/Time/timezone /etc/timezone
           sed -i 's/GMT+3:30/GMT+4:30/' /etc/timezone
           logger -t CHANGE_TIMEZONE The system timezone changed to Etc/GMT+4:30
        fi
      else
       cp /home/Script/Time/GMT+4:30 /usr/share/zoneinfo/Etc/
       cp /usr/share/zoneinfo/Etc/GMT+4:30 /etc/localtime
       if(ls /etc/timezone > /dev/null) then
           sed -i 's/GMT+3:30/GMT+4:30/' /etc/timezone
           logger -t CHANGE_TIMEZONE The system timezone changed to Etc/GMT+4:30
       else
           cp /home/Script/Time/timezone /etc/timezone
           sed -i 's/GMT+3:30/GMT+4:30/' /etc/timezone
           logger -t CHANGE_TIMEZONE The system timezone changed to Etc/GMT+4:30
        fi
     fi
     OHOST=`hostname|tr '[:upper:]' '[:lower:]'`
     cd $CRS_HOME/crs/install
     sed -i "s/Etc\/GMT+3:30/Etc\/GMT+4:30/" "s_crsconfig_"$OHOST"_env.txt"
}

tzfa(){
      if (ls /usr/share/zoneinfo/Etc/GMT+3:30 > /dev/null)
       then
        cp /usr/share/zoneinfo/Etc/GMT+3:30 /etc/localtime
        if(ls /etc/timezone > /dev/null) then
           sed -i 's/GMT+4:30/GMT+3:30/' /etc/timezone
           logger -t CHANGE_TIMEZONE The system timezone changed to Etc/GMT+3:30
        else
           cp /home/Script/Time/timezone /etc/timezone
           sed -i 's/GMT+4:30/GMT+3:30/' /etc/timezone
           logger -t CHANGE_TIMEZONE The system timezone changed to Etc/GMT+3:30 
        fi
      else
       cp /home/Script/Time/GMT+3:30 /usr/share/zoneinfo/Etc/
       cp /usr/share/zoneinfo/Etc/GMT+3:30 /etc/localtime
       if(ls /etc/timezone > /dev/null) then
           sed -i 's/GMT+4:30/GMT+3:30/' /etc/timezone
           logger -t CHANGE_TIMEZONE The system timezone changed to Etc/GMT+3:30
        else
           cp /home/Script/Time/timezone /etc/timezone
           sed -i 's/GMT+4:30/GMT+3:30/' /etc/timezone
           logger -t CHANGE_TIMEZONE The system timezone changed to Etc/GMT+3:30
        fi
     fi
     OHOST=`hostname|tr '[:upper:]' '[:lower:]'`
     cd $CRS_HOME/crs/install
     sed -i "s/Etc\/GMT+4:30/Etc\/GMT+3:30/" "s_crsconfig_"$OHOST"_env.txt"
}
chtz(){
  case $1 in
    1)
        echo "The Timezone will be changed to GMT+4:30"
        tzsp
     ;;
    2)
        echo "The Timezone will be changed to GMT+3:30"
        tzfa
     ;;
    *)
        echo "You should execute the script with correct Season!!!!!"
     ;;
    esac
}

chtz $1
echo "The Timezone changed"
echo "The Current Session Will be closed!"
echo "Please Open New Session"
killsess
