// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract TipJar {
    address public owner;
    mapping(address => uint256) public tipsperperson;
    uint256 public totaltips;
    mapping(string => uint256) public tippercurrency;
    mapping(string => uint256) public tipcurrencyrate;
    string [] public tipcurrencies;
    uint256 public tipcurrencieslength;

    constructor() {
        owner = msg.sender;
        tipcurrencieslength = 0;
        addCurrencyrates("USD", 2 *10**14);
        addCurrencyrates("EUR", 1*10**14);
        addCurrencyrates("GBP", 1*10**14);
        addCurrencyrates("AUD", 1*10**14);
        addCurrencyrates("CAD", 1*10**14);
        addCurrencyrates("CHF", 1*10**14);
        addCurrencyrates("JPY", 1*10**14);
        addCurrencyrates("KRW", 1*10**14);
        addCurrencyrates("INR", 1*10**14);
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call this function");
        _;
    }

    function addCurrencyrates(string memory _currency, uint256 _rate) public onlyOwner {
        require(_rate > 0, "Rate must be greater than zero");
        require(tipcurrencyrate[_currency] == 0, "Currency already exists");
        tipcurrencyrate[_currency] = _rate;
        tipcurrencies.push(_currency);
        tipcurrencieslength++;
    }

    function removeCurrencyrates(string memory _currency) public onlyOwner {
        require(tipcurrencyrate[_currency] > 0, "Currency not found");
        for (uint256 i = 0; i < tipcurrencieslength; i++) {
            if (keccak256(abi.encodePacked(tipcurrencies[i])) == keccak256(abi.encodePacked(_currency))) {
                tipcurrencies[i] = tipcurrencies[tipcurrencieslength - 1];
                tipcurrencies.pop();
                tipcurrencieslength--;
                break;
            }
        }
        delete tipcurrencyrate[_currency];
    }

    function getCurrencyrates(string memory _currency) public view returns (uint256) {
        return tipcurrencyrate[_currency];
    }

    function getAllCurrencies() public view returns (string[] memory) {
        return tipcurrencies;
    }

    function getTippercurrency(string memory _currency) public view returns (uint256) {
        return tippercurrency[_currency];
    }

    function getAllTippercurrency() public view returns (string[] memory) {
        return tippercurrency;
    }

    function depositinETH() public payable {
        require(msg.value > 0, "Deposit amount must be greater than zero");
        tipsperperson[msg.sender] += msg.value;
        totaltips += msg.value;
    }

    function depositinCurrency(string memory _currency, uint256 _amount) public payable {
        require(msg.value > 0, "Deposit amount must be greater than zero");
        uint256 amount = _amount * tipcurrencyrate[_currency];
        require(amount==msg.value, "Deposit amount must be equal to the amount in currency");
        tipsperperson[msg.sender] += amount;
        totaltips += amount;
    }

    function withdraw() public {
        require(tipsperperson[msg.sender] > 0, "No balance to withdraw");
        uint256 amount = tipsperperson[msg.sender];
        tipsperperson[msg.sender] = 0;
        (bool success, ) = payable(msg.sender).call{value: amount}("");
        require(success, "Transfer failed");
    }

    function withdrawinCurrency(string memory _currency) public {
        require(tipsperperson[msg.sender] > 0, "No balance to withdraw");
        uint256 amount = tipsperperson[msg.sender];
        tipsperperson[msg.sender] = 0;
        (bool success, ) = payable(msg.sender).call{value: amount}("");
        require(success, "Transfer failed");
    }

    function transferOwner(address _newOwner) public onlyOwner {
        owner = _newOwner;
    }     
    
}
