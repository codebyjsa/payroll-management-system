#!/bin/bash

read -p "Enter User ID: " USER_ID

PER_DAY_SALARY=500

ATT_FILE="data/attendance/$USER_ID.csv"
SAL_FILE="data/salary.csv"
PAYSLIP_FILE="payslips/${USER_ID}_salary_report.txt"

# get user role from users.csv
USER_ROLE=$(grep "^$USER_ID," data/users.csv | cut -d',' -f3)

# check if user exists
if [ -z "$USER_ROLE" ]
then
    echo "User not found!"
    exit 1
fi
check_date() {
    d=$(date +%d)

    if [ $d != 14 ]
    then
        echo "Salary can only be generated on 7th"
        
        exit 1 
     fi
}



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


generate_payslip() {

    mkdir -p payslips

    

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


# -------- MAIN PROGRAM --------
echo "Processing Salary..."

check_date
calculate_salary
generate_payslip

echo "Done!"