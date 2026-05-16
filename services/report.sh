#!/bin/bash

calculate_monthly_stats() {
    ATT_FILE="data/attendance/$USER_ID.csv"

    # Count presents
    present=$(grep -c "Present" "$ATT_FILE")
    # Total days (excluding header)
    total=$(tail -n +2 "$ATT_FILE" | wc -l)
    absent=$((total - present))
    salary=$((present * 500))
    
    echo "--- Monthly Stats for $USER_ID ---"
    echo "Total Presents: $present"
    echo "Total Absents : $absent"
    echo "Total Salary  : ₹$salary"
}


show_report() {
    echo "--- All Salary Records ---"
    cat data/salary.csv
}

