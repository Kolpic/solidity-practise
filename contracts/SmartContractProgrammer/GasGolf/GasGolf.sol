// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

contract GasGolf {
    // start - 49738 gas
    // use calldata instead of memory - 48010 gas
    // load state variables to memory (instead of accesing the state variable in loop) - 47799 gas
    // short circuit - 47487 gas
    // loop increments (++i instead of i += 1) - 47457 gas 
    // cache array length - 47421 gas
    // load array elements to memory - 47253 gas

    uint public total;

    // [1, 2, 3, 4, 5, 100]
    function sumIfEvenAndLessThan99(uint[] calldata nums) external {
        uint _total = total;
        uint length = nums.length;
        for (uint i = 0; i < length; ++i) {
            uint num = nums[i];
            if (num % 2 == 0 && num < 99) {
                _total += num;
            }
        }
        total = _total;
    }

    // before opt
    // function sumIfEvenAndLessThan99(uint[] memory nums) external {
    //     for (uint i = 0; i < nums.length; i++) {
    //         bool isEven = nums[i] % 2 == 0;
    //         bool isLessThan99 = nums[i] < 99;
    //         if (isEven && isLessThan99) {
    //             total += nums[i];
    //         }
    //     }
    // }
}