// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import { AggregatorV3Interface } from "@chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";

contract FundMe {
    uint public minimumUsd = 5e18;
    address[] public funders;
    mapping(address funder => uint fundAmount) public addressToFundAmount;

    function fund() public payable {
        require(getConversionRate(msg.value) >= minimumUsd, "didn't send enough ETH");

        funders.push(msg.sender);
        addressToFundAmount[msg.sender] = addressToFundAmount[msg.sender] + msg.value;
    }

    function getPrice() public view returns(uint) {
        AggregatorV3Interface priceFeed = AggregatorV3Interface(0x694AA1769357215DE4FAC081bf1f309aDC325306);
        (, int price,,,) = priceFeed.latestRoundData();

        return uint(price * 1e10);
    }

    function getConversionRate(uint ethAmount) public view returns(uint) {
        uint ethPrice = getPrice();
        uint ethAmountInUsd = (ethPrice * ethAmount) / 1e18;
        return ethAmountInUsd;
    }
}
