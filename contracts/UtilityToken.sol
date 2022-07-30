// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";


contract UtilityToken is ERC20, Ownable {
    constructor(uint _initialSupply) ERC20("UtilityToken", "UT") {
        _mint(msg.sender, _initialSupply);
    }
}