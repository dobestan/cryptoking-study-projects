// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;


import "./UtilityToken.sol";
import "@openzeppelin/contracts/utils/Counters.sol";


contract Manager {
    using Counters for Counters.Counter;

    struct Epoch {
        address tokenContractAddress;
    }

    Counters.Counter private _epochId;
    Epoch[] private _epochs;

    event EpochCreated(uint EpochId, address tokenContractAddress);

    function epochId() public view virtual returns (uint) {
        return _epochId.current();
    }

    /// @dev Return current epoch.
    function epoch() public view virtual returns (Epoch memory) {
        require(_epochId.current() > 0, "Epoch: not a single epoch is created.");
        return _epochs[_epochId.current() - 1];
    }

    function getEpoch(uint epochId_) public view virtual returns (Epoch memory) {
        return _epochs[epochId_ - 1];
    }

    /// @dev Create a new epoch.
    function createEpoch(uint _initialSupply) public returns (uint) {
        _epochId.increment();
        
        // 1. create a new ERC20 UtilityToken.
        UtilityToken token = new UtilityToken(_initialSupply);
        address tokenContractAddress = address(token);
        
        // 2. create a new Epoch and append to _epochs array.
        Epoch memory createdEpoch = Epoch(tokenContractAddress);
        _epochs.push(createdEpoch);
        
        emit EpochCreated(_epochId.current(), tokenContractAddress);       
        
        return _epochId.current();
    }
}