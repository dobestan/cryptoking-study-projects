// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;


import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";


contract Soulbound is ERC1155 {
    uint public constant REGISTERED = 0;
    // TODO: REGISTERED Token cannot be transfer(soulbound).

    constructor() ERC1155("") {

    }

    // TODO: Access Control(Ownable).
    function register(address soul) public {
        require(balanceOf(soul, REGISTERED) == 0, "Soulbound: only fresh soul can register.");
        _mint(soul, REGISTERED, 1, "");
    }

    function isRegistered(address account) public view returns (bool) {
        uint registeredBalance = balanceOf(account, REGISTERED);
        return registeredBalance == 1;
    }

    modifier onlyRegistered(address account) {
        require(isRegistered(account), "Soulbound: only registered account can call this function.");
        _;
    }

    function registerTest() public view onlyRegistered(msg.sender) returns (uint) {
        return 1000;
    }
}