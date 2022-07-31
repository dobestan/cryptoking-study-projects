// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;


import "@openzeppelin/contracts/utils/Counters.sol";
import "../UtilityToken.sol";


library Epoch {  
    struct Epoch {
        address tokenContractAddress;
    }

    function token(Epoch storage self) internal view returns (UtilityToken) {
        return UtilityToken(self.tokenContractAddress);
    }
}


/// @title A implementation for epochs.
/// @author Suchan An
/// @dev SOC(Separation of Concerns) for epochs management.
library Epochs {
    using Counters for Counters.Counter;

    struct Epochs {
        Counters.Counter _epochId;
        Epoch.Epoch[] _epochs;
    }

    event EpochCreated(uint EpochId, address tokenContractAddress);

    function id(Epochs storage self) internal view returns (uint) {
        require(self._epochId.current() > 0, "Epochs: not a single epoch is created.");
        return self._epochId.current();
    }

    function current(Epochs storage self) internal view returns (Epoch.Epoch storage) {
        require(self._epochId.current() > 0, "Epochs: not a single epoch is created.");
        return self._epochs[self._epochId.current() - 1];
    }

    function get(Epochs storage self, uint epochId_) internal view returns (Epoch.Epoch storage) {
        return self._epochs[epochId_ - 1];
    }

    function create(Epochs storage self, uint _initialSupply) internal returns (uint) {
        self._epochId.increment();

        // 1. create a new ERC20 UtilityToken.
        UtilityToken token = new UtilityToken(_initialSupply);
        address tokenContractAddress = address(token);
        
        // 2. create a new Epoch and append to _epochs array.
        Epoch.Epoch memory createdEpoch = Epoch.Epoch(tokenContractAddress);
        self._epochs.push(createdEpoch);
        
        emit EpochCreated(self._epochId.current(), tokenContractAddress);       
        
        return self._epochId.current();
    }
}