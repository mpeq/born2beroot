#!/bin/bash
arch=$(uname -a)

cpu=$(nproc)
v_cpu=$(cat /proc/cpuinfo | grep "processor" | wc -l)

used_mem=$(free --mega | awk '$1 == "Mem:" {print $3}')
total_mem=$(free --mega | awk '$1 == "Mem:" {print $2}')
p_mem=$(free --mega | awk '$1 == "Mem:" {printf("%.2f"), $3/$2*100}')

used_dsk=$(df -hBM --total | grep "total" | tr -d 'M' | awk '{print $3}')
total_dsk=$(df -h --total | awk '$1 == "total" {print $2}')
p_dsk=$(df -h --total | awk '$1 == "total" {printf("%.2f"), $3/$2*100}')

cpu_load=$(top -bn1 | awk 'NR == 3 {printf("%.2f"), $2 + $4}')

last_boot=$(who -b | awk '$1 == "system" {print $3 " " $4}')

lvm_count=$(lsblk | grep "lvm" | wc -l)
lvm=$(if [$lvm_count -eq 0]; then echo "no"; else echo "yes"; fi)

n_tcp=$(ss -s | grep "TCP:" | tr -d ',' | awk '{print $4}')

n_user=$(users | wc -w)

ip=$(hostname -I)
mac=$(ip link show | awk '$1 == "link/ether" {print $2}')

n_cmd=$(journalctl _COMM=sudo | grep "COMMAND" | wc -l)

wall "  #Architecture: $arch
        #CPU physical: $cpu
        #vCPU: $v_cpu
        #Memory Usage: $used_mem/${total_mem}MB ($p_mem%)
        #Disk Usage: $used_dsk/${total_dsk}GB ($p_dsk%)
        #CPU load: $cpu_load%
        #Last boot: $last_boot
        #LVM use: $lvm
        #Connexions TCP: $n_tcp ESTABLISHED
        #User log: $n_user
        #Network: IP $ip ($mac)
        #Sudo: $n_cmd cmd"
