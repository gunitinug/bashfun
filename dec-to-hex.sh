#!/bin/bash

# dec-to-hex.sh
# converts decimal to hexadecimal
# Written by Logan Won-Ki Lee
# 3 August 2022
#
# usage:
# dec-to-hex.sh [decimal_number]
#
# actually you could do the same by: $ printf "%x\n" $decimal_number
# but this is just for a challenge ;)
# also, if you try this script with a really large number, it fails.
# probably because of limit set inside bash :-(
#
# Example:
# $ dec-to-hex.sh 999111
# dec:  999111
# hex:  f3ec7

# require at least one argument
[[ $# -lt 1 ]] && echo -e "Converts decimal to hex\nusage:\ndec-to-hex.sh [decimal number to convert]" >&2 && exit 1

decimal_number=$1

# first find max n: 16^n <= decimal_number
n=0
while [[ $(bc <<< "16 ^ $n") -le $decimal_number ]]; do
    let "n++"
done

let "n--"

# now find set of X: max x: 16^m * x <= decimal_number
# where m: {n, n-1, ... , 0}
# and decimal_number = decimal_number - digit_decimal
# where digit_decimal = 16^m * x for previous m
# and decimal_number: decimal_number >= 0

X=()
for m in `seq $n -1 0`; do
    [[ $decimal_number -lt 0 ]] && break
    #echo "m: " $m
    x=0
    f=$(bc <<< "16 ^ $m")
    digit_decimal=0
    while [[ $digit_decimal -le $decimal_number ]]; do
	#echo "x: " $x
	let "x++"
	digit_decimal=$(bc <<< "$f * $x")
    done

    let "x--"
    #echo "after x: " $x
    digit_decimal=$(bc <<< "$f * $x")
    #echo "digit decimal: " $digit_decimal

    X+=($x)
    
    #echo "decimal number: " $decimal_number
    let "decimal_number-=$digit_decimal"
done

# convert 10-15 to a-f from output
pattern='s/10/a/g;s/11/b/g;s/12/c/g;s/13/d/g;s/14/e/g;s/15/f/g'
answer=$(echo "${X[@]}" | sed "$pattern" | tr -d ' ')

echo "dec: " $1
echo "hex: " $answer
