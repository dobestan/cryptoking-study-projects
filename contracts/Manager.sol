// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;


import "./Soulbound.sol";
import "./UtilityToken.sol";

import "./utils/Matches.sol";
import "./utils/Epochs.sol";


contract Manager {
    using Epochs for Epochs.Epochs;
    using Epoch for Epoch.Epoch;
    
    using Match for Match.Match;
    using Matches for Match.Match[];

    Epochs.Epochs private _epochs;
    address private _soulboundAddress;

    // Refactor _isMatched;
    // _isMatched[account1][account2]
    // AS-IS: mapping(address => mapping(address => bool)) private _isMatched;
    mapping(address => mapping(address => uint)) private _isMatched;
    Match.Match[] private _matches;

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

    function createMatch(address accountA, address accountB) public {
        _matches.create(accountA, accountB);
        (address address0, address address1) = Match._asOrderedAddresses(accountA, accountB);
        _isMatched[address0][address1] = _matches.length;
    }

    // Batch Create(Function Overload)
    function createMatch(address[] memory accountAs, address[] memory accountBs) public {
        _matches.create(accountAs, accountBs);
        // #TODO: should add to _isMatched;
    }

    function isMatched(address accountA, address accountB) public view returns (bool) {
        (address address0, address address1) = Match._asOrderedAddresses(accountA, accountB);
        return _isMatched[address0][address1] > 0;
    }

    function getMatch(uint _matchId) public view returns (Match.Match memory) {
        return _matches.get(_matchId);
    }

    function getMatch(address accountA, address accountB) public view returns (Match.Match memory) {
        (address address0, address address1) = Match._asOrderedAddresses(accountA, accountB);
        uint matchesId = _isMatched[address0][address1] - 1;
        return _matches.get(matchesId);
    }
}