// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;

import "./EpochERC20.sol";


contract EpochUtilityToken is EpochERC20 {
    constructor(uint _initialSupply) EpochERC20("EpochUtilityToken", "EUT") {
        _createEpoch();
        _mint(msg.sender, _initialSupply);
    }

    function createEpoch(uint _initialSupply) public returns (uint) {
        uint currentEpoch = _createEpoch();
        _mint(msg.sender, _initialSupply);
        return currentEpoch;
    }
}