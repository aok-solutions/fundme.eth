// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import { PriceConverter } from "./PriceConverter.sol";

error NotOwner();

contract FundMe {
    using PriceConverter for uint;

    uint public constant MINIMUM_USD = 5e18;
    address public immutable owner;
    address[] public funders;
    mapping(address funder => uint fundAmount) public addressToFundAmount;

    constructor() {
        owner = msg.sender;
    }

    function fund() public payable {
        require(msg.value.getConversionRate() >= MINIMUM_USD, "didn't send enough ETH");

        funders.push(msg.sender);
        addressToFundAmount[msg.sender] = addressToFundAmount[msg.sender] + msg.value;
    }

    function withdraw() public onlyOwner {
        for(uint funderIndex = 0; funderIndex < funders.length; funderIndex++) {
            address funder = funders[funderIndex];
            addressToFundAmount[funder] = 0;
        }

        funders = new address[](0);

//        payable(msg.sender).transfer(address(this).balance); // transfer

//        bool sendSuccess = payable(msg.sender).send(address(this).balance); // send
//        require(sendSuccess, "Send failed");

        (bool callSuccess,) = payable(msg.sender).call{ value: address(this).balance }(""); // call
        require(callSuccess, "Call failed");
    }

    modifier onlyOwner() {
        if(msg.sender != owner) { revert NotOwner(); }
        _;
    }

    receive() external payable {
        fund();
    }

    fallback() external payable {
        fund();
    }
}
