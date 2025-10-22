// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract EtherPiggyBank {
    
    address BankManager;
    address[] public members;
    uint256 public balance;
    mapping(address=>bool) public registeredMembers;
    mapping(address=> uint256) public memberBalances;

    constructor() {
        BankManager = msg.sender;
        members.push(BankManager);
    }

    modifier onlyManager() {
        require(msg.sender == BankManager, "Only manager can call this function");
        _;
    }

    modifier onlyMember() {
        require(registeredMembers[msg.sender], "Only member can call this function");
        _;
    }

    function addMember(address _member) public onlyManager {
        require(_member != address(0), "Invalid member address");
        require(!registeredMembers[_member], "Member already registered");
        registeredMembers[_member] = true;
        members.push(_member);
    }

    function getAllMembers() public view returns (address[] memory) {
        return members;
    }

    function deposit() public payable onlyMember {
        require(msg.value > 0, "Deposit amount must be greater than zero");
        balance += msg.value;
        memberBalances[msg.sender] += msg.value;
    }

    function getBalance() public view returns (uint256) {
        return memberBalances[msg.sender];
    }

    function withdraw() public onlyMember {
        require(memberBalances[msg.sender] > 0, "No balance to withdraw");
        uint256 amount = memberBalances[msg.sender];
        memberBalances[msg.sender] = 0;
        (bool success, ) = payable(msg.sender).call{value: amount}("");
        require(success, "Transfer failed");
    }
}