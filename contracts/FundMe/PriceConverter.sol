// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// import directly from github
import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";

library PriceConverter {
    // function to convert the prices. Instance to interact with outside of our project
    function getPrice() internal view returns (uint256){
        // ABI of the external contract. We will take it like a interface, when we compile it we will take the abi
        // Address of the external contract we want to get he price eth/usd (Sepolia Testnet) - 0x694AA1769357215DE4FAC081bf1f309aDC325306
        // docs for address: https://docs.chain.link/data-feeds/price-feeds/addresses?network=ethereum&page=1#sepolia-testnet

        AggregatorV3Interface priceFeed = AggregatorV3Interface(0x694AA1769357215DE4FAC081bf1f309aDC325306);

        // AggregatorV3Interface interface method to take the data docs: https://docs.chain.link/data-feeds/using-data-feeds#solidity
        (, int256 price,,,) = priceFeed.latestRoundData();
        // ETH/USD
        // 3000.00000000

        return uint256(price * 1e10); // 1**10 == 10000000000
    }

    function getVersion() internal  view returns (uint256) {
        // Add the interface and return the version
        AggregatorV3Interface priceFeed = AggregatorV3Interface(0x694AA1769357215DE4FAC081bf1f309aDC325306);
        return priceFeed.version();
    }

    function getConversionRate(uint256 ethAmount) internal view returns (uint256) {
        // how much this eth is in usd
        uint256 ethPrice = getPrice();
        // ethPrice -> 3000_000000000000000000 = ETH / USD price
        // 1_000000000000000000 ETH
        uint256 ethAmountInUsd = (ethPrice * ethAmount) / 1e18; // ethPrice * ethAmount -> 18 decimals
        return ethAmountInUsd;
    }
}