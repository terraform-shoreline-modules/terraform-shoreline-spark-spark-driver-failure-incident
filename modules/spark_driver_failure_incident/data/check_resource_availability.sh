

#!/bin/bash



# Check available RAM on the driver node

free_mem=$(free -m | awk '/^Mem/ {print $4}')

if [[ $free_mem -lt ${MIN_FREE_MEM_REQUIRED} ]]; then

    echo "ERROR: Insufficient free memory available on driver node."

fi



# Check available disk space on the driver node

free_space=$(df -h ${DRIVER_NODE_MOUNT_POINT} | awk '/^\/dev/ {print $4}')

if [[ $free_space -lt ${MIN_FREE_DISK_SPACE_REQUIRED} ]]; then

    echo "ERROR: Insufficient free disk space available on driver node."

fi



# Check CPU usage on the driver node

cpu_usage=$(top -b -n 1 | grep "Cpu(s)" | awk '{print $2+$4}')

if [[ $cpu_usage -gt ${MAX_CPU_USAGE_ALLOWED} ]]; then

    echo "ERROR: High CPU usage detected on driver node."

fi