#!/bin/bash


BPERC=$(cat $HOME/logs/percentage.txt | head -n1)
BVOLT=$(cat $HOME/logs/voltage.txt | head -n1)
BVOLT=$(printf "%.2f" "$BVOLT")
echo "$BPERC"% "$BVOLT"V


