#!/bin/bash

################################################################################
# Bash Script Information
# -----------------------
# Description: This Bash script provides a user-friendly menu interface to 
#              interact with an AWS S3 bucket. It allows users to perform 
#              various operations, including listing files in the bucket,
#              backing up local files to the bucket, restoring files from 
#              the bucket to a local directory, and deleting files from the 
#              bucket. The script uses the AWS CLI to communicate with the 
#              S3 service and provides visual feedback to the user through 
#              colorized output. It offers a convenient way to manage 
#              backups and file transfers between a local system and an AWS 
#              S3 bucket, simplifying common tasks for AWS users.
# Date:        January 15, 2024
# Creator:     JESUS VILLALOBOS
# Version:     1.0
# License:     MIT License
################################################################################

# Define variables
AWS_PROFILE="aws_profile"               # The profile used inside the .aws/credentials file
S3_BUCKET="s3_bucket"                   # Just the bucket name
REMOTE_DIR="remote_dir/"                # It includes the /
LOCAL_BACK="local_backup_folder/"       # It includes the /
LOCAL_REST="local_restore_folder"       # It does not includes a /

# Array to store the menu options
menu_options=(
    "List AWS files from bucket (backupmtto)"
    "Backup local files to AWS bucket (backup --> backupmtto)"
    "Restore AWS files to local folder (backupmtto --> restore)"
    "Delete AWS files from bucket (backupmtto)"
    "Exit"
)

