# beepberry
![utilitarian_case_print_white.jpg](https://github.com/propiro/beepberry/blob/3a556ec64002ca9df37f7ab8232deb2f8d58547a/images/utilitarian_case_print_white.jpg)

repository with beepberry (beepy) project related files.

Beepberry is colloqiual name I like to use for beepy hardware client from here: 
https://beepy.sqfmi.com

it is supposed to run beeper:
https://beeper.notion.site/Beepy-Beeper-Client-Setup-Tutorial-a2200b76f8764813bf7a70e9f69f46b3



In this repo you might find:

examples:
- /scripts/battery_v.sh 
simple script to read battery voltage through analog pin of rpi2040

- /scripts/battery_status.sh
bit more advanced battery reading, with percentage output and sampling analog read

- /scripts/battery_rgb.sh
same as above, but now uses rgb to communicate battery status

- /scripts/rgb_led_functions.sh
sample functions for interacting with beepberry RGB led
![beepy_rgb.gif](https://github.com/propiro/beepberry/blob/3a556ec64002ca9df37f7ab8232deb2f8d58547a/images/beepy_rgb.gif)


- .bashrc
few usefull aliases, one being 'testbatt' - if you run it in background (screen is your friend), it'll periodically update /logs/percentage.txt, /logs/voltage.txt, /logs/battery_log.txt
for other scripts to use, for example:

- /scripts/batinfo.sh
used to output formatted message about percentage of battery and its voltage

- .screen.rs 
example use of backtick and batinfo.sh - it feeds the data of battery status  (as well memory usage through meminfo.sh) to screen hardstatus, giving a nice overview of beeply
![screen_hardstatus.png](https://github.com/propiro/beepberry/blob/3a556ec64002ca9df37f7ab8232deb2f8d58547a/images/screen_hardstatus.png)

3d case model files:
- bottom.obj, top.obj
 obj exports for slicer of utilitarian beepy case design, see photos.
![utilitarian_case_print_white.jpg](https://github.com/propiro/beepberry/blob/3a556ec64002ca9df37f7ab8232deb2f8d58547a/images/utilitarian_case_print_white.jpg)

![utilitarian_case_project_3d.jpg](https://github.com/propiro/beepberry/blob/3a556ec64002ca9df37f7ab8232deb2f8d58547a/images/utilitarian_case_project_3d.jpg)

- beepberry_case01.max.7z
  source in 3ds max 2024 format
- slicer_project_transparent/case_rotation_hexes_aligned.3mf
  prusa 2.6 project with settings set up for transparent printing, so you can get results closer to mine.

![transparent_case_print.gif](https://github.com/propiro/beepberry/blob/3a556ec64002ca9df37f7ab8232deb2f8d58547a/images/transparent_case_print.gif)

To get best results, experiment with cooling (less is better) and extrusion flow multiplier (more is better, I get decent results at 1.06)
