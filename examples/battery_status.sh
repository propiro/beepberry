#!/bin/bash

# this script will try to give more accurate reading of battery by doing specified amount (default 4) analog reads of battery, then averaging the output
#

# Function to read the voltage and convert to volts
read_voltage() {
    V=$(i2cget -y 1 0x1F 0x17 w | sed s/0x// | tr '[:lower:]' '[:upper:]')
    V=$(echo "obase=10; ibase=16; $V" | bc)
    voltage=$(echo "$V * 3.3 * 2 / 4095" | bc -l)
    echo "$voltage"
}

# Unload the module
sudo modprobe -r bbqX0kbd

# Take four samples and calculate the average
total_voltage=0
samples=4

for ((i=1; i<=$samples; i++)); do
    voltage=$(read_voltage)
    total_voltage=$(echo "$total_voltage + $voltage" | bc -l)
done

# Calculate the average voltage
average_voltage=$(echo "scale=4; $total_voltage / $samples" | bc -l)

# Load the module back
sudo modprobe bbqX0kbd

# Define the minimum and maximum voltage values
min_voltage=3.3
max_voltage=4.2

# Calculate the percentage
percentage=$(awk -v min=$min_voltage -v max=$max_voltage -v voltage=$average_voltage \
  'BEGIN { printf "%.1f\n", (voltage - min) / (max - min) * 100 }')

# Display the average voltage and percentage
echo "Battery: ${percentage}% (${average_voltage}V)"

