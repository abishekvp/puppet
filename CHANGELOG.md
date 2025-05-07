| **Version** | **Features**                                                                                                                                               | **Bug Fixes** |
| ----------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------- |
| **0.0.1**   | - Installable via Puppet Forge (`puppet module install securden-securden`)                                                                                 |               |
|             | - Provides methods for fetching, adding, updating, and deleting accounts (`get_account`, `get_accounts`, `add_account`, `edit_account`, `delete_accounts`) |               |
|             | - Supports SSL certificate handling (optional auto-fetching or skipping verification)                                                                      |               |
|             | - Supports multiple account management with attributes like password, private key, IP address, and more                                                    |               |
|             | - Detailed account attributes, including support for SSH keys, passphrases, and database settings                                                          |               |
|             | - Includes methods for safely managing account credentials in Puppet code                                                                                  |               |
| **1.0.0**   |              | - Added support for passing `ticket_id` and `reason` parameters when fetching accounts, if the account is enforced with a ticketing system and reason enforcement in the product. |
