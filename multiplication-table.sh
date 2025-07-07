#!/bin/bash

# Function to display full multiplication table
display_full_table() {
    local num=$1
    local order=$2
    local format=$3
    
    echo "The full multiplication table for $num:"
    
    if [ "$order" == "desc" ]; then
        # Descending order using for loop
        for ((i=10; i>=1; i--)); do
            result=$((num * i))
            display_formatted_line $num $i $result $format
        done
    else
        # Ascending order using for loop
        for ((i=1; i<=10; i++)); do
            result=$((num * i))
            display_formatted_line $num $i $result $format
        done
    fi
}

# Function to display partial multiplication table
display_partial_table() {
    local num=$1
    local start=$2
    local end=$3
    local order=$4
    local format=$5
    
    echo "The partial multiplication table for $num from $start to $end:"
    
    if [ "$order" == "desc" ]; then
        # Descending order using for loop
        for ((i=end; i>=start; i--)); do
            result=$((num * i))
            display_formatted_line $num $i $result $format
        done
    else
        # Ascending order using for loop
        for ((i=start; i<=end; i++)); do
            result=$((num * i))
            display_formatted_line $num $i $result $format
        done
    fi
}

# Function to display formatted line based on style
display_formatted_line() {
    local num=$1
    local multiplier=$2
    local result=$3
    local format=$4
    
    if [ "$format" == "arrows" ]; then
        echo "$num --> $multiplier = $result"
    elif [ "$format" == "brackets" ]; then
        echo "[$num] x [$multiplier] = [$result]"
    elif [ "$format" == "dots" ]; then
        echo "$num • $multiplier = $result"
    elif [ "$format" == "boxed" ]; then
        echo "┌─────────────────────┐"
        echo "│ $num × $multiplier = $result $(printf "%*s" $((17 - ${#num} - ${#multiplier} - ${#result})) "")│"
        echo "└─────────────────────┘"
    else
        # Default format
        echo "$num x $multiplier = $result"
    fi
}

# Function to get display preferences
get_display_preferences() {
    echo ""
    echo "Choose display options:"
    echo "1. Order: (a)scending or (d)escending"
    echo -n "Enter your choice (a/d): "
    read order_choice
    
    echo ""
    echo "2. Format style:"
    echo "   1. Standard (3 x 4 = 12)"
    echo "   2. Arrows (3 --> 4 = 12)"
    echo "   3. Brackets ([3] x [4] = [12])"
    echo "   4. Dots (3 • 4 = 12)"
    echo "   5. Boxed (fancy border)"
    echo -n "Enter format choice (1-5): "
    read format_choice
    
    # Set order preference using if-else
    if [ "$order_choice" == "d" ] || [ "$order_choice" == "D" ]; then
        ORDER="desc"
    else
        ORDER="asc"
    fi
    
    # Set format preference using if-else
    if [ "$format_choice" == "2" ]; then
        FORMAT="arrows"
    elif [ "$format_choice" == "3" ]; then
        FORMAT="brackets"
    elif [ "$format_choice" == "4" ]; then
        FORMAT="dots"
    elif [ "$format_choice" == "5" ]; then
        FORMAT="boxed"
    else
        FORMAT="standard"
    fi
}

# Function to validate number input
validate_number() {
    local input=$1
    local min=$2
    local max=$3
    
    if [[ ! $input =~ ^[0-9]+$ ]] || [ $input -lt $min ] || [ $input -gt $max ]; then
        return 1
    fi
    return 0
}

# Main script
echo -n "Enter a number for the multiplication table: "
read number

# Validate the main number input
if ! validate_number "$number" 1 999; then
    echo "Invalid input. Please enter a valid number."
    exit 1
fi

echo -n "Do you want a full table or a partial table? (Enter 'f' for full, 'p' for partial): "
read choice

# Get display preferences
get_display_preferences

case $choice in
    f|F)
        display_full_table $number $ORDER $FORMAT
        ;;
    p|P)
        echo -n "Enter the starting number (between 1 and 10): "
        read start
        
        echo -n "Enter the ending number (between 1 and 10): "
        read end
        
        # Validate start and end numbers
        if ! validate_number "$start" 1 10 || ! validate_number "$end" 1 10; then
            echo "Invalid input. Numbers must be between 1 and 10."
            echo "Invalid range. Showing full table instead."
            display_full_table $number $ORDER $FORMAT
        elif [ $start -gt $end ]; then
            echo "Invalid range. Showing full table instead."
            display_full_table $number $ORDER $FORMAT
        else
            display_partial_table $number $start $end $ORDER $FORMAT
        fi
        ;;
    *)
        echo "Invalid choice. Please enter 'f' for full or 'p' for partial."
        exit 1
        ;;
esac
