// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;


library Match {
    struct Match {
        address account0;
        address account1;
        uint matchedAt;
    }

    function create(address accountA, address accountB) public returns (Match memory) {
        (address address0, address address1) = _asOrderedAddresses(accountA, accountB);
        Match memory createdMatch = Match(address0, address1, block.timestamp);
        return createdMatch;
    }

    function _asOrderedAddresses(address accountA, address accountB) public pure returns (address, address) {
        return accountA < accountB ? (accountA, accountB) : (accountB, accountA);
    }
}


library Matches {
    // Default data type: Match.Match[] self

    function get(Match.Match[] storage self, uint _matchId) public view returns (Match.Match storage) {
        return self[_matchId];
    }

    function create(Match.Match[] storage self, address accountA, address accountB) public returns (Match.Match memory) {
        Match.Match memory createdMatch = Match.create(accountA, accountB);
        self.push(createdMatch);
        return createdMatch;
    }

    // Batch Create(Function Overload)
    function create(
        Match.Match[] storage self,
        address[] calldata accountAs,
        address[] calldata accountBs
    ) public {
        require(accountAs.length == accountBs.length, "Matches: matching addresses length mismatch");
        for (uint _i = 0; _i < accountAs.length; _i++) {
            address accountA = accountAs[_i];
            address accountB = accountBs[_i];
            Match.Match memory createdMatch = Match.create(accountA, accountB);
            self.push(createdMatch);
        }
    }
}