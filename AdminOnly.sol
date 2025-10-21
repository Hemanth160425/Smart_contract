// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract AdminOnly {
    address public owner;
    uint256 public treaserAmount;
    mapping(address => uint256) public withdrawalAllowance;
    mapping(address=>bool) haswithdrawn;

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Caller is not the owner");
        _;
    }
    
    function addTreaser(uint256 _amount) external onlyOwner {
        treaserAmount += _amount;
    }

    function setWithdrawalAllowance(address _recipient, uint256 _amount) external onlyOwner {
        require(_amount > 0, "Amount must be greater than zero");
        require(_recipient != address(0), "Invalid recipient");
        withdrawalAllowance[_recipient] = _amount;
    }   

    function getWithdrawalAllowance(address _recipient) external view returns (uint256) {
        return withdrawalAllowance[_recipient];
    }

    function withdraw(uint256 amount) external  {
        if(msg.sender==owner){
            require(!haswithdrawn[msg.sender], "Already withdrawn");
            require(withdrawalAllowance[msg.sender] >= amount, "No funds to withdraw");
            require(treaserAmount >= amount, "Insufficient funds");
            payable(msg.sender).transfer(amount);
            haswithdrawn[msg.sender] = true;
        }
        else{
            require(withdrawalAllowance[msg.sender] >= amount, "No funds to withdraw");
            require(treaserAmount >= amount, "Insufficient funds");
            payable(msg.sender).transfer(amount);
            haswithdrawn[msg.sender] = true;
        }
    }   

    function getTreaserAmount() external view returns (uint256) {
        return treaserAmount;
    }

    function getHaswithdrawn(address _recipient) external view returns (bool) {
        return haswithdrawn[_recipient];
    }

    function transferowner(address _newOwner) external onlyOwner {
        require(_newOwner != address(0), "Invalid new owner");
        owner = _newOwner;
    }

    function resetwithdrawn(address _recipient) external onlyOwner {
        haswithdrawn[_recipient] = false;
    }
}