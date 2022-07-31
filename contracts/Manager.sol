// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;


import "./Soulbound.sol";
import "./UtilityToken.sol";
import "./utils/Epochs.sol";
import "@openzeppelin/contracts/utils/Counters.sol";


contract Manager {
    using Epochs for Epochs.Epochs;
    using Epoch for Epoch.Epoch;

    Epochs.Epochs private _epochs;
    address private _soulboundAddress;

    constructor() {
        // Initiate SBT(SoulBound Token) contract.
        Soulbound _soulbound = new Soulbound();
        _soulboundAddress = address(_soulbound);
    }

    function soulbound() public view returns (Soulbound) {
        return Soulbound(_soulboundAddress);
    }

    function register() external {
        soulbound().register(msg.sender);        
    }

    function epochId() public view returns (uint) {
        return _epochs.id();
    }

    function epoch() public view returns (Epoch.Epoch memory) {
        return _epochs.current();
    }

    function createEpoch(uint _initialSupply) public returns (uint) {
        return _epochs.create(_initialSupply);
    }

    function getEpoch(uint _epochId) public view returns (Epoch.Epoch memory) {
        return _epochs.get(_epochId);
    }

    function token() public view returns (UtilityToken) {
        return _epochs.current().token();
    }
}