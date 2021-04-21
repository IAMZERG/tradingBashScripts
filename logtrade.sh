#!/bin/bash

while getopts ":idho" opt; do
  case ${opt} in
    i )
      read -p "Enter ticker (Syntax for option: AMD55C011623):  " ticker

      read -p  "Price Net debit/credit (short = credit; long = debit):  " price

      read -p "Number of shares (or multiplier * number of contracts for options):  " shares

      read -p  "Stop Loss (0 for no stop):  " loss

      read -p  "Take Profit (0 for no stop):  " profit

      read -p  "Closing Price:  " close

      read -p  "Open date (MMDDYY):  " opendate

      read -p  "Close date (MMDDYY):  " closedate

      read -p "Output file: " file
      ;;
    d )
      closedate=$(date '+%m%d%y')
      opendate=$(date '+%m%d%y')
      ;;
    h )
      echo " Usage:"
      echo "    logtrade [ticker] [price] [shares] [loss] [profit] [close] [opendate] [closedate]"
      echo "                         Ticker example: AMD55C011623"
      echo "                         Price will be negative for long position (net debit)"
      echo "                         Shares is number of shares (or multiplier * number of contracts for options)"
      echo "                         Loss will be positive for long position (net credit)"
      echo "                         Profit will be positive for long position (net credit)"
      echo "                         Close will be positive for long position (net credit)"
      echo "                         Open Date is the date for opening position (MMDDYY)"
      echo "                         Close Date is the date for closing position (MMDDYY)"
      echo "    logtrade -h          Display help menu"
      echo "    logtrade -i          Enter trade interactively"
      echo "    logtrade -d          Fills in open/close dates with today's date"
      exit 1
      ;;
    o )
      echo "$ticker,$price,$shares,$loss,$profit,$close,$opendate,$closedate" >> $file
      ;;
      
    \? )
      echo "Invalid option: -$OPTARG" 1>&2
      ;;

  esac
done

echo "$ticker,$price,$shares,$loss,$profit,$close,$opendate,$closedate"

