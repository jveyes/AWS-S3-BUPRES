# AWS S3 Backup and Restore Script

This Bash script provides a user-friendly menu interface to interact with an AWS S3 bucket. It allows users to perform various operations, including listing files in the bucket, backing up local files to the bucket, restoring files from the bucket to a local directory, and deleting files from the bucket. The script uses the AWS CLI to communicate with the S3 service and provides visual feedback to the user through colorized output. It offers a convenient way to manage backups and file transfers between a local system and an AWS S3 bucket, simplifying common tasks for AWS users.

## Prerequisites

Before running the script, ensure that you have the following:

- AWS CLI installed and configured with appropriate credentials
- An AWS S3 bucket set up (replace `s3_bucket` with your bucket name)

## Usage

1. Clone or download the repository containing the script.
2. Open a terminal and navigate to the directory where the script is located.
3. Make the script executable by running `chmod +x script.sh`.
4. Run the script with `./script.sh`.
5. Follow the menu prompts to perform the desired operations.

## Menu Options

1. **List AWS files from bucket**: Lists the files and directories in the specified S3 bucket directory (`remote_dir/`).
2. **Backup local files to AWS bucket**: Uploads the contents of the local `local_backup_folder/` directory to the specified S3 bucket directory.
3. **Restore AWS files to local folder**: Displays a numbered list of files and directories in the S3 bucket directory, prompts the user to select one, and downloads the selected item to the local `local_restore_folder` directory.
4. **Delete AWS files from bucket**: Displays a numbered list of files and directories in the S3 bucket directory, prompts the user to select one, and deletes the selected item from the bucket.
5. **Exit**: Exits the script.

## Configuration

You can modify the following variables in the script to suit your needs:

- `AWS_PROFILE`: The AWS profile to use for authentication (default: `aws_profile`).
- `S3_BUCKET`: The name of your AWS S3 bucket (default: `s3_bucket`).
- `REMOTE_DIR`: The directory path in the S3 bucket for backup/restore operations (default: `remote_dir/`).
- `LOCAL_BACK`: The local directory for backup files (default: `local_backup_folder/`).
- `LOCAL_REST`: The local directory for restored files (default: `local_restore_folder`).

## License

This script is licensed under the [MIT License](LICENSE).

## Contributing

Contributions are welcome! If you find any issues or have suggestions for improvements, please open an issue or submit a pull request.