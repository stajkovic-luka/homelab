#!/bin/bash
# Author: Luka Stajkovic
# Title: Monitoring script for kubernetes cluster
# Description: This script monitors RAM, disk space, CPU
# used in send-threshold-mail.sh to send email notification

NODES="192.168.0.11 192.168.0.12 192.168.0.13 192.168.0.14"
alerti=""

for h in $NODES;do

# lokalni ram
ram_metrika=$( ssh -i ~/.ssh/kubeops_ed25519 -o ConnectTimeout=5 kubeops@"$h" 2>/dev/null \
 free -m | awk 'NR == 2 {printf "%.0f", $7/$2*100}')

# ako je mrtav cvor preskoci ostale metrike
if [[ -z "$ram_metrika" ]];then
        alerti="${alerti}$h: UNREACHABLE"$'\n'
        continue
    fi

if [[ "$ram_metrika" -lt 15 ]];then
    alerti="${alerti}$h: RAM dostupno ${ram_metrika}%"$'\n'
fi

# lokalni disk
disk_metrika=$(ssh -i ~/.ssh/kubeops_ed25519 -o ConnectTimeout=5 kubeops@"$h" 2>/dev/null \
df -P / | sed 's/%//g' | awk 'NR==2 {print $5}')

if [[ $disk_metrika -gt 90 ]];then
    alerti="${alerti}$h: Disk ${disk_metrika}%"$'\n'
fi

# k3s na node provera
k3s_healthcheck_count=$(ssh -i ~/.ssh/kubeops_ed25519 -o ConnectTimeout=5 kubeops@"$h" \
systemctl is-active k3s k3s-agent 2>/dev/null | grep -c "^active$")
if [[ "$k3s_healthcheck_count" -lt 1 ]];then
    alerti="${alerti}$h: K3S nije aktivan"$'\n'

fi

done

# debug
# echo "${alerti}"
