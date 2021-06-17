#!/bin/bash

FILE=./test.csv

function query_file () {
  # searches for the query specified
  # arg1--query string arg2--filename
  lines=$(grep -F "$1" $2)
  echo "$lines"
}

function split_rows () {
  # single argument - one line
  # split by comma
  local IFS=$2
  array=()
  for item in $0
  do
    array+=($item)
  done
  echo "$array"
  
}

function trade_list () {
  # generate editable list of trades
  # output is the list of trades
  zenity --list --column="Ticker" \
                --editable \
                --print-column='ALL' \
                --multiple \
                --column="Price" \
                --column="Shares" \
                --column="Stop Loss" \
                --column="Take Profit" \
                --column="Open Date" \
                --column="Close Date" \
                --column="Closing Price" \
                $@
}

function new_trade () {

  trade=$(zenity --forms --title="Create New Trade" \
    --separator="," \
    --add-entry="Ticker" \
    --add-entry="Price" \
    --add-entry="Shares" \
    --add-entry="Stop Loss" \
    --add-entry="Take Profit" \
    --add-calendar="Open Date" \
    --add-calendar="Close Date" \
    --add-entry="Closing Price")
      echo "$trade" >> ./test.csv
}
while getopts ":idhov" opt; do
  case ${opt} in
    v )
      zenity --question \
        --text="Create new trade ('no' to edit trades)?"
        case $? in
          0)
            trade=$(zenity --forms --title="Create New Trade" \
              --separator="," \
              --add-entry="Ticker" \
              --add-entry="Price" \
              --add-entry="Shares" \
              --add-entry="Stop Loss" \
              --add-entry="Take Profit" \
              --add-calendar="Open Date" \
              --add-calendar="Close Date" \
              --add-entry="Closing Price")
                          echo "$trade" >> ./test.csv
                          ;;
              
          1)
           query=$(zenity --entry \
             --title="Search query for trade(s) to modify" \
              --entry-text="$(date '+%m/%d/%Y')")

           lines=$(query_file $query $FILE)
           zenString=''
           echo "$lines"
           OIFS=$IFS
           IFS='\n'
           lines_arr=()
           for i in $lines
           do
             lines_arr+=($i)
           done
           IFS=','
           items_arr=()
           for i in "${lines_arr[@]}"
           do
             items_arr+=($i)
           done
           IFS=$OIFS
           for i in "${items_arr[@]}"
           do
             zenString+="$i "
             echo "$i"
           done


           editedTrades=$(trade_list $zenString)

          echo "Edited trades: "
          echo "$editedTrades"
          for i in ${editedTrades[@]}
          do
            matches=$(grep "$i" $FILE)
            echo "$matches"

          done
          
              ;;

          esac
          ;;

    i )
      read -p "Enter ticker (Syntax for option: AMD55C011623):  " ticker

      read -p  "Price Net debit/credit (short = credit; long = debit):  " price

      read -p "Number of shares (or multiplier * number of contracts for options):  " shares

      read -p  "Stop Loss (0 for no stop):  " loss

      read -p  "Take Profit (0 for no stop):  " profit

      read -p  "Closing Price:  " close

      read -p  "Open date (MM/DD/YYYY):  " opendate

      read -p  "Close date (MM/DD/YYYY):  " closedate

      read -p "Output file: " file
      ;;
    d )
      closedate=$(date '+%m/%d/%Y')
      opendate=$(date '+%m/%d/%Y')
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

#if [ -z  ${ticker+x} ]; then echo ""; else echo "$ticker,$price,$shares,$loss,$profit,$close,$opendate,$closedate"; fi
