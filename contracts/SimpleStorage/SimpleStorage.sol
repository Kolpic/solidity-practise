// SPDX-License-Identifier: MIT
pragma solidity ^0.8.8;

// EVM, Ethereum Virtual Machine

contract SimpleStorage {
    // boolean, unit (unsigned integer, whole number which is possitive), int(possitive or negative whole number), address, bytes
    // bool hasFavouriteNumber = true;
    // string favouriteNumberInText = "Five";

    uint256 favouriteNumber;
    // People public person = People(103, "Amit");

    mapping (string => uint256) public nameToFavoriteNumber;

    People[] public people;

    struct People {
        uint favouriteNumber;
        string name;
    }

    function store(uint256 _favoriteNumber) public virtual {
        favouriteNumber = _favoriteNumber;
    }

    // view, pure -> no gas (just read, no modification of state)
    function retrieve() public view returns (uint256) {
        return favouriteNumber;
    }

    // call - exists only during transaction(temp variable that can't be modified), 
    // memory - exists only during transaction(temp variable that can be modified), 
    // storage - perminant varable that can be modified
    function addPerson(string memory _name, uint _favoriteNumber) public {
        people.push(People(_favoriteNumber, _name));
        nameToFavoriteNumber[_name] = _favoriteNumber;
    }
}