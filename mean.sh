#!/bin/bash

if [ "$#" -lt 1 ] || [ "$#" -gt 2 ]; then
    echo "usage: $0 <column> [file.csv]" 1>&2
    exit 1
fi

column=$1

if [ "$#" -eq 2 ]; then
    file=$2
else
    file=/dev/stdin
fi

cut -d',' -f"$column" "$file" | tail -n +2 | {
    sum=0
    count=0

    while read -r value; do
        sum=$(echo "$sum + $value" | bc -l)
        count=$((count + 1))
    done

    if [ "$count" -eq 0 ]; then
        echo "no data" 1>&2
        exit 1
    fi

    echo "$sum / $count" | bc -l
}
