# Zimbra LDAP Mail Signature

This repository contains two Bash scripts designed for managing Zimbra email accounts by updating user information and creating email signatures.

## Scripts Overview

### 1. `getinfo.sh`

This script retrieves and updates user information for Zimbra email accounts by querying an LDAP server. It performs the following tasks:

- Extracts information such as company, mobile number, home phone, and address.
- Checks for base64 encoded values and decodes them if necessary.
- Updates the Zimbra account attributes with the retrieved information.

**Usage:**

To use this script, make sure to configure the LDAP connection details within the script. You can run it as follows:

```bash
bash getinfo.sh
```

### LDAP Parameters:

- In the script, you will need to configure the following LDAP parameters:

  - LDAP Base DN: The base distinguished name (DN) for your LDAP directory. For example, dc=domain,dc=local.
  - Bind DN: The distinguished name used to authenticate against the LDAP server. Typically in the format user@domain.local.
  - Bind Password: The password for the bind DN user.
  - LDAP Server: The address of the LDAP server (e.g., ldap://192.168.1.10).
  - Ensure you replace these values with your actual LDAP server details to allow the script to connect properly.


## Scripts Overview

### 2. `createSignature.sh`

This script retrieves various details for Zimbra email accounts and creates an HTML email signature for each account. It performs the following tasks:

- Fetches display names, telephone numbers, fax numbers, and addresses.
- Checks if any of the phone numbers are marked as invalid.
- Generates an HTML signature and sets it as the default for the specified email account.

**Usage:**

To use this script, ensure that you have a file named `mails.txt` containing the email addresses you wish to process, then run:

```bash
bash createSignature.sh
```


![image](https://github.com/user-attachments/assets/0e366e55-f2be-4bd0-b5fc-480181cdcc7d)
