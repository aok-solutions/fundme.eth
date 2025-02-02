// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import { PriceConverter } from "./PriceConverter.sol";

contract FundMe {
    using PriceConverter for uint;

    uint public minimumUsd = 5e18;
    address[] public funders;
    mapping(address funder => uint fundAmount) public addressToFundAmount;

    function fund() public payable {
        require(msg.value.getConversionRate() >= minimumUsd, "didn't send enough ETH");

        funders.push(msg.sender);
        addressToFundAmount[msg.sender] = addressToFundAmount[msg.sender] + msg.value;
    }

    function withdraw() public {
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
}
