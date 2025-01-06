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
}
