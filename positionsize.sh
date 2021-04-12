#!/bin/bash

while getopts ":ls" opt; do
  case ${opt} in
    l )   #long trade
      read -p "Risk size: " risk
      read -p "Entry (negative): " entry
      read -p "Stop (positive): " stoporder
      ;;

    s )  #short trade
      read -p "Risk size" risk
      read -p "Entry (positive): " entry
      read -p "Stop (negative): " stoporder
      ;;

    \? )
      echo "Invalid option: -$OPTARG" 1>&2
      ;;
  esac
done
echo "scale=2; $risk/($entry+$stoporder)*-1" | bc

