#!/bin/bash

USERS_FILE="data/users.csv"
ATT_DIR="data/attendance"
SALARY_FILE="data/salary.csv"

generate_user_id() {
    # Get the last ID from the first column of the last line
    last_id=$(tail -n 1 "$USERS_FILE" | cut -d',' -f1)
    if [[ "$last_id" =~ ^[0-9]+$ ]]; then
        echo $((last_id + 1))
    else
        echo 1
    fi
}

add_user() {
    read -p "Enter Name: " name
    read -p "Enter Role (admin/employee): " role
    
    uid=$(generate_user_id)
    echo "$uid,$name,$role" >> "$USERS_FILE"
    
    # Create attendance file with header
    mkdir -p "$ATT_DIR"
    echo "Date,Status" > "$ATT_DIR/$uid.csv"
    
    echo "User added successfully with ID: $uid"
}

delete_user() {
    read -p "Enter User ID to delete: " uid
    
    # Remove user from users.csv
    grep -v "^$uid," "$USERS_FILE" > "$USERS_FILE.tmp" && mv "$USERS_FILE.tmp" "$USERS_FILE"
    
    # Delete associated attendance file
    rm -f "$ATT_DIR/$uid.csv"
    
    echo "User $uid and their attendance record deleted."
}

update_user() {
    read -p "Enter User ID to update: " uid
    
    # Check if user exists
    if ! grep -q "^$uid," "$USERS_FILE"; then
        echo "User ID $uid not found!"
        return
    fi
    
    read -p "Enter New Name: " new_name
    read -p "Enter New Role: " new_role
    
    # Update entry in CSV
    sed -i "s/^$uid,.*/$uid,$new_name,$new_role/" "$USERS_FILE"
    
    echo "User $uid updated successfully."
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
    if [ -f "$SALARY_FILE" ]; then
        cat "$SALARY_FILE"
    else
        echo "No salary records found."
    fi
    echo "--------------------------"
}

admin_menu() {
    while true; do
        echo -e "\n=== ADMIN PANEL ==="
        echo "1. Add User"
        echo "2. Delete User"
        echo "3. Update User"
        echo "4. View All Records"
        echo "5. Exit"
        read -p "Select Option: " choice
        
        case $choice in
            1) add_user ;;
            2) delete_user ;;
            3) update_user ;;
            4) view_all_records ;;
            5) echo "Exiting Admin Panel..."; break ;;
            *) echo "Invalid option, please try again." ;;
        esac
    done
}

# Entry point
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    admin_menu
fi
