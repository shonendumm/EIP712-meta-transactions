// SPDX-License-Identifier:MIT
// Token created by inheriting from openzeppelin's ERC20 contract

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract SooToken is ERC20 {
    constructor(uint256 initialSupply) ERC20("Soo", "SOO") {
        _mint(msg.sender, initialSupply);
    }


}