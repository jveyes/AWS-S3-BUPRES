#!/bin/bash

################################################################################
# Bash Script Information
# -----------------------
# Description: This Bash script provides an interactive menu with three
#              commands and an option to exit. The commands demonstrate
#              different functionalities, such as displaying local user
#              information, reading a name, and showing disk information.
# Date:        January 15, 2024
# Creator:     JESUS VILLALOBOS (inspired by assistance from OpenAI's GPT-3)
# Version:     1.0
# License:     MIT License
################################################################################

# Array to store the menu options
menu_options=(
    "Execute Command 1 (shows local user)"
    "Execute Command 2 (reads name)"
    "Execute Command 3 (shows disk info)"
    "Exit"
)

# Function to display the menu
display_menu() {
  clear
  # The max number og characters is 49 for the top line; please modify as you need just by adding this char ─
  echo "╭───────────────────────────────────────────────╮"
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
  echo "╰───────────────────────────────────────────────╯"
}

# Function to display the menu without frames (please remove the first # in each line, this in order to use it)
#display_menu() {
#    # Clears the terminal screen
#    clear
#    # Displays a formatted menu with numbered options
#    echo "1. Execute Command 1 (shows local user)"
#    echo "2. Execute Command 2 (reads name)"
#    echo "3. Execute Command 3 (shows disk info)"
#    echo "4. Exit"
#}

# Function to execute command 1
execute_command1() {
    # Displays a message indicating the execution of Command 1
    echo "Executing Command 1..."
    echo -n "Your local username is: " 
    whoami
    # Add your command(s) here
}

# Function to execute command 2
execute_command2() {
    # Prompts the user to enter a value for Command 2
    echo "Executing Command 2..."
    read -p "Enter a your name: " name
    # Displays a message indicating the execution of Command 2 with the provided parameter
    echo -e "Executing Command 2 with parameter (name): [\e[31m\e[1m$name\e[31m\e[0m]"
    # Add your command(s) here using $param
}

# Function to execute command 3
execute_command3() {
    # Displays a message indicating the execution of Command 3
    echo "Executing Command 3"
    df -h | column -t
    # Add your command(s) here
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
    read -p "Enter your choice (1-4): " choice

    # Uses a case statement to execute the corresponding function based on the user's choice
    case $choice in
        1)
            # Calls functions to start, execute, and end the task for option 1
            task_started
            execute_command1
            task_ended
            ;;
        2)
            # Calls functions to start, execute, and end the task for option 2
            task_started
            execute_command2
            task_ended
            ;;
        3)
            # Calls functions to start, execute, and end the task for option 3
            task_started
            execute_command3
            task_ended
            ;;
        4)
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
