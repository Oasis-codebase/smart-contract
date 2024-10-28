Web3 Browser Contract
This Solidity contract integrates Oasis Protocol and Apillon Wallet for secure user management within a Web3 browser.
Overview
1. User Registration: Registers users with Ethereum addresses and emails.
2. Apillon Wallet Linking: Links users' Apillon wallets using ERC-4337 account abstraction.
3. Email Verification: Verifies user email addresses.
4. Browser Usage Tracking: Tracks registered users' browser usage.

Key Features
1. Dynamic Apillon Wallet Address: Allows admin to update Apillon Wallet address.
2. Access Control: Role-based access using `onlyAdmin` and `onlyRegisteredUsers` modifiers.
3. Input Validation: Prevents potential attacks.
4. Event Emissions: Notifies users of key events.

Technical Details
1. Solidity Version: 0.8.0+
2. ERC-4337: Account abstraction for secure wallet linking.
3. Apillon Wallet Interface: Integrates Apillon wallet functionality.

Deployment
1. Compile with Solidity 0.8.0+.
2. Deploy, passing Apillon Wallet address.
3. Test functions thoroughly.

Security Considerations
1. Access Control: Restrict sensitive functions.
2. Input Validation: Prevent attacks.
3. Regular Audits: Ensure contract security.
