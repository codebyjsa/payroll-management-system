#!/bin/bash

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    # Get User ID
    read -p "Enter User ID: " USER_ID
    
    # Get User Role from users.csv
    USER_ROLE=$(grep "^$USER_ID," data/users.csv | cut -d',' -f3)

    if [ -z "$USER_ROLE" ]; then
        echo "User not found!"
        exit 1
    fi
fi

calculate_monthly_stats() {
    ATT_FILE="data/attendance/$USER_ID.csv"
    if [ ! -f "$ATT_FILE" ]; then
        echo "Attendance record not found!"
        return
    fi
    
    # Count presents
    present=$(grep -c "P" "$ATT_FILE")
    # Total days (excluding header)
    total=$(tail -n +2 "$ATT_FILE" | wc -l)
    absent=$((total - present))
    
    echo "--- Monthly Stats for $USER_ID ---"
    echo "Total Presents: $present"
    echo "Total Absents : $absent"
}

salary_history() {
    echo "--- Salary History for $USER_ID ---"
    if [ ! -f "data/salary.csv" ]; then
        echo "No salary records found."
        return
    fi
    grep "^$USER_ID," data/salary.csv
}

show_report() {
    if [ "$USER_ROLE" != "admin" ]; then
        echo "Access Denied: Admin only!"
        return
    fi
    
    echo "--- All Salary Records ---"
    cat data/salary.csv
}

aggregate_attendance() {
    echo "--- Combined Attendance Report ---"
    for file in data/attendance/*.csv; do
        uid=$(basename "$file" .csv)
        p=$(grep -c "P" "$file")
        echo "User ID: $uid | Presents: $p"
    done
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    # Simple Menu for Task Execution
    echo "--------------------------"
    echo "1. Calculate Monthly Stats"
    echo "2. View Salary History"
    echo "3. Show All Reports (Admin)"
    echo "4. Aggregate Attendance"
    read -p "Choose option: " choice

    case $choice in
        1) calculate_monthly_stats ;;
        2) salary_history ;;
        3) show_report ;;
        4) aggregate_attendance ;;
        *) echo "Invalid Option" ;;
    esac
fi
