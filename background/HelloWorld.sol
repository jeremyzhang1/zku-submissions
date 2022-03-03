// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

contract HelloWorld {
    // number to be stored
    uint256 number;

    // initially set the number to be zero
    constructor () {
        number = 0;
    }

    // get the currently stored number
    function getNumber() public view returns(uint256) {
        return number;
    }

    // set the number to a `newNumber` that is passed in
    function setNumber(uint256 newNumber) public {
        number = newNumber;
    }
}
