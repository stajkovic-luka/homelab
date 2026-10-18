#!/bin/bash
# Author: Luka Stajkovic
# Title: Monitoring script for jump host
# Description: This script monitors RAM, disk space, CPU
# writes into /var/log/monitor.log

LOG=/var/log/monitor.log


# RAM
{
    free -m | awk 'NR > 1 {
        datum = strftime("%Y-%m-%d %H:%M:%S");
        total=$2
        used=$3
        free=$4

        # SWAP ILI MEMORY
        tag = (NR == 2) ? "[MEMORY]" : "[SWAP]";

        if (total>0){
            p1 = (used / total) * 100;
            p2 = (free / total) * 100;
            printf "Datum %s | %s Iskoriceno: %.2f%% | Slobodno: %.2f%%\n", datum, tag,p1, p2;
        }
    }'


# DISK
df -P | sed 's/%//g' |awk '!/tmpfs|overlay/ && NR>1 {
    datum = strftime("%Y-%m-%d %H:%M:%S");

    printf "Datum %s | Disk: %s | Used: %s%% | Mount: %s\n", datum ,$1, $5, $6
}'

# LOAD - petnaestominutni prosek
cores=$(nproc)
sys_load=$(awk '{print $3}' /proc/loadavg)
awk -v sys_load="$sys_load" -v cores="$cores" 'BEGIN {
    datum = strftime("%Y-%m-%d %H:%M:%S");


    printf "Datum %s | Load 15min: %.2f | Jezgra: %d | Odnos: %.2f\n",datum,sys_load,cores,sys_load/cores
}'

} >> "$LOG" 2>&1
