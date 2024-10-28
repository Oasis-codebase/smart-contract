"# smart-contract" 
/ SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
interface ERC4337 {
   function validateUserOperation(UserOperation calldata userOperation) external returns (bytes32);
   function executeUserOperation(UserOperation calldata userOperation, bytes32 validationData) external payable;
}
interface ApillonWallet {
   function linkWallet(address userAddress, address walletAddress) external;
   function unlinkWallet(address userAddress) external;
}
struct UserOperation {
   address sender;
   uint256 nonce;
   uint256 callData;
}
struct UserData {
   string email;
   address walletAddress;
   bool emailVerified;
   uint browserUsageTime;
}
contract Web3BrowserContract is ERC4337 {
   ApillonWallet public apillonWallet;
   address private admin;
   mapping(address => UserData) public users;
   mapping(address => uint256) public nonces;
   event UserRegistered(address indexed userAddress, string email);
   event WalletLinked(address indexed userAddress, address walletAddress);
   event EmailVerified(address indexed userAddress, string email);
   event BrowserUsageTracked(address indexed userAddress, uint usageTime);
   constructor(address _apillonWalletAddress) {
       admin = msg.sender;
       apillonWallet = ApillonWallet(_apillonWalletAddress);
   }
   modifier onlyAdmin() {
       require(msg.sender == admin, "Only admin can call this function");
       _;
   }
   modifier onlyRegisteredUsers() {
       require(bytes(users[msg.sender].email).length != 0, "User not registered");
       _;
   }
   function setApillonWalletAddress(address _apillonWalletAddress) public onlyAdmin {
       apillonWallet = ApillonWallet(_apillonWalletAddress);
   }
   function validateUserOperation(UserOperation calldata userOperation) external override returns (bytes32) {
       require(bytes(users[userOperation.sender].email).length != 0, "User not registered");
       require(nonces[userOperation.sender] == userOperation.nonce, "Invalid nonce");
       nonces[userOperation.sender]++;
       return bytes32(keccak256("VALID"));
   }
   function executeUserOperation(UserOperation calldata userOperation, bytes32 validationData) external override payable {
       require(validationData == bytes32(keccak256("VALID")), "Invalid validation data");
       if (userOperation.callData == 1) {
           linkApillonWallet(userOperation.sender, userOperation.sender);
       } else if (userOperation.callData == 2) {
           unlinkApillonWallet(userOperation.sender);
       }
   }
   function registerUser(string memory _email) public {
       require(bytes(users[msg.sender].email).length == 0, "User already registered");
       users[msg.sender] = UserData(_email, address(0), false, 0);
       emit UserRegistered(msg.sender, _email);
   }
   function linkApillonWallet(address userAddress, address walletAddress) internal {
       apillonWallet.linkWallet(userAddress, walletAddress);
       users[userAddress].walletAddress = walletAddress;
       emit WalletLinked(userAddress, walletAddress);
   }
   function unlinkApillonWallet(address userAddress) internal {
       apillonWallet.unlinkWallet(userAddress);
       delete users[userAddress].walletAddress;
       emit WalletLinked(userAddress, address(0));
   }
   function verifyEmail(string memory _email) public onlyRegisteredUsers {
       require(keccak256(bytes(users[msg.sender].email)) == keccak256(bytes(_email)), "Email mismatch");
       users[msg.sender].emailVerified = true;
       emit EmailVerified(msg.sender, _email);
   }
   function trackBrowserUsage(uint _usageTime) public onlyRegisteredUsers {
       users[msg.sender].browserUsageTime += _usageTime;
       emit BrowserUsageTracked(msg.sender, _usageTime);
   }
