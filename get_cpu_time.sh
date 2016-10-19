#!/bin/bash


# retrived data: "PID 1 2 3 5 "
PIDS_RAW=$(ps aux | awk '{print $2}')

# remove PID                                                                    
PIDS=$(echo $PIDS_RAW | sed 's/PID//g')

#echo $PIDS

for pid in $PIDS
do
        #echo $pid
        stat=$(cat /proc/$pid/stat)
        echo $stat
done
