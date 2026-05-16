#!/bin/bash

USERS_FILE="data/users.csv"
ATT_DIR="data/attendance"
SALARY_FILE="data/salary.csv"

add_user() {
    echo "Enter Name: "
    read name
    echo "Enter Role (admin/employee): "
    read role
    
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
}

delete_user() {
    echo "Enter User ID to delete: "
    read uid
    
    grep -v "^$uid," "$USERS_FILE" > "$USERS_FILE.tmp"
    mv "$USERS_FILE.tmp" "$USERS_FILE"
    
    rm -f "$ATT_DIR/$uid.csv"
    
    echo "User $uid and their attendance record deleted."
}

update_user() {
    echo "Enter User ID to update: "
    read uid
    
    if ! grep -q "^$uid," "$USERS_FILE"; then
        echo "User ID $uid not found!"
    else
        echo "Enter New Name: "
        read new_name
        echo "Enter New Role: "
        read new_role
        
        sed -i "s/^$uid,.*/$uid,$new_name,$new_role/" "$USERS_FILE"
        
        echo "User $uid updated successfully."
    fi
}

view_all_records() {
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
    cat "$SALARY_FILE"
    echo "--------------------------"
}

