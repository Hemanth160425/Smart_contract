// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract SimpleIOU {
     address public owner;
     mapping(address => bool) public registeredFriends;
     address[] public friends;
     mapping(address=>uint256) public balances;
     mapping(address=>mapping(address=>uint256)) public debts;

     constructor() {
         owner = msg.sender;
         registeredFriends[msg.sender] = true;
         friends.push(msg.sender);
     }

     modifier onlyOwner() {
         require(msg.sender == owner, "Only owner can call this function");
         _;
     }

     modifier onlyFriend() {
         require(registeredFriends[msg.sender], "Only friend can call this function");
         _;
     }

     function addFriend (address _friend) onlyOwner{
        require(_friend!=address(0), "Invalid friend address");
        require(!registeredFriends[_friend], "Friend already registered");
        registeredFriends[_friend] = true;
        friends.push(_friend);
     }

     function removeFriend(address _friend) public onlyOwner {
         require(_friend != address(0), "Invalid friend address");
         require(registeredFriends[_friend], "Friend not registered");
         registeredFriends[_friend] = false;
         for (uint256 i = 0; i < friends.length; i++) {
             if (friends[i] == _friend) {
                 friends[i] = friends[friends.length - 1];
                 friends.pop();
                 break;
             }
         }
     }

     function deposit() public payable registeredFriends {
         require(msg.value > 0, "Deposit amount must be greater than zero");
         balances[msg.sender] += msg.value;
     }

     function recordDebt(address _debtor, address _creditor, uint256 _amount) public registeredFriends {
         require(_debtor != address(0), "Invalid debtor address");
         require(_creditor != address(0), "Invalid creditor address");
         require(_amount > 0, "Debt amount must be greater than zero");
         debts[_debtor][_creditor] += _amount;
     }

     function payfromwallet(address _debtor, address _creditor, uint256 _amount) public registeredFriends {
         require(_debtor != address(0), "Invalid debtor address");
         require(_creditor != address(0), "Invalid creditor address");
         require(_amount > 0, "Debt amount must be greater than zero");
         require(debts[_debtor][_creditor] >= _amount, "Insufficient debt");
         require(balances[_debtor] >= _amount, "Insufficient balance");
         debts[_debtor][_creditor] -= _amount;
         balances[_debtor] -= _amount;
         balances[_creditor] += _amount;
     }

     function transferEther(address _to, uint256 _amount) public registeredFriends {
         require(_to != address(0), "Invalid recipient address");
         require(registeredFriends[_to], "Recipient not registered");
         require(_amount > 0, "Transfer amount must be greater than zero");
         require(balances[msg.sender] >= _amount, "Insufficient balance");
         balances[msg.sender] -= _amount;
         (bool success, ) = payable(_to).call{value: _amount}("");
         require(success, "Transfer failed");
     }

     function getAllFriends() public view returns (address[] memory) {
         return friends;
     }

     function getBalance() public view returns (uint256) {
         return balances[msg.sender];
     }

     function getDebt(address _debtor, address _creditor) public view returns (uint256) {
         return debts[_debtor][_creditor];
     }

     function withdraw() public registeredFriends {
         require(balances[msg.sender] > 0, "No balance to withdraw");
         uint256 amount = balances[msg.sender];
         balances[msg.sender] = 0;
         (bool success, ) = payable(msg.sender).call{value: amount}("");
         require(success, "Transfer failed");
     }

     
}