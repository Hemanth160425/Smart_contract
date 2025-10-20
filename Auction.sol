// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/security/ReentrancyGuard.sol";

/**
 * @title SecureAuctionHouse
 * @dev Implements a secure auction house with withdrawal pattern and access control
 */
contract AuctionHouse is ReentrancyGuard {
    address public owner;
    string public item;
    uint256 public auctionEndTime;
    uint256 private highestBid;
    address private highestBidder;
    bool public ended;

    mapping(address => uint256) public pendingReturns;
    mapping(address => uint256) public bids;
    address[] public bidders;

    // Events
    event AuctionCreated(string item, uint256 endTime);
    event BidPlaced(address indexed bidder, uint256 amount);
    event AuctionEnded(address indexed winner, uint256 amount);
    event Withdrawal(address indexed recipient, uint256 amount);

    // Modifiers
    modifier onlyOwner() {
        require(msg.sender == owner, "Caller is not the owner");
        _;
    }

    modifier onlyBeforeEnd() {
        require(block.timestamp < auctionEndTime, "Auction already ended");
        _;
    }

    modifier onlyAfterEnd() {
        require(block.timestamp >= auctionEndTime, "Auction not yet ended");
        _;
    }

    constructor(string memory _item, uint256 _biddingTime) {
        require(_biddingTime > 0, "Bidding time must be greater than zero");
        require(bytes(_item).length > 0, "Item description cannot be empty");
        
        owner = msg.sender;
        item = _item;
        auctionEndTime = block.timestamp + _biddingTime;
        
        emit AuctionCreated(_item, auctionEndTime);
    }

    function bid() external payable onlyBeforeEnd nonReentrant {
        require(msg.value > 0, "Bid amount must be greater than zero");
        require(msg.value > highestBid, "Bid is not high enough");
        
        // Refund the previous highest bidder
        if (highestBidder != address(0)) {
            pendingReturns[highestBidder] += highestBid;
        }

        // Track new bidder if it's their first bid
        if (bids[msg.sender] == 0) {
            bidders.push(msg.sender);
        }
        
        // Update bid tracking
        bids[msg.sender] += msg.value;
        highestBid = msg.value;
        highestBidder = msg.sender;
        
        emit BidPlaced(msg.sender, msg.value);
    }

    function withdraw() external nonReentrant {
        uint256 amount = pendingReturns[msg.sender];
        require(amount > 0, "No funds to withdraw");
        
        // Prevent reentrancy by updating state before external call
        pendingReturns[msg.sender] = 0;
        
        (bool success, ) = payable(msg.sender).call{value: amount}("");
        require(success, "Transfer failed");
        
        emit Withdrawal(msg.sender, amount);
    }

    function endAuction() external onlyOwner onlyAfterEnd {
        require(!ended, "Auction has already ended");
        
        ended = true;
        
        // Transfer the highest bid to the owner
        if (highestBid > 0) {
            (bool success, ) = payable(owner).call{value: highestBid}("");
            require(success, "Failed to transfer winnings to owner");
        }
        
        emit AuctionEnded(highestBidder, highestBid);
    }

    function getWinner() external view returns (address) {
        require(ended, "Auction not yet ended");
        return highestBidder;
    }
    
    function getHighestBid() external view returns (uint256) {
        return highestBid;
    }
    
    function getAllBidders() external view returns (address[] memory) {
        return bidders;
    }
    
    function timeRemaining() external view returns (uint256) {
        if (block.timestamp >= auctionEndTime) {
            return 0;
        }
        return auctionEndTime - block.timestamp;
    }
    
    // Fallback function to prevent accidental ETH transfers
    receive() external payable {
        revert("Direct transfers not allowed. Use the bid() function.");
    }
}