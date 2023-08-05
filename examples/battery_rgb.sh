#!/bin/bash

#this script will:
#read voltage of battery
#convert it to percentage, assuming 3v is 0%, 3.7 is 100%
#flash led to color according to percentage >70 / 75-30 / <30


# Function to read the voltage and convert to volts
read_voltage() {
    V=$(i2cget -y 1 0x1F 0x17 w | sed s/0x// | tr '[:lower:]' '[:upper:]')
    V=$(echo "obase=10; ibase=16; $V" | bc)
    voltage=$(echo "$V * 3.3 * 2 / 4095" | bc -l)
    echo "$voltage"
}

blink_rgb() {
    # $1 = red (0-255)
    # $2 = green (0-255)
    # $3 = blue (0-255)
    # $4 = delay (in milliseconds)
    red=$1
    green=$2
    blue=$3
    delay_ms=$(( $4 ))

    sudo modprobe -r bbqX0kbd
    sudo i2cset -y 1 0x1F 0xA1 "$red"
    sudo i2cset -y 1 0x1F 0xA2 "$green"
    sudo i2cset -y 1 0x1F 0xA3 "$blue"
    sudo i2cset -y 1 0x1F 0xA0 0xFF
    sleep "$(bc <<< "scale=3; $delay_ms/1000")"
    sudo i2cset -y 1 0x1F 0xA0 0x00
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


# Define the minimum and maximum voltage values
min_voltage=3.0
max_voltage=3.7

# Calculate the percentage
percentage=$(awk -v min=$min_voltage -v max=$max_voltage -v voltage=$average_voltage \
  'BEGIN { printf "%.1f\n", (voltage - min) / (max - min) * 100 }')

# Display the average voltage and percentage
echo "Average Battery Voltage: ${average_voltage}V"
echo "Percentage: ${percentage}%"

# Set the LED color based on the battery percentage
if (( $(bc <<< "$percentage < 30") )); then
    blink_rgb 255 0 0 500   # Red
elif (( $(bc <<< "$percentage >= 30 && $percentage <= 75") )); then
    blink_rgb 255 255 0 500   # Yellow
else
    blink_rgb 0 255 0 500   # Green
fi

#load kbd module back
sudo modprobe bbqX0kbd


