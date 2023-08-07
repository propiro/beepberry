#!/bin/sh
RAM=$(cat /proc/meminfo | grep "MemFree" | awk '{print $2}')
SWAP=$(cat /proc/meminfo | grep "SwapFree" | awk '{print $2}')
RAM_MB=$((RAM / 1024))
SWAP_MB=$((SWAP / 1024))
echo -n "${RAM_MB}MB/ram ${SWAP_MB}MB/swp"
