#!/bin/bash

# Script: find-max-mtu.sh
# Author: Thomas Lutkus
# Purpose: to figure out the max MTU of a given connection

destination_ip="$1"

# Set initial packet size
packet_size=1200

# Loop to find the maximum MTU size
while true; do
  ping -4 -M do -c 1 -s $packet_size $destination_ip &> /dev/null 
  if [ $? -ne 0 ]; then
    echo "Maximum MTU size: $((packet_size + 28 - 2))"
    break
  fi
  packet_size=$((packet_size + 2))
done
