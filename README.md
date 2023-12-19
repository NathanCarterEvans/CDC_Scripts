# User and Permissions Scripts

### `user_checker.sh`

- **Description**: This script generates a list of all users and their group memberships, and compares it to a predefined list of known users and groups.
- **Usage**:
  - **Create Valid Users File**: 
    ```bash
    sudo ./user_checker.sh -m
    ```
  - **Auto-Remove Users from Invalid Groups**:
    ```bash
    sudo ./user_checker.sh -g
    ```
    Note: This may need to be run several times.
  - **Auto-Add User to Valid File**:
    ```bash
    sudo ./user_checker.sh -a username
    ```
- **Note**: Must be run with `sudo`.

### `Users_and_groups.sh`

- **Description**: This script creates a `.csv` file listing every user and their respective group memberships.
- **Usage**:
  ```bash
  sudo ./Users_and_groups.sh
  ```
- **Note**: Must be run with `sudo`.

### `compare_users_groups.py`

- **Description**: Analyzes the `.csv` file created by `Users_and_groups.sh`. It cross-references this data with a known list of valid users and groups, identifying any discrepancies.
- **Usage**: 
  ```bash
  python3 compare_users_groups.py
  ```
- **Note**: Run this script with Python 3 to ensure proper functionality
