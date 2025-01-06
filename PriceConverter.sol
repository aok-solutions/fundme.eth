// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import { AggregatorV3Interface } from "@chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";

library PriceConverter {
    function getPrice() internal view returns(uint) {
        AggregatorV3Interface priceFeed = AggregatorV3Interface(0x694AA1769357215DE4FAC081bf1f309aDC325306);
        (, int price,,,) = priceFeed.latestRoundData();

        return uint(price * 1e10);
    }

    function getConversionRate(uint ethAmount) internal view returns(uint) {
        uint ethPrice = getPrice();
        uint ethAmountInUsd = (ethPrice * ethAmount) / 1e18;
        return ethAmountInUsd;
    }
}
