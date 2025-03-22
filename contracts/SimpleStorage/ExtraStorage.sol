// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./SimpleStorage.sol";

// inheritance
contract ExtraStorage is SimpleStorage {
    // overrite
    // virtual overrite

    function store(uint256 _favoriteNumber) public override {
        favouriteNumber = _favoriteNumber + 5;
    }
}