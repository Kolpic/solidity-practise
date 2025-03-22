// SPDX-License-Identifier: MIT
pragma solidity ^0.8.8;

import "./PriceConverter.sol";

// to get gas down -> immutable, const
// when variable is constant it is not saved in storage, therfore more gas efficient

error NotOwner();
error WithdrawFailed();

// 901,893 GAS -> when made minimumUsd CONST 882,358 GAS -> with errors instead require 744,359 GAS
contract FundMe {
    using PriceConverter for uint256;

    uint256 public constant MINIMUM_USD = 10 * 1e18; // 1 * 10 ** 18
    // 2,451 GAS when minimumUsd is not const -> 351 GAS when it's const

    address[] public funders;
    mapping (address => uint256) public  addressToAmountFunder;

    address public immutable i_ownder;
    // 2,492 GAS when it was not immutable - 356 GAS when is immutable

    constructor() {
        i_ownder = msg.sender;
    }

    // payable is to make a function payable (red buttons)
    function fund() public payable {
        // Want to be able to set a minimum fund amount in USD
        // 1. How do we send ETH to this contract ?

        // to get the value, which is the money inserted by the user -> msg.value
        // Chainlink is from where we get an external data in our contract,
        // in this case to take the value eth/usd
        require(msg.value.getConversionRate() >= MINIMUM_USD, "Didn't send enough"); // 1e18 == 1 * 10 ** 18 == 1000000000000000000 wei -> 1 eth
        // 18 decimals

        // Sender address
        funders.push(msg.sender);
        addressToAmountFunder[msg.sender] = msg.value;
    }

    function withdraw() public onlyOwner {
        for (uint256 funderIndex = 0; funderIndex < funders.length; funderIndex++) {
            address funder = funders[funderIndex];
            addressToAmountFunder[funder] = 0;
        }
        // reset the array
        funders = new address[](0);

        // withdraw the funds, there are three ways: transfer, send, call 

        // transfer
        // msg.sender = address
        // payable(msg.sender) = payable address
        // payable(msg.sender).transfer(address(this).balance);

        // send
        // bool sendSuccess = payable(msg.sender).send(address(this).balance);
        // require(sendSuccess, "Send failed");

        // call
        (bool callSuccess, ) = payable(msg.sender).call{value: address(this).balance}("");
        // require(callSuccess, "Call failed");
        if (!callSuccess) {revert WithdrawFailed();}
    }

    modifier onlyOwner {
        // require(msg.sender == i_ownder, "Sender is not owner!");
        if(msg.sender != i_ownder) {revert NotOwner();}
        _;
    }

    // What happens if someone sends this contract ETH without calling fund function -> FallbackExample.sol

    receive() external payable {
        fund();
    }

    fallback() external payable {
        fund();
    }
}