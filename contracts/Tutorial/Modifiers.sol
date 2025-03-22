// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract PausableToken {
    address public owner;
    bool public paused;
    mapping (address => uint) public balances;

    constructor() {
        owner = msg.sender;
        paused = false;
        balances[owner] = 1000;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "You are not the owner");
        _;
    }

    modifier notPused() {
        require(paused == false, "The contract is paused");
        _;
    }

    function pause() public onlyOwner {
        paused = true;
    }

    function unPause() public onlyOwner {
        paused = false;
    }

    function transfer (address to, uint amount) public notPused {
        require(balances[msg.sender] >= amount, "Low balance, can't make a transfer");

        balances[msg.sender] -= amount;
        balances[to] += amount;
    }
}