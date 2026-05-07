#!/bin/bash

PER_DAY_SALARY=500

calculate_salary() {
    ATT_FILE="data/attendance/$USER_ID.csv"
    SAL_FILE="data/salary.csv"

    # count present days (P)
    present=$(grep -c "P" "$ATT_FILE")

    # total days (remove header)
    total=$(wc -l < "$ATT_FILE")
    total=$((total - 1))

    # absent days
    absent=$((total - present))

    # salary calculation
    salary=$((present * PER_DAY_SALARY))

    # current month
    month=$(date +%B)

    # store in salary.csv
    echo "$USER_ID,$month,$salary" >> "$SAL_FILE"
}

check_date() {
    read -p "Enter day (DD): " d

    if [ "$d" != "7" ]; then
        echo "Salary can only be generated on 7th"
        exit 1
    fi
}

generate_payslip() {
    MONTH=$(date +%B)
    YEAR=$(date +%Y)
    PAYSLIP_FILE="payslips/${USER_ID}_salary_${MONTH}_${YEAR}.txt"
    mkdir -p payslips

    # Just get user role
    USER_ROLE=$(grep "^$USER_ID," data/users.csv | cut -d',' -f3)

    {
        echo "---------------------------"
        echo "        PAYSLIP            "
        echo "---------------------------"
        echo "User ID      : $USER_ID"
        echo "User Role    : $USER_ROLE"
        echo "Present Days : $present"
        echo "Absent Days  : $absent"
        echo "Per Day Pay  : ₹$PER_DAY_SALARY"
        echo "Total Salary : ₹$salary"
        echo "---------------------------"
    } > "$PAYSLIP_FILE"
    
    echo ""
    echo "----- Payslip Preview -----"
    cat "$PAYSLIP_FILE"
}


if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    read -p "Enter User ID: " USER_ID
    
    USER_ROLE=$(grep "^$USER_ID," data/users.csv | cut -d',' -f3)


    echo "Processing Salary..."
    check_date
    calculate_salary
    generate_payslip
    echo "Done!"
fi