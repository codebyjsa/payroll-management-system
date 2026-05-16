#!/bin/bash

mark_attendance() {
    empid=$USER_ID
    file="data/attendance/$empid.csv"

    date=$(date +"%Y-%m-%d")
    time=$(date +"%H:%M:%S")

    if [ ! -e "$file" ]; then
        mkdir -p data/attendance
        echo "date, time, status" > "$file"
    fi

    check=$(grep "$date" "$file")

    if [ "$check" != "" ]; then
        echo "Attendance already marked for today"
    else
        echo "$date,$time,Present" >> "$file"
        echo "Attendance marked successfully"
    fi
}

view_attendance() {
    empid=$USER_ID
    file="data/attendance/$empid.csv"

    total_days=$(tail -n +2 "$file" | wc -l)
    present=$(grep -c ",Present$" "$file")
    absent=$(grep -c ",Absent$" "$file")

    echo "Employee ID   : $empid"
    echo "Total Days    : $total_days"
    echo "Total Present : $present"
    echo "Total Absent  : $absent"
}
