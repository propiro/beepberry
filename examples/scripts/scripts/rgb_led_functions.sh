#!/bin/bash

#this script contains absolute basic functions to play with rgb led:
#unloading keyboard from i2c
#turning led on
#setting its color
#pingponging to value
#pingponging between values
#flashing between to colors
#turning led off
#loading keyboard back to i2c
#
#uncomment functions at below of this script and run it to see led work

unload_kbd_from_i2c() {
    sudo modprobe -r bbqX0kbd
}

load_kbd_to_i2c() {
    sudo modprobe bbqX0kbd
}

led_on() {
    sudo i2cset -y 1 0x1F 0xA0 0xFF
}

led_colorset() {
    # $1 = red (0-255)
    # $2 = green (0-255)
    # $3 = blue (0-255)

    red=$1
    green=$2
    blue=$3

    sudo i2cset -y 1 0x1F 0xA1 "$red"
    sudo i2cset -y 1 0x1F 0xA2 "$green"
    sudo i2cset -y 1 0x1F 0xA3 "$blue"
}

led_off() {
    sudo i2cset -y 1 0x1F 0xA0 0x00
}

delay() {
    delay_ms=$(( $1 ))
    sleep "$(bc <<< "scale=3; $delay_ms/1000")"
}

# Function to smoothly transition the RGB LED between two colors
pingpong_rgb_led() {
    # $1 = starting color (an array with three values for red, green, and blue)
    # $2 = ending color (an array with three values for red, green, and blue)
    # $3 = duration of transition (in milliseconds)
    # $4 = number of steps during transition

    # Turn the LED on before the color transition
    led_colorset "$1" 0

    # Extract the red, green, and blue values from the starting color
    IFS=' ' read -r -a start_color <<< "$1"
    start_red=${start_color[0]}
    start_green=${start_color[1]}
    start_blue=${start_color[2]}

    # Extract the red, green, and blue values from the ending color
    IFS=' ' read -r -a end_color <<< "$2"
    end_red=${end_color[0]}
    end_green=${end_color[1]}
    end_blue=${end_color[2]}

    # Calculate the color step for each component
    steps=$(( $4 - 1 ))  # Total steps, excluding the start and end colors
    step_red=$(echo "scale=2; ($end_red - $start_red) / $steps" | bc)
    step_green=$(echo "scale=2; ($end_green - $start_green) / $steps" | bc)
    step_blue=$(echo "scale=2; ($end_blue - $start_blue) / $steps" | bc)

    # Calculate the delay between each step, with a minimum of 50ms
    min_delay=50
    delay=$(echo "scale=2; $3 / $4" | bc)
    if (( $(bc <<< "$delay < $min_delay") )); then
        delay=$min_delay
    fi

    led_on

    # Loop through the color transitions
    for ((i = 0; i < $4; i++)); do
        red=$(echo "scale=0; ($start_red + $i * $step_red) / 1" | bc)
        green=$(echo "scale=0; ($start_green + $i * $step_green) / 1" | bc)
        blue=$(echo "scale=0; ($start_blue + $i * $step_blue) / 1" | bc)

        # Set the current color using the led_colorset function
        led_colorset "$red" "$green" "$blue" 0

        # Wait for the specified delay (converted to seconds)
        sleep "$(echo "scale=3; $delay/1000" | bc)"
    done

    led_off
    # Turn the LED off after the transition
}

# Function to flash between two colors without blending
flash_between_colors() {
    # $1 = starting red value (0-255)
    # $2 = starting green value (0-255)
    # $3 = starting blue value (0-255)
    # $4 = ending red value (0-255)
    # $5 = ending green value (0-255)
    # $6 = ending blue value (0-255)
    # $7 = number of times to flash between the colors
    # $8 = delay between blinks

    for ((i = 0; i < $7; i++)); do
        led_off

        # Turn the LED on with the starting color
        led_colorset "$1" "$2" "$3"
        led_on
        delay $8

        # Turn the LED off after a very short delay (you can adjust this as needed)
        led_off

        # Turn the LED on with the ending color
        led_colorset "$4" "$5" "$6"
        led_on
        delay $8
    done

    led_off
}

# Function to smoothly transition the RGB LED between two colors and back to the starting color
pingpong_back_rgb_led() {
    # $1 = starting color (an array with three values for red, green, and blue)
    # $2 = ending color (an array with three values for red, green, and blue)
    # $3 = duration of each transition (in milliseconds)
    # $4 = number of steps during each transition

    # Transition to the ending color using the pingpong_rgb_led function
    pingpong_rgb_led "$1" "$2" "$3" "$4"

    # Transition back to the starting color using the pingpong_rgb_led function
    pingpong_rgb_led "$2" "$1" "$3" "$4"
}

# Function to smoothly transition the RGB LED between two colors
pingpong_rgb_led() {
    # $1 = starting color (an array with three values for red, green, and blue)
    # $2 = ending color (an array with three values for red, green, and blue)
    # $3 = duration of transition (in milliseconds)
    # $4 = number of steps during transition

    # Turn the LED on before the color transition
   # led_colorset "$1" 0


    # Extract the red, green, and blue values from the starting color
    IFS=' ' read -r -a start_color <<< "$1"
    start_red=${start_color[0]}
    start_green=${start_color[1]}
    start_blue=${start_color[2]}

    # Extract the red, green, and blue values from the ending color
    IFS=' ' read -r -a end_color <<< "$2"
    end_red=${end_color[0]}
    end_green=${end_color[1]}
    end_blue=${end_color[2]}

    # Calculate the color step for each component
    steps=$(( $4 - 1 ))  # Total steps, excluding the start and end colors
    step_red=$(echo "scale=2; ($end_red - $start_red) / $steps" | bc)
    step_green=$(echo "scale=2; ($end_green - $start_green) / $steps" | bc)
    step_blue=$(echo "scale=2; ($end_blue - $start_blue) / $steps" | bc)

    # Calculate the delay between each step, with a minimum of 50ms
    min_delay=50
    delay=$(echo "scale=2; $3 / $4" | bc)
    if (( $(bc <<< "$delay < $min_delay") )); then
        delay=$min_delay
    fi

    led_on

    # Loop through the color transitions
    for ((i = 0; i < $4; i++)); do
        red=$(echo "scale=0; ($start_red + $i * $step_red) / 1" | bc)
        green=$(echo "scale=0; ($start_green + $i * $step_green) / 1" | bc)
        blue=$(echo "scale=0; ($start_blue + $i * $step_blue) / 1" | bc)

        # Set the current color using the led_colorset function
        led_colorset "$red" "$green" "$blue" 0

        # Wait for the specified delay (converted to seconds)
        sleep "$(echo "scale=3; $delay/1000" | bc)"
    done

    led_off
    # Turn the LED off after the transition
}

unload_kbd_from_i2c

#uncomment any below to test functions

flash_between_colors 255 0 0 0 0 255 5 100
pingpong_rgb_led "255 0 0" "0 0 255" 20 20
#pingpong_back_rgb_led "255 0 0" "0 0 255" 20 20

load_kbd_to_i2c


#procedures to flash rgb led white for 500ms
#unload_kbd_from_i2c
#led_colorset 255 255 255
#led_on
#delay 500
#led_off
#load_kbd_to_i2c


