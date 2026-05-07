#!/bin/bash

login_user() {
    echo "========================================"
    echo "   PAYROLL MANAGEMENT SYSTEM STARTING   "
    echo "========================================"
    echo "====== LOGIN SYSTEM ======"

    keep_asking=1

    while [ $keep_asking -eq 1 ]
    do
        echo "Enter User ID : "
        read entered_id

        echo "Enter User Name: "
        read entered_name

        file_location="data/users.csv"


        user_found=0
        matched_role=""

        while read current_line
        do
            id_from_file=`echo "$current_line" | cut -d',' -f1`
            name_from_file=`echo "$current_line" | cut -d',' -f2`
            role_from_file=`echo "$current_line" | cut -d',' -f3`

            if [ "$id_from_file" == "$entered_id" ]
            then
                if [ "$name_from_file" == "$entered_name" ]
                then
                    user_found=1
                    matched_role="$role_from_file"
                fi
            fi

        done < $file_location

        if [ $user_found -eq 1 ]
        then
            echo "Login successful!"
            echo "User ID : $entered_id"
            echo "User name : $entered_name"
            echo "Role    : $matched_role"
            
            # Set variables for main.sh
            USER_ID=$entered_id
            USER_NAME=$entered_name
            USER_ROLE=$matched_role

            # Only admin can exit system
            if [ "$matched_role" == "admin" ]
            then
                echo "Access granted (Admin)"
                break

            else
                if [ "$matched_role" == "employee" ]
                then
                    echo "Access granted (Employee)"
                    break
            fi
        fi


        else
            echo "Invalid ID or Name. Try again!"
        fi


    done
}