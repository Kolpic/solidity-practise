// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Calculator {
    uint256 private result;

    function add(uint256 _numberToAdd) public {
        result += _numberToAdd;
    }

    function subtract(uint256 _numberToSubtract) public {
        result -= _numberToSubtract;
    }

    function multiply(uint256 _numberToMultiply) public {
        result *= _numberToMultiply;
    }

    function getResult() public view returns (uint256) {
        return result;
    }
}