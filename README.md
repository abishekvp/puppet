
# Securden Puppet Integration

## Introduction

Securden provides a seamless and efficient way for developers to integrate powerful password management into their infrastructure automation. This guide explains how to install and integrate Securden with Puppet for secure, programmatic access to credentials, tokens, and keys.

---

## 🧰 Installation

To install the Puppet module for Securden, run the following command:

```bash
puppet module install securden-securden
```

---

## ✅ Prerequisites

The following parameters are required for integration:

- **Securden Server URL / Host**
- **Authentication Token**
- **SSL Certificate Path (Optional)**

---

## 🔐 Getting the Server URL

In the Securden web interface, navigate to:  
`Admin >> General >> Securden Server Connectivity`

---

## 🔑 Generate API Token

To authenticate:

1. Go to: `Admin >> API Access >> Create and Manage API Tokens`
2. Define:
   - Reference name and description
   - Allowed IP addresses or range
   - Token type (static/dynamic)
   - Scope (capabilities)
3. Click **Create Token** and copy the token.

---

## 🏁 Initialize Securden

You can declare configuration parameters using Puppet’s DSL.

SSL certificates are optional:
- If provided and valid → used strictly.
- If not provided → plugin auto-fetches.
- If fetch fails → SSL verification is disabled but HTTPS is still used.

---

## 📥 Fetching Account Data

### Fetching Single Account by Attributes

```puppet
$account = securden::get_account({
  account_title => "Example Title",
  account_name  => "example_user",
  ticket_id     => "TICKET-1234",  # Optional
  reason        => "Routine fetch" # Optional
})

notice("Password: ${account['password']}")
```

### Fetching Single Account by ID

```puppet
$account = securden::get_account({
  account_id => 2000000003178
})

notice("Password: ${account['password']}")
```

---

## 📦 Fetching Multiple Accounts

```puppet
$accounts = securden::get_accounts({
  account_ids => [2000000003178, 2000000003179]
})

$account_pass = $accounts['2000000003178']['password']
```

## 📎 Notes

- Use `securden::get_account` for single account.
- Use `securden::get_accounts` for fetching multiple accounts.

---

## ➕ Adding a New Account

```puppet
securden::add_account({
  account_title => "My Server",
  account_name  => "admin",
  account_type  => "Linux",
  ipaddress     => "192.168.1.100",
  notes         => "Test account",
  password      => "StrongPass123!"
})
```

Required fields: `account_title`, `account_name`, `account_type`  
Other optional fields:
- `ipaddress`, `notes`, `tags`, `personal_account`, `folder_id`
- `account_expiration_date`, `distinguished_name`, `account_alias`, `domain_name`

---

## 🛠️ Updating an Account

```puppet
securden::edit_account({
  account_id    => 2000000003178,
  account_name  => "updated_user",
  ipaddress     => "192.168.2.101",
  tags          => "updated"
})
```

---

## ❌ Deleting Accounts

```puppet
securden::delete_accounts({
  account_ids => [2000000003178, 2000000003179],
  reason      => "Cleanup unused accounts"
})
```

To delete permanently:

```puppet
securden::delete_accounts({
  account_ids         => [2000000003178],
  delete_permanently  => true
})
```

## 📎 Notes

- Deleted accounts go to **Recently Deleted**. Use `delete_permanently` to fully erase.

---

## 📋 Complete List of Account Attributes

| Attribute             | Description                                          |
|-----------------------|------------------------------------------------------|
| `account_id`          | Unique identifier for the account                   |
| `account_name`        | Name of the account                                 |
| `account_title`       | Description or job title                            |
| `password`            | Account password                                    |
| `private_key`         | SSH private key                                     |
| `putty_private_key`   | PuTTY-compatible key                                |
| `passphrase`          | Passphrase for private key                          |
| `ppk_passphrase`      | Passphrase for PuTTY key                            |
| `address`             | Network IP/domain                                   |
| `client_id`           | Application/API client ID                           |
| `client_secret`       | Secret for client authentication                    |
| `account_alias`       | Alias for AWS IAM accounts                          |
| `account_file`        | Associated file                                     |
| `default_database`    | Default DB                                          |
| `oracle_sid`          | Oracle SID                                          |
| `oracle_service_name` | Oracle service name                                 |
| `port`                | Port number                                         |
| _Additional Fields_   | Custom fields based on configuration                |

---
## 📋 Notes
If you have general questions or issues in using the Securden Provider,  
you may raise a support request to [devops-support@securden.com](mailto:devops-support@securden.com).  
Our support team will get back to you at the earliest and provide a timeline  
if there are issue fixes involved.
