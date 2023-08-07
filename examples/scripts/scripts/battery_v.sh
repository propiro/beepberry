#!/bin/bash


#this script provide simple voltage read and convert it to percentage value. based off documentation sample

# Unload the module
sudo modprobe -r bbqX0kbd

# Read the raw ADC value from the I2C device
V=$(i2cget -y 1 0x1F 0x17 w | sed s/0x// | tr '[:lower:]' '[:upper:]')

# Load the module back
sudo modprobe bbqX0kbd

# Convert the raw ADC value to voltage in volts
V=$(echo "obase=10; ibase=16; $V" | bc)
voltage=$(echo "$V * 3.3 * 2.1 / 4095" | bc -l | cut -c1-5)

# Define the minimum and maximum voltage values
min_voltage=3.3
max_voltage=4.2

# Calculate the percentage
percentage=$(awk -v min=$min_voltage -v max=$max_voltage -v voltage=$voltage \
  'BEGIN { printf "%.1f\n", (voltage - min) / (max - min) * 100 }')

# Display the voltage and percentage
echo "Battery Voltage: ${voltage}V"
echo "Percentage: ${percentage}%"
