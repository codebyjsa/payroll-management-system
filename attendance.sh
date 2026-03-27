ATTENDANCE_DIR="data/attendance"

mkdir -p "$ATTENDANCE_DIR"


mark_attendance() {
    local USER_ID="$1"

    if [[ -z "$USER_ID" ]]; then
        echo "[ERROR] USER_ID is required."
        echo "Usage: mark_attendance <USER_ID>"
        return 1
    fi

    local FILE="$ATTENDANCE_DIR/${USER_ID}.csv"
    local CURRENT_DATE
    local CURRENT_TIME
    CURRENT_DATE=$(date +"%Y-%m-%d")
    CURRENT_TIME=$(date +"%H:%M:%S")

    if [[ ! -f "$FILE" ]]; then
        echo "Date,Time,Status" > "$FILE"
        echo "[INFO] Created new attendance file for user: $USER_ID"
    fi

    if grep -q "^${CURRENT_DATE}," "$FILE" 2>/dev/null; then
        echo "--------------------------------------------"
        echo " Attendance already marked for $USER_ID"
        echo " Date : $CURRENT_DATE"
        # Extract and display existing record
        local EXISTING
        EXISTING=$(grep "^${CURRENT_DATE}," "$FILE")
        echo " Record: $EXISTING"
        echo "--------------------------------------------"
        return 0
    fi

    echo "--------------------------------------------"
    echo "  Mark Attendance"
    echo "  User   : $USER_ID"
    echo "  Date   : $CURRENT_DATE"
    echo "  Time   : $CURRENT_TIME"
    echo "--------------------------------------------"
    echo "Enter Status:"
    echo "  1) Present"
    echo "  2) Absent"
    printf "Your choice [1/2]: "
    read -r CHOICE

    local STATUS
    case "$CHOICE" in
        1) STATUS="Present" ;;
        2) STATUS="Absent"  ;;
        *)
            echo "[ERROR] Invalid choice. Please enter 1 for Present or 2 for Absent."
            return 1
            ;;
    esac

    echo "${CURRENT_DATE},${CURRENT_TIME},${STATUS}" >> "$FILE"

    echo "--------------------------------------------"
    echo " [SUCCESS] Attendance marked!"
    echo "  User   : $USER_ID"
    echo "  Date   : $CURRENT_DATE"
    echo "  Time   : $CURRENT_TIME"
    echo "  Status : $STATUS"
    echo "--------------------------------------------"
    return 0
}


view_attendance() {
    local USER_ID="$1"

    # Validate USER_ID
    if [[ -z "$USER_ID" ]]; then
        echo "[ERROR] USER_ID is required."
        echo "Usage: view_attendance <USER_ID>"
        return 1
    fi

    local FILE="$ATTENDANCE_DIR/${USER_ID}.csv"

  
    if [[ ! -f "$FILE" ]]; then
        echo "[INFO] No attendance records found for user: $USER_ID"
        return 0
    fi

    local TOTAL PRESENT ABSENT
    TOTAL=$(tail -n +2 "$FILE" | wc -l | tr -d ' ')
    PRESENT=$(tail -n +2 "$FILE" | grep -c ",Present$" || true)
    ABSENT=$(tail -n +2 "$FILE" | grep -c ",Absent$" || true)

    echo "============================================"
    echo "  Attendance Report — User: $USER_ID"
    echo "============================================"
    printf "%-15s %-12s %-10s\n" "Date" "Time" "Status"
    echo "--------------------------------------------"

    while IFS=',' read -r DATE TIME STATUS; do
        printf "%-15s %-12s %-10s\n" "$DATE" "$TIME" "$STATUS"
    done < <(tail -n +2 "$FILE")

    echo "============================================"
    echo "  Summary:"
    echo "    Total Days Recorded : $TOTAL"
    echo "    Present             : $PRESENT"
    echo "    Absent              : $ABSENT"
    echo "============================================"
    return 0
}
