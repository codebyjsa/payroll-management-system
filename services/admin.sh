#!/bin/bash

USERS_FILE="data/users.csv"
ATT_DIR="data/attendance"
SALARY_FILE="data/salary.csv"

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    while true; do
        echo -e "\n=== ADMIN PANEL ==="
        echo "1. Add User"
        echo "2. Delete User"
        echo "3. Update User"
        echo "4. View All Records"
        echo "5. Exit"
        read -p "Select Option: " choice
        
        if [ "$choice" == "1" ]; then
            read -p "Enter Name: " name
            read -p "Enter Role (admin/employee): " role
            
            last_id=$(tail -n 1 "$USERS_FILE" | cut -d',' -f1)
            if [[ "$last_id" =~ ^[0-9]+$ ]]; then
                uid=$((last_id + 1))
            else
                uid=1
            fi
            
            echo "$uid,$name,$role" >> "$USERS_FILE"
            
            mkdir -p "$ATT_DIR"
            echo "Date,Status" > "$ATT_DIR/$uid.csv"
            
            echo "User added successfully with ID: $uid"
        else
            if [ "$choice" == "2" ]; then
                read -p "Enter User ID to delete: " uid
                
                grep -v "^$uid," "$USERS_FILE" > "$USERS_FILE.tmp"
                mv "$USERS_FILE.tmp" "$USERS_FILE"
                
                rm -f "$ATT_DIR/$uid.csv"
                
                echo "User $uid and their attendance record deleted."
            else
                if [ "$choice" == "3" ]; then
                    read -p "Enter User ID to update: " uid
                    
                    if ! grep -q "^$uid," "$USERS_FILE"; then
                        echo "User ID $uid not found!"
                    else
                        read -p "Enter New Name: " new_name
                        read -p "Enter New Role: " new_role
                        
                        sed -i "s/^$uid,.*/$uid,$new_name,$new_role/" "$USERS_FILE"
                        
                        echo "User $uid updated successfully."
                    fi
                else
                    if [ "$choice" == "4" ]; then
                        echo "--------------------------"
                        echo "      ALL USERS           "
                        echo "--------------------------"
                        cat "$USERS_FILE"
                        
                        echo -e "\n--------------------------"
                        echo "   ATTENDANCE FILES       "
                        echo "--------------------------"
                        ls "$ATT_DIR"
                        
                        echo -e "\n--------------------------"
                        echo "    SALARY RECORDS        "
                        echo "--------------------------"
                        if [ -f "$SALARY_FILE" ]; then
                            cat "$SALARY_FILE"
                        else
                            echo "No salary records found."
                        fi
                        echo "--------------------------"
                    else
                        if [ "$choice" == "5" ]; then
                            echo "Exiting Admin Panel..."
                            break
                        else
                            echo "Invalid option, please try again."
                        fi
                    fi
                fi
            fi
        fi
    done
fi
