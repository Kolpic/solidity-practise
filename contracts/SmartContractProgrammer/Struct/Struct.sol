// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

contract Structs {
    struct Car {
        string model;
        uint year;
        address owner;
    }

    Car public car;
    Car[] public cars;
    mapping (address => Car[]) public carsByOwner;

    function examples() external {
        Car memory toyota = Car ("Toyota", 1990, msg.sender);
        Car memory lambo = Car ({year: 1980, model: "Lambo", owner: msg.sender});
        Car memory tesla;
        tesla.model = "Tesla";
        tesla.year = 2018;
        tesla.owner = msg.sender;

        cars.push(toyota);
        cars.push(lambo);
        carsByOwner[msg.sender].push(tesla);

        Car storage _car = cars[0];
        _car.model = "Ferrari";
        delete _car.owner;

        delete cars[1];
    }
}