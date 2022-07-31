// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;


import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";


contract Soulbound is ERC1155 {
    uint public constant REGISTERED = 0;
    // TODO: REGISTERED Token cannot be transfer(soulbound).

    constructor() ERC1155("") {

    }

    // TODO: Access Control(Ownable).
    // TODO: User can register only once.
    function register(address soul) public {
        _mint(soul, REGISTERED, 1, "");
    }
}