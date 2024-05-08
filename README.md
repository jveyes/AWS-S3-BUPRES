# AWS S3 Backup and Restore Script

This Bash script provides a menu-driven interface to perform various operations on an AWS S3 bucket, including listing files, backing up local files to the bucket, restoring files from the bucket to a local directory, and deleting files from the bucket.

## Prerequisites

Before running the script, ensure that you have the following:

- AWS CLI installed and configured with appropriate credentials
- An AWS S3 bucket set up (replace `serportgot` with your bucket name)

## Usage

1. Clone or download the repository containing the script.
2. Open a terminal and navigate to the directory where the script is located.
3. Make the script executable by running `chmod +x script_name.sh`.
4. Run the script with `./script_name.sh`.
5. Follow the menu prompts to perform the desired operations.

## Menu Options

1. **List AWS files from bucket (backupmtto)**: Lists the files and directories in the specified S3 bucket directory (`Mantenimiento/backupmtto/`).
2. **Backup local files to AWS bucket (backup --> backupmtto)**: Uploads the contents of the local `backup/` directory to the specified S3 bucket directory.
3. **Restore AWS files to local folder (backupmtto --> restore)**: Displays a numbered list of files and directories in the S3 bucket directory, prompts the user to select one, and downloads the selected item to the local `restore/` directory.
4. **Delete AWS files from bucket (backupmtto)**: Displays a numbered list of files and directories in the S3 bucket directory, prompts the user to select one, and deletes the selected item from the bucket.
5. **Exit**: Exits the script.

## Configuration

You can modify the following variables in the script to suit your needs:

- `AWS_PROFILE`: The AWS profile to use for authentication (default: `serport`).
- `S3_BUCKET`: The name of your AWS S3 bucket (default: `serportgot`).
- `REMOTE_DIR`: The directory path in the S3 bucket for backup/restore operations (default: `Mantenimiento/backupmtto/`).
- `LOCAL_BACK`: The local directory for backup files (default: `backup/`).
- `LOCAL_REST`: The local directory for restored files (default: `restore`).

## License

This script is licensed under the [MIT License](LICENSE).

## Contributing

Contributions are welcome! If you find any issues or have suggestions for improvements, please open an issue or submit a pull request.