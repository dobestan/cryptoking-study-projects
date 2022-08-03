// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;


import "./Soulbound.sol";
import "./UtilityToken.sol";
import "./utils/Epochs.sol";
import "@openzeppelin/contracts/utils/Counters.sol";


contract Manager {
    using Epochs for Epochs.Epochs;
    using Epoch for Epoch.Epoch;

    struct Match {
        address account0;
        address account1;
        uint matchedAt;
    }

    Epochs.Epochs private _epochs;
    address private _soulboundAddress;

    // #TODO: address => address => Match struct.
    // #IDEA: Uniswap V2: createPair, getPair, allPairs.
    // #TODO: (1) Match Struct, (2) Match[] private _allMatches;
    mapping(address => mapping(address => bool)) private _isMatched;
    Match[] private matches;

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

    function createMatch(address accountA, address accountB) public returns (bool) {
        if (isMatched(accountA, accountB)) {
            return false;
        } else {
            (address address0, address address1) = _asOrderedAddresses(accountA, accountB);
            _isMatched[address0][address1] = true;
            Match memory createdMatch = Match(address0, address1, block.timestamp);
            matches.push(createdMatch);
            return true;
        }
    }

    function isMatched(address accountA, address accountB) public view returns (bool) {
        (address address0, address address1) = _asOrderedAddresses(accountA, accountB);
        return _isMatched[address0][address1];
    }

    function getMatch(uint _matchId) public view returns (Match memory) {
        return matches[_matchId];
    }

    function _asOrderedAddresses(address accountA, address accountB) internal pure returns (address, address) {
        return accountA < accountB ? (accountA, accountB) : (accountB, accountA);
    }
}