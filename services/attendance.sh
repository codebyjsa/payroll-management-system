#!/bin/bash

mkdir -p attendance_data

echo "1. Mark Attendance"
echo "2. Show Summary"
echo "Enter your choice:"
read choice

if [ "$choice" = "1" ]
then
    echo "Enter Employee ID:"
    read empid

    date=$(date +"%Y-%m-%d")
    time=$(date +"%H:%M:%S")

    file="attendance_data/$empid.csv"

if [ ! -e "$file" ]
then
    echo "Date,Time,Status" > "$file"
fi

check=$(grep "$date" "$file")

if [ "$check" != "" ]
then
    echo "Attendance already marked for today"

else
    echo "$date,$time,Present" >> "$file"
    echo "Attendance marked successfully"
fi


elif [ "$choice" = "2" ]
then
    echo "Enter Employee ID:"
    read empid

    file="attendance_data/$empid.csv"

    present=$(grep "Present" "$file")

    total=$(echo "$present" | wc -l)

    echo "Employee ID : $empid"
    echo "Total Present : $total"

else
    echo "Invalid Choice"
fi
