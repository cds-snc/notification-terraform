#!/bin/bash

# Enhanced script to extract Terraform plan content from log files
# Can handle multiple plan sections and provides additional options
# Usage: ./extract_terraform_plan_enhanced.sh <log_file> [options]

# Default values
OUTPUT_FILE=""
PLAN_NUMBER=0  # 0 = all plans, 1 = first plan, 2 = second plan, etc.
QUIET=false

# Function to show usage
show_usage() {
    cat << EOF
Usage: $0 <log_file> [options]

Options:
  -o, --output FILE     Save output to FILE instead of stdout
  -n, --plan-number N   Extract only the Nth plan (1-based index, 0 = all plans)
  -q, --quiet          Suppress informational messages
  -h, --help           Show this help message

Examples:
  $0 terraform.log                           # Extract all plans to stdout
  $0 terraform.log -o plans.txt              # Extract all plans to file
  $0 terraform.log -n 1                      # Extract only the first plan
  $0 terraform.log -n 2 -o second_plan.txt   # Extract second plan to file
EOF
}

# Parse command line arguments
POSITIONAL=()
while [[ $# -gt 0 ]]; do
    case $1 in
        -o|--output)
            OUTPUT_FILE="$2"
            shift 2
            ;;
        -n|--plan-number)
            PLAN_NUMBER="$2"
            shift 2
            ;;
        -q|--quiet)
            QUIET=true
            shift
            ;;
        -h|--help)
            show_usage
            exit 0
            ;;
        -*)
            echo "Unknown option: $1"
            show_usage
            exit 1
            ;;
        *)
            POSITIONAL+=("$1")
            shift
            ;;
    esac
done

# Restore positional parameters
set -- "${POSITIONAL[@]}"

# Check if log file is provided
if [ $# -eq 0 ]; then
    echo "Error: Log file is required."
    show_usage
    exit 1
fi

LOG_FILE="$1"

# Check if the log file exists
if [ ! -f "$LOG_FILE" ]; then
    echo "Error: Log file '$LOG_FILE' not found."
    exit 1
fi

# Validate plan number
if ! [[ "$PLAN_NUMBER" =~ ^[0-9]+$ ]]; then
    echo "Error: Plan number must be a non-negative integer."
    exit 1
fi

# Function to extract terraform plans
extract_plans() {
    local input_file="$1"
    local plan_num="$2"
    local current_plan=0
    local in_plan=false
    local line_buffer=""
    
    while IFS= read -r line; do
        if [[ "$line" == "Terraform will perform the following actions:" ]]; then
            current_plan=$((current_plan + 1))
            in_plan=true
            line_buffer="$line"
            
            # If we want a specific plan and this isn't it, skip
            if [[ $plan_num -gt 0 && $current_plan -ne $plan_num ]]; then
                in_plan=false
                continue
            fi
            
        elif [[ "$line" =~ ^Plan:\ [0-9]+\ to\ add,\ [0-9]+\ to\ change,\ [0-9]+\ to\ destroy\.$ ]]; then
            if [[ "$in_plan" == true ]]; then
                # Output the buffered content plus this final line
                echo "$line_buffer"
                echo "$line"
                
                # Add separator if extracting all plans and there might be more
                if [[ $plan_num -eq 0 && $current_plan -gt 0 ]]; then
                    echo ""
                    echo "# --- End of Plan $current_plan ---"
                    echo ""
                fi
                
                line_buffer=""
                in_plan=false
                
                # If we wanted a specific plan and got it, we're done
                if [[ $plan_num -gt 0 && $current_plan -eq $plan_num ]]; then
                    return 0
                fi
            fi
            
        elif [[ "$in_plan" == true ]]; then
            # Accumulate lines while in a plan
            line_buffer="$line_buffer"$'\n'"$line"
        fi
    done < "$input_file"
    
    # Handle case where file ends while in a plan (incomplete plan)
    if [[ "$in_plan" == true && -n "$line_buffer" ]]; then
        echo "$line_buffer"
        if [[ "$QUIET" == false ]]; then
            echo "Warning: Plan $current_plan appears to be incomplete (no closing Plan: line found)" >&2
        fi
    fi
    
    # Check if requested plan number was found
    if [[ $plan_num -gt 0 && $current_plan -lt $plan_num ]]; then
        if [[ "$QUIET" == false ]]; then
            echo "Warning: Only $current_plan plan(s) found in the log file, but plan $plan_num was requested." >&2
        fi
        return 1
    fi
    
    return 0
}

# Extract the plan(s)
if [ -n "$OUTPUT_FILE" ]; then
    # Output to file
    extract_plans "$LOG_FILE" "$PLAN_NUMBER" > "$OUTPUT_FILE"
    exit_code=$?
    if [[ "$QUIET" == false ]]; then
        if [[ $PLAN_NUMBER -eq 0 ]]; then
            echo "All Terraform plans extracted to: $OUTPUT_FILE"
        else
            echo "Terraform plan $PLAN_NUMBER extracted to: $OUTPUT_FILE"
        fi
    fi
    exit $exit_code
else
    # Output to stdout
    extract_plans "$LOG_FILE" "$PLAN_NUMBER"
    exit $?
fi