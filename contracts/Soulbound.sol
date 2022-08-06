// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;


import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/access/Ownable.sol";


contract Soulbound is ERC1155, Ownable {
    uint public constant REGISTERED = 0;
    // uint public constant SOMETHING_TRANSFERABLE = 1;

    event Register(address indexed soul);

    mapping(uint => bool) public isTransferable;

    constructor() ERC1155("") {
        // Transferable Whitelist
        // isTransferable[SOMETHING_TRANSFERABLE] = true;
    }

    function setTransferable(uint _tokenId, bool transferable) public onlyOwner {
        isTransferable[_tokenId] = transferable;
    }

    function _beforeTokenTransfer(
        address operator,
        address from,
        address to,
        uint[] memory ids,
        uint[] memory amounts,
        bytes memory data
    ) internal virtual override {
        // _beforeTokenTransfer called on 
        // _safeTransferFrom, _safeBatchTransferFrom, _mint, _mintBatch, _burn, _burnBatch.
        super._beforeTokenTransfer(operator, from, to, ids, amounts, data);
        require(msg.sender == owner() || isTransferable[ids[0]], "Soulbound: Token is non-transferable.");
    }

    function register(address soul) public onlyOwner {
        require(balanceOf(soul, REGISTERED) == 0, "Soulbound: only fresh soul can register.");
        _mint(soul, REGISTERED, 1, "");
        emit Register(soul);
    }

    function isRegistered(address account) public view returns (bool) {
        uint registeredBalance = balanceOf(account, REGISTERED);
        return registeredBalance == 1;
    }

    modifier onlyRegistered(address account) {
        require(isRegistered(account), "Soulbound: only registered account can call this function.");
        _;
    }
}