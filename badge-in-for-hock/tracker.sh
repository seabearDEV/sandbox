#!/bin/bash

# Detect OS and set date command format
OS_TYPE=$(uname)
if [ "$OS_TYPE" = "Darwin" ]; then
    # macOS (BSD) date commands
    date_to_seconds() {
        date -j -f "%Y-%m-%d" "$1" "+%s"
    }
    get_day_of_week() {
        date -j -f "%Y-%m-%d" "$1" "+%u"
    }
elif [ "$OS_TYPE" = "Linux" ]; then
    # GNU date commands
    date_to_seconds() {
        date -d "$1" "+%s"
    }
    get_day_of_week() {
        date -d "$1" "+%u"
    }
else
    echo "Unsupported operating system: $OS_TYPE"
    exit 1
fi

# Constants
TOTAL_WORK_DAYS=260  # 2080 hours / 8 hours per day = 260 days
REQUIRED_PRESENCE=0.8
ALLOWED_OUT_DAYS=$(echo "$TOTAL_WORK_DAYS * (1 - $REQUIRED_PRESENCE)" | bc | cut -d. -f1)
WARNING_THRESHOLD=80
CRITICAL_THRESHOLD=70

# Data file to store the days and year
DATA_FILE="$HOME/.timetracker"

# Function to get current tracking year
get_tracking_year() {
    current_month=$(date +%m)
    current_year=$(date +%Y)

    if [ "$current_month" -lt "11" ]; then
        echo "$((current_year - 1))"
    else
        echo "$current_year"
    fi
}

# Function to calculate work days between dates
calculate_work_days() {
    local start_date="$1"
    local end_date="$2"

    local start_secs=$(date_to_seconds "$start_date")
    local end_secs=$(date_to_seconds "$end_date")
    local total_days=$(( (end_secs - start_secs) / (60*60*24) + 1 ))

    # Get starting day of week (1-7, where 1 is Monday)
    local start_dow=$(get_day_of_week "$start_date")

    # Calculate full weeks and remaining days
    local full_weeks=$((total_days / 7))
    local remaining_days=$((total_days % 7))
    local work_days=$((full_weeks * 5))

    # Handle remaining days
    local current_dow=$start_dow
    for ((i=0; i<remaining_days; i++)); do
        if [ "$current_dow" -lt 6 ]; then
            ((work_days++))
        fi
        current_dow=$((current_dow % 7 + 1))
    done

    echo "$work_days"
}

# Function to calculate days since period start
calculate_days_passed() {
    local tracking_year=$1
    local start_date="${tracking_year}-11-01"
    local current_date=$(date +%Y-%m-%d)

    # If current date is before Nov 1, use previous year's Nov 1
    if [ "$(date +%Y-%m-%d)" \< "${tracking_year}-11-01" ]; then
        start_date="$((tracking_year-1))-11-01"
    fi

    calculate_work_days "$start_date" "$current_date"
}

# Function to calculate remaining work days
calculate_days_remaining() {
    local tracking_year=$1
    local end_date="$((tracking_year+1))-10-31"
    local current_date=$(date +%Y-%m-%d)

    calculate_work_days "$current_date" "$end_date"
}

# Function to check if we need to reset for new year
check_and_reset_year() {
    if [ -f "$DATA_FILE" ]; then
        saved_year=$(sed -n '2p' "$DATA_FILE")
        current_tracking_year=$(get_tracking_year)

        if [ "$saved_year" != "$current_tracking_year" ]; then
            echo "0" > "$DATA_FILE"
            echo "$current_tracking_year" >> "$DATA_FILE"
            echo "Note: Counter automatically reset for new tracking year (Nov 1, $current_tracking_year - Oct 31, $((current_tracking_year + 1)))"
        fi
    fi
}

# Create or update data file if it doesn't exist or needs year update
if [ ! -f "$DATA_FILE" ]; then
    echo "0" > "$DATA_FILE"
    get_tracking_year >> "$DATA_FILE"
fi

check_and_reset_year

# Function to calculate remaining percentage
calculate_remaining_percentage() {
    local used=$1
    # Calculate used percentage and subtract from 100
    echo "100 - ($used * 100 / $TOTAL_WORK_DAYS)" | bc | cut -d. -f1
}

# Function to display help
show_help() {
    current_tracking_year=$(get_tracking_year)
    echo "Office Time Tracker (Nov 1, $current_tracking_year - Oct 31, $((current_tracking_year + 1)))"
    echo "Usage:"
    echo "  $(basename "$0") add <days>    - Add out-of-office days (whole numbers only)"
    echo "  $(basename "$0") remove <days> - Remove out-of-office days (whole numbers only)"
    echo "  $(basename "$0") check         - Check remaining out-of-office days"
    echo "  $(basename "$0") reset         - Reset the counter"
    echo
    echo "Total allowed out-of-office days per year: $ALLOWED_OUT_DAYS"
    echo "Warning threshold: ${WARNING_THRESHOLD}%"
    echo "Critical threshold: ${CRITICAL_THRESHOLD}%"
}

# Function to read current days
get_current_days() {
    sed -n '1p' "$DATA_FILE"
}

# Function to save days
save_days() {
    local current_year=$(sed -n '2p' "$DATA_FILE")
    echo "$1" > "$DATA_FILE"
    echo "$current_year" >> "$DATA_FILE"
}

# Function to display status
display_status() {
    local used=$1
    local remaining=$2
    local remaining_percentage=$(calculate_remaining_percentage $used)
    local tracking_year=$(get_tracking_year)
    local current_date=$(date +%Y-%m-%d)
    local days_passed=$(calculate_days_passed $tracking_year)
    local days_remaining=$(calculate_days_remaining $tracking_year)

    echo "Current date: $current_date"
    echo "Tracking period: Nov 1, $tracking_year - Oct 31, $((tracking_year + 1))"
    echo "Work days passed: $days_passed"
    echo "Work days remaining: $days_remaining"
    echo "You have used $used out of $ALLOWED_OUT_DAYS allowed out-of-office days"
    echo "Remaining out-of-office days: $remaining"
    echo "Remaining office presence: ${remaining_percentage}%"

    if (( $(echo "$remaining_percentage < $CRITICAL_THRESHOLD" | bc) )); then
        echo "⚠️ CRITICAL WARNING: Office presence has fallen below ${CRITICAL_THRESHOLD}%!"
        echo "⚠️ Immediate action required to maintain minimum ${REQUIRED_PRESENCE}00% office presence requirement!"
    elif (( $(echo "$remaining_percentage < $WARNING_THRESHOLD" | bc) )); then
        echo "⚠️ WARNING: Office presence has fallen below ${WARNING_THRESHOLD}%!"
        echo "Consider adjusting your out-of-office plans to maintain minimum ${REQUIRED_PRESENCE}00% presence requirement."
    fi
}

# Main logic
case "$1" in
    "add")
        if [ -z "$2" ] || ! [[ "$2" =~ ^[0-9]+$ ]]; then
            echo "Error: Please provide a valid whole number of days"
            exit 1
        fi

        current=$(get_current_days)
        new_total=$((current + $2))
        remaining=$((ALLOWED_OUT_DAYS - new_total))

        save_days "$new_total"

        echo "Added $2 days"
        display_status $new_total $remaining
        ;;

    "remove")
        if [ -z "$2" ] || ! [[ "$2" =~ ^[0-9]+$ ]]; then
            echo "Error: Please provide a valid whole number of days"
            exit 1
        fi

        current=$(get_current_days)
        if [ "$2" -gt "$current" ]; then
            echo "Error: Cannot remove more days than currently used ($current days)"
            exit 1
        fi

        new_total=$((current - $2))
        remaining=$((ALLOWED_OUT_DAYS - new_total))

        save_days "$new_total"

        echo "Removed $2 days"
        display_status $new_total $remaining
        ;;

    "check")
        used=$(get_current_days)
        remaining=$((ALLOWED_OUT_DAYS - used))
        display_status $used $remaining
        ;;

    "reset")
        save_days "0"
        echo "Counter reset. You have $ALLOWED_OUT_DAYS days available out of office."
        display_status 0 $ALLOWED_OUT_DAYS
        ;;

    *)
        show_help
        ;;
esac
