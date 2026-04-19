#!/bin/bash

# Base directory (services folder)
BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Correct file path
USER_FILE="$BASE_DIR/data/users.csv"

# Global variables
USER_ID=""
USER_ROLE=""


check_user() {
    local INPUT_ID="$1"
    local INPUT_NAME="$2"

    # Check file exists
    if [[ ! -f "$USER_FILE" ]]; then
        echo "[ERROR] User file not found!"
        return 1
    fi

    # Find record (skip header, remove spaces)
    local RECORD
    RECORD=$(tail -n +2 "$USER_FILE" | tr -d ' ' | grep "^${INPUT_ID},")

    # If ID not found
    if [[ -z "$RECORD" ]]; then
        return 1
    fi

    # Extract fields
    local ID NAME ROLE
    IFS=',' read -r ID NAME ROLE <<< "$RECORD"

    # Check name match
    if [[ "$NAME" != "$INPUT_NAME" ]]; then
        return 1
    fi

    # Return role
    echo "$ROLE"
    return 0
}


login_user() {
    echo "====== LOGIN SYSTEM ======"

    while true; do
        echo -n "Enter User ID (or type 'exitnow'): "
        read -r INPUT_ID

        # Exit condition
        if [[ "$INPUT_ID" == "exitnow" ]]; then
            echo "[INFO] Exit"
            return 1
        fi

        echo -n "Enter Name: "
        read -r INPUT_NAME

        # Check user
        ROLE=$(check_user "$INPUT_ID" "$INPUT_NAME")

        if [[ $? -ne 0 ]]; then
            echo " Invalid ID or Name. Try again!"
            continue
        fi

        # Save global values
        USER_ID="$INPUT_ID"
        USER_ROLE="$ROLE"

        echo "Login successful!"
        echo "User ID : $USER_ID"
        echo "Role    : $USER_ROLE"

        # Role check
        if [[ "$USER_ROLE" == "admin" ]]; then
            echo " Access granted (Admin)"
            return 0

        elif [[ "$USER_ROLE" == "employee" ]]; then
            echo " You don't have authority!"
            echo " Redirecting to login again..."
            continue

        else
            echo " Unknown role! Try again."
            continue
        fi
    done
}

# -------------------------------
# MAIN
# -------------------------------
login_user