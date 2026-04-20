#!/bin/bash

# Move to the services directory where modules and data are located
cd "$(dirname "$0")/services" || exit 1

# Sourcing all modules to integrate them into a unified system
source auth.sh
source attendance.sh
source salary.sh
source report.sh
source admin.sh

# --- MENU SYSTEM ---

employee_menu() {
    while true; do
        echo -e "\n--- EMPLOYEE MENU (User: $USER_ID) ---"
        echo "1. Mark Attendance"
        echo "2. View Attendance"
        echo "3. View Salary"
        echo "4. Monthly Stats"
        echo "5. Exit"
        read -p "Select Option: " choice

        case $choice in
            1) mark_attendance "$USER_ID" ;;
            2) view_attendance "$USER_ID" ;;
            3) calculate_salary ;;
            4) calculate_monthly_stats ;;
            5) echo "Logging out..."; break ;;
            *) echo "Invalid option, try again." ;;
        esac
    done
}

admin_menu_main() {
    while true; do
        echo -e "\n--- ADMIN MENU (Admin: $USER_ID) ---"
        echo "1. Add User"
        echo "2. Delete User"
        echo "3. Update User"
        echo "4. View All Records"
        echo "5. Salary Report"
        echo "6. Exit"
        read -p "Select Option: " choice

        case $choice in
            1) add_user ;;
            2) delete_user ;;
            3) update_user ;;
            4) view_all_records ;;
            5) show_report ;;
            6) echo "Logging out..."; break ;;
            *) echo "Invalid option, try again." ;;
        esac
    done
}

# --- STARTING THE SYSTEM ---

echo "========================================"
echo "   PAYROLL MANAGEMENT SYSTEM STARTING   "
echo "========================================"

# Step 1: Login
login_user

# Step 2: Routing based on role
if [[ "$USER_ROLE" == "admin" ]]; then
    admin_menu_main
elif [[ "$USER_ROLE" == "employee" ]]; then
    employee_menu
else
    echo "Login failed or unknown role. System exiting."
    exit 1
fi

echo "Thank you for using the system."