# Function to display the menu
display_menu() {
  clear
  # The max number og characters is 49 for the top line; please modify as you need just by adding this char ─
  echo "╭─────────────────────────────────────────────────────────────────────╮"
  max_length=0
  # Find the maximum length of menu options
  for option in "${menu_options[@]}"; do
    length=${#option}
    if (( length > max_length )); then
      max_length=$length
    fi
  done

  # Calculate the width of the menu option
  menu_width=$((max_length + 6)) # Add space for option number and padding

  for i in "${!menu_options[@]}"; do
    option="${menu_options[$i]}"
    # Construct the menu option with proper padding
    printf "│ %-3s%-$(($menu_width))s │\n" "$((i+1))." "$option"
  done
  # The max number og characters is 49 for the bottom line; please modify as you need just by adding this char ─
  echo "╰─────────────────────────────────────────────────────────────────────╯"
}

# Function to execute command 1
execute_command1() {
    list_files() {
        echo "Listing files in AWS S3 bucket..."
        s3_listing=$(aws s3 ls s3://$S3_BUCKET/$REMOTE_DIR --recursive --human-readable --summarize --profile $AWS_PROFILE)

        # Check if the output contains the "Total Objects" line indicating no files
        if echo "$s3_listing" | grep -q "Total Objects: 0"; then
            echo
            echo "No files found in the S3 bucket."
            echo -e "\e[31mNothing to list.\e[0m"
        else
            # Display files if the output does not indicate no files
            echo
            echo "$s3_listing"
        fi
    }
}

# Function to execute command 2
execute_command2() {
    backup_files() {
        local_backup_dir=$(pwd)/$LOCAL_BACK
        echo
        echo "Backing up files to AWS S3 bucket..."
        
        # Check if the local backup directory contains files
        if [ "$(find "$local_backup_dir" -type f)" ]; then
            aws s3 sync "$local_backup_dir" s3://$S3_BUCKET/$REMOTE_DIR --profile $AWS_PROFILE
            if [ $? -eq 0 ]; then
                echo
                echo -e "\e[32mBackup completed successfully.\e[0m"
            else
                echo
                echo -e "\e[31mBackup failed.\e[0m"
                echo "Please check your configuration and try again."
                exit 1
            fi
        else
            echo
            echo "No files found in the local $(pwd)/$LOCAL_BACK folder."
            echo -e "\e[31mNothing to backup.\e[0m"
        fi
    }
}

# Function to execute command 3
execute_command3() {
    restore_files() {
        # Restore files from AWS S3 bucket to local computer
        echo "Listing files in AWS S3 bucket..."
        s3_listing=$(aws s3 ls "s3://$S3_BUCKET/$REMOTE_DIR" --recursive --profile "$AWS_PROFILE")
        if [ -z "$s3_listing" ]; then
            echo
            echo "No files found in the S3 bucket."
            echo -e "\e[31mNothing to restore.\e[0m"
            return
        fi

        # Display numbered list of files and directories
        echo
        echo -e "\e[32mAvailable files and directories:\e[0m"
        echo
        awk '{print NR ". " $NF}' <<< "$s3_listing"

        # Prompt user to choose item by number
        echo
        read -p "Enter the number of the file or directory you want to restore: " item_number
        echo

        # Validate the input against the range of valid numbers
        num_files=$(awk 'END {print NR}' <<< "$s3_listing")
        if ! [[ "$item_number" =~ ^[1-"$num_files"]$ ]]; then
            echo -e "\e[31mInvalid input. Please enter a number between 1 and $num_files.\e[0m"
            return  # Exit the function
        fi

        # Retrieve selected item from the list
        restore_item=$(awk -v item_number="$item_number" 'NR == item_number {print $NF}' <<< "$s3_listing")

        # Construct the destination directory path
        restore_destination=$(dirname "$restore_item")
        
        # Create the restore destination directory and its parent directories
        mkdir -p "$(dirname "$(pwd)/$LOCAL_REST/$restore_destination")"

        echo -e "Restoring \e[32m$restore_item\e[0m from AWS S3 bucket..."
        aws s3 cp "s3://$S3_BUCKET/$restore_item" "$(pwd)/$LOCAL_REST/$restore_item" --profile "$AWS_PROFILE"
        if [ $? -eq 0 ]; then
            echo "Restore completed successfully."
        else
            echo -e "\e[31mRestore failed.\e[0m Please check your configuration and try again."
            exit 1
        fi
    }
}

# Function to execute command 4
execute_command4() {
    delete_files() {
        # Delete files or folders from AWS S3 bucket
        echo "Listing files in AWS S3 bucket..."
        s3_listing=$(aws s3 ls s3://$S3_BUCKET/$REMOTE_DIR --recursive --profile $AWS_PROFILE 2>&1)
        s3_listing_exit_code=$?
        if [ $s3_listing_exit_code -ne 0 ]; then
            echo
            echo "No files found in the S3 bucket."
            echo -e "\e[31mNothing to delete.\e[0m"
            return
        fi

        # Check if the bucket is empty
        if [ -z "$s3_listing" ]; then
            echo "The S3 bucket is empty. Nothing to delete."
            return
        fi

        # Display numbered list of files and directories
        echo
        echo "Available files and directories:"
        awk '{print NR ". " $NF}' <<< "$s3_listing"

        # Prompt user to choose item by number
        echo
        read -p "Enter the number of the file or directory you want to delete: " item_number
        echo

        # Validate the input against the range of valid numbers
        num_files=$(awk 'END {print NR}' <<< "$s3_listing")
        if ! [[ "$item_number" =~ ^[1-"$num_files"]$ ]]; then
            echo -e "\e[31mInvalid input. Please enter a number between 1 and $num_files.\e[0m"
            return  # Exit the function
        fi

        # Retrieve selected item from the list
        delete_item=$(awk -v item_number="$item_number" 'NR == item_number {print $NF}' <<< "$s3_listing")

        echo -e "Deleting \e[31ms3://$S3_BUCKET/$delete_item\e[0m from AWS S3 bucket..."
        aws s3 rm s3://$S3_BUCKET/$delete_item --profile $AWS_PROFILE
        if [ $? -eq 0 ]; then
            echo -e "\e[32mDeletion completed successfully.\e[0m"
        else
            echo "Deletion failed. Please check your configuration and try again."
            exit 1
        fi
    }
}

# Function to start task
task_started() {
    # Displays a message indicating the start of the task
    echo ""
    echo -e "╭─────────────────────────────────────────────╮"
    echo -e "│ \e[93mTHE TASK HAS STARTED RUNNING\e[0m                │"
    echo -e "╰─────────────────────────────────────────────╯"
}

# Function to end task
task_ended() {
    # Displays a message indicating the end of the task
    echo ""
    echo -e "╭─────────────────────────────────────────────╮"
    echo -e "│ \e[32mTHE TASK HAS FINISHED RUNNING\e[0m               │"
    echo -e "╰─────────────────────────────────────────────╯"
}

# Main loop for the menu
while true; do
    # Calls the function to display the menu
    display_menu

    # Prompts the user to enter a choice (1-4)
    read -p "Enter your choice (1-5): " choice

    # Uses a case statement to execute the corresponding function based on the user's choice
    case $choice in
        1)
            # Calls functions to start, execute, and end the task for option 1
            task_started
            execute_command1
            list_files
            task_ended
            ;;
        2)
            # Calls functions to start, execute, and end the task for option 2
            task_started
            execute_command2
            backup_files
            task_ended
            ;;
        3)
            # Calls functions to start, execute, and end the task for option 3
            task_started
            execute_command3
            restore_files
            task_ended
            ;;
        4)
            # Calls functions to start, execute, and end the task for option 4
            task_started
            execute_command4
            delete_files
            task_ended
            ;;
        5)
            echo ""
            echo -e "\e[32mExiting the menu. Goodbye!\e[0m"
            echo ""
            exit 0
            ;;
        *)
            # Displays an error message for invalid choices
            echo ""
            echo -e "\e[31mInvalid choice [\e[1m$choice\e[0m\e[31m]\e[0m"
            echo -e "\e[31mPlease enter a number between 1 and 4.\e[0m"
            echo ""
            ;;
    esac

    # Displays a message and waits for the user to press Enter to continue
    echo -e -n "\e[1mPress Enter to continue...\e[0m"
    read -s -n 1 -p ""
done