#!/bin/bash

cd services

source auth.sh
source attendance.sh
source salary.sh
source report.sh
source admin.sh


login_user


if [ "$USER_ROLE" == "admin" ]; then
    while true; do
        echo -e "\n--- ADMIN MENU (Admin: $USER_ID) ---"
        echo "1. Add User"
        echo "2. Delete User"
        echo "3. Update User"
        echo "4. View All Records"
        echo "5. Salary Report"
        echo "6. Exit"
        read -p "Select Option: " choice

        if [ "$choice" == "1" ]; then
            add_user
        else
            if [ "$choice" == "2" ]; then
                delete_user
            else
                if [ "$choice" == "3" ]; then
                    update_user
                else
                    if [ "$choice" == "4" ]; then
                        view_all_records
                    else
                        if [ "$choice" == "5" ]; then
                            show_report
                        else
                            if [ "$choice" == "6" ]; then
                                echo "Logging out..."
                                break
                            else
                                echo "Invalid option, try again."
                            fi
                        fi
                    fi
                fi
            fi
        fi
    done
else
    if [ "$USER_ROLE" == "employee" ]; then
        while true; do
            echo -e "\n--- EMPLOYEE MENU (User: $USER_ID) ---"
            echo "1. Mark Attendance"
            echo "2. View Attendance"
            echo "3. View Salary"
            echo "4. Monthly Stats"
            echo "5. Exit"
            read -p "Select Option: " choice

            if [ "$choice" == "1" ]; then
                mark_attendance "$USER_ID"
            else
                if [ "$choice" == "2" ]; then
                    view_attendance "$USER_ID"
                else
                    if [ "$choice" == "3" ]; then
                        calculate_salary
                    else
                        if [ "$choice" == "4" ]; then
                            calculate_monthly_stats
                        else
                            if [ "$choice" == "5" ]; then
                                echo "Logging out..."
                                break
                            else
                                echo "Invalid option, try again."
                            fi
                        fi
                    fi
                fi
            fi
        done
    else
        echo "Login failed or unknown role."
    fi
fi


echo "Thank you for using the system."
