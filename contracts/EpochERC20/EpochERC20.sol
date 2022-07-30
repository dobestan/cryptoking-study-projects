// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;

import "@openzeppelin/contracts/utils/Counters.sol";


contract EpochERC20 {
    using Counters for Counters.Counter;

    event Transfer(uint epoch, address indexed from, address indexed to, uint amount);
    event Approval(uint epoch, address indexed from, address indexed to, uint amount);

    mapping(uint => mapping(address => uint)) private _balances;
    mapping(uint => mapping(address => mapping(address => uint))) private _allowances;
    mapping(uint => uint) private _totalSupply;

    string private _name;
    string private _symbol;
    Counters.Counter private _epoch;

    constructor(string memory name_, string memory symbol_) {
        _name = name_;
        _symbol = symbol_;
    }

    function name() public view virtual returns (string memory) {
        return _name;
    }

    function symbol() public view virtual returns (string memory) {
        return _symbol;
    }

    function decimals() public view virtual returns (uint8) {
        return 18;
    }

    function totalSupply() public view virtual returns (uint) {
        return _totalSupply[epoch()];
    }

    function balanceOf(address account) public view virtual returns (uint) {
        return _balances[epoch()][account];
    }

    /**
    * @dev Returns current epoch ID
    **/
    function epoch() public view virtual returns (uint) {
        return _epoch.current();
    }

    function transfer(address to, uint amount) public virtual returns (bool) {
        address owner = msg.sender;
        _transfer(owner, to, amount);
        return true;
    }

    function allowance(address owner, address spender) public view virtual returns (uint) {
        return _allowances[epoch()][owner][spender];
    }

    function approve(address sender, uint amount) public virtual returns (bool) {
        address owner = msg.sender;
        _approve(owner, sender, amount);
        return true;
    }

    function transferFrom(address from, address to, uint amount) public virtual returns (bool) {
        address spender = msg.sender;
        _spendAllowance(from, spender, amount);
        _transfer(from, to, amount);  
        return true;      
    }

    // #TODO: increaseAllowance
    // #TODO: decreaseAllowance

    function _transfer(
        address from,
        address to,
        uint amount
    ) internal virtual {
        require(from != address(0), "EpochERC20: transfer from the zero address");
        require(to != address(0), "EpochERC20: transfer to the zero address");
        uint fromBalance = _balances[epoch()][from];
        require(fromBalance >= amount, "EpochERC20: transfer amount exceeds balance");
        _balances[epoch()][from] = fromBalance - amount;
        _balances[epoch()][to] += amount;
        emit Transfer(epoch(), from, to, amount);
    }

    function _approve(
        address owner,
        address spender,
        uint amount
    ) internal virtual {
        require(owner != address(0), "EpochERC20: approve from the zero address");
        require(spender != address(0), "EpochERC20: approve to the zero address");
        _allowances[epoch()][owner][spender] = amount;
        emit Approval(epoch(), owner, spender, amount);
    }

    function _spendAllowance(
        address owner,
        address spender,
        uint amount
    ) internal virtual {
        uint currentAllowance = allowance(owner, spender);
        if (currentAllowance != type(uint).max) {
            require(currentAllowance >= amount, "EpochERC20: insufficient allowance");
            _approve(owner, spender, currentAllowance - amount);
        }
    }

    function _mint(address account, uint amount) internal virtual {
        require(account != address(0), "EpochERC20: mint to the zero address");
        _totalSupply[epoch()] += amount;
        _balances[epoch()][account] += amount;
        emit Transfer(epoch(), address(0), account, amount);
    }

    /**
    * @dev Create new epoch. Internally increment _epoch(Counter).
    **/
    function _createEpoch() internal virtual returns (uint) {
        _epoch.increment();
        return _epoch.current();
    }

    function _burn(address account, uint amount) internal virtual {
        require(account != address(0), "EpochERC20: burn from the zero address");
        uint accountBalance = _balances[epoch()][account];
        require(accountBalance >= amount, "EpochERC20: burn amount exceeds balance");
        _balances[epoch()][account] -= amount;
        _totalSupply[epoch()] -= amount;
        emit Transfer(epoch(), account, address(0), amount);
    }
}