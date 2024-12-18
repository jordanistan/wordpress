# How to Run Ansible Scripts

This guide explains how to run the Ansible scripts provided for:
1. Security updates (`wordpress_security_updates.yml`)
2. WordPress backups (`wordpress_backup.yml`)
3. Database migration (`db_migration.yml`)

## Prerequisites

1. **Install Ansible**:
   - Ensure Ansible is installed on your local machine.
   - For most systems, use:
     ```bash
     sudo apt install ansible  # Debian/Ubuntu
     sudo yum install ansible  # CentOS/RedHat
     brew install ansible      # macOS
     ```

2. **Ensure SSH Access**:
   - Confirm that Ansible can connect to your remote servers using SSH.
   - Add the SSH key for accessing your WordPress server:
     ```bash
     ssh-add /path/to/private/key
     ```

3. **Inventory File**:
   - Define your inventory in a file (e.g., `inventory.ini`):
     ```ini
     [wordpress]
     your-wordpress-server-ip ansible_user=ubuntu ansible_ssh_private_key_file=/path/to/private/key
     ```

## Running the Scripts

### 1. **Run Security Updates Script**
   - This script applies system updates, ensures automatic security updates are enabled, and secures file permissions.
   - Run the script with:
     ```bash
     ansible-playbook -i inventory.ini wordpress_security_updates.yml
     ```

### 2. **Run WordPress Backup Script**
   - This script creates backups of your WordPress database and files. Optionally, it can upload backups to S3.
   - Run the script with:
     ```bash
     ansible-playbook -i inventory.ini wordpress_backup.yml
     ```
   - If using S3 for remote storage, ensure the required variables (e.g., `s3_bucket_name`) are set in the script or as extra variables:
     ```bash
     ansible-playbook -i inventory.ini wordpress_backup.yml -e "backup_to_s3=true s3_bucket_name=my-bucket"
     ```

### 3. **Run Database Migration Script**
   - This script migrates a database from a provider like DigitalOcean to AWS.
   - Run the script with:
     ```bash
     ansible-playbook db_migration.yml
     ```
   - The script will prompt you for source and destination database details interactively.

## Common Options

- **Dry Run**:
   - Test the scripts without making changes by adding the `--check` flag:
     ```bash
     ansible-playbook -i inventory.ini wordpress_security_updates.yml --check
     ```

- **Verbose Output**:
   - View detailed output by adding the `-v` flag:
     ```bash
     ansible-playbook -i inventory.ini wordpress_backup.yml -v
     ```

## Debugging

- If there are connection issues, test connectivity with:
  ```bash
  ansible -i inventory.ini all -m ping
  ```
- For specific tasks, enable debug messages by adding the `--diff` flag:
  ```bash
  ansible-playbook -i inventory.ini wordpress_backup.yml --diff
  ```

## Automation

- Use a cron job or CI/CD pipeline to schedule the Ansible scripts:
  ```bash
  crontab -e
  ```
  Example cron entry to run backups daily at 1 AM:
  ```
  0 1 * * * ansible-playbook -i /path/to/inventory.ini /path/to/wordpress_backup.yml
  ```

Feel free to modify or enhance the scripts based on your specific requirements.
