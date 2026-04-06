#!/bin/bash

# -------- USER DETAILS --------
USER_ID="1"
USER_ROLE="employee"
PER_DAY_SALARY=500

# -------- FILE PATHS --------
ATT_FILE="data/attendance/$USER_ID.csv"
SAL_FILE="data/salary.csv"


# -------- FUNCTION 1: CHECK DATE --------
check_date() {
    d=$(date +%d)

    if [ $d != 07 ]
    then
        echo "Salary can only be generated on 7th"
        # exit   # disabled for testing
    fi
}


# -------- FUNCTION 2: CALCULATE SALARY --------
calculate_salary() {

    # check file exists
    if [ ! -f "$ATT_FILE" ]
    then
        echo "Attendance file not found"
        exit 1
    fi

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


# -------- FUNCTION 3: GENERATE PAYSLIP --------
generate_payslip() {

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
}


# -------- MAIN PROGRAM --------
echo "Processing Salary..."

check_date
calculate_salary
generate_payslip

echo "Done!"