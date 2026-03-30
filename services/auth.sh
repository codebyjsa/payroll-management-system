#!/bin/bash

# Base directory (services folder)
BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Correct file path
USER_FILE="$BASE_DIR/data/users.csv"

# Global variables
USER_ID=""
USER_ROLE=""

# -------------------------------
# Function: check_user
# -------------------------------
check_user() {
    local INPUT_ID="$1"

    # Check file
    if [[ ! -f "$USER_FILE" ]]; then
        echo "[ERROR] User file not found!"
        return 1
    fi

    # Skip header + remove spaces
    local RECORD
    RECORD=$(tail -n +2 "$USER_FILE" | tr -d ' ' | grep "^${INPUT_ID},")

    if [[ -z "$RECORD" ]]; then
        return 1
    fi

    # Extract fields
    local ID NAME ROLE
    IFS=',' read -r ID NAME ROLE <<< "$RECORD"

    echo "$ROLE"
    return 0
}

# -------------------------------
# Function: login_user
# -------------------------------
login_user() {
    echo "====== LOGIN SYSTEM ======"

    while true; do
        echo -n "Enter Name (or type 'exitnow'): "
        read -r NAME

        if [[ "$NAME" == "exitnow" ]]; then
            echo "[INFO] Exit"
            return 1
        fi

        echo -n "Enter User ID: "
        read -r INPUT_ID

        if [[ "$INPUT_ID" == "exitnow" ]]; then
            echo "[INFO] Exit"
            return 1
        fi

        ROLE=$(check_user "$INPUT_ID")

        if [[ $? -eq 0 ]]; then
            USER_ID="$INPUT_ID"
            USER_ROLE="$ROLE"

            echo "Login successful!"
            echo "User ID : $USER_ID"
            echo "Role    : $USER_ROLE"
            return 0
        else
            echo " Invalid User ID. Try again!"
        fi
    done
}

# Auto run
login_user