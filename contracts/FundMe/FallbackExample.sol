// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract FallbackExample {
    uint256 public result;

    // when we send eth without an explicit function (in deployed contract -> low level interactions -> transact -> call data has to be empty) 
    // it comes to special keword receive
    receive() external payable {
        result = 1;
    }

    // when we send eth without an explicit function 
    // (in deployed contract -> low level interactions -> transact -> call data has to have data in the field) 
    // it comes to special keword fallback
    fallback() external payable {
        result = 2;
    }

    // https://solidity-by-example.org/fallback/
    /*
                        send Ether
                        |
            msg.data is empty?
                    /           \
                yes             no
                |                |
        receive() exists?     fallback()
            /        \
        yes          no
        |            |
    receive()     fallback()
    */

}