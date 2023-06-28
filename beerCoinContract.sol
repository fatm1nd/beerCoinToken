// contracts/GLDToken.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract BeerCoin is ERC20 {

    address barmen = 0xD8C7978Be2A06F5752cB727fB3B7831B70bF394d;
    uint256 barmenFee = 50;

    constructor(uint256 initialSupply) ERC20("BeerCoin", "PNT") {
        _mint(msg.sender, initialSupply);
    }

    function transfer(address to, uint256 amount) public virtual override returns (bool) {
        address owner = _msgSender();
        require(balanceOf(owner) >= (barmenFee + amount), "Your account does not have enough money (fee to barmen + amount)");
        _transfer(owner, to, amount);
        _transfer(owner, barmen, barmenFee);
        return true;
    }

    function transferFrom(address from, address to, uint256 amount) public virtual override returns (bool) {
        address spender = _msgSender();
        require(balanceOf(msg.sender) >= (barmenFee + amount), "Sender does not have enough money (fee to barmen + amount)");
        _spendAllowance(from, spender, amount);
        _spendAllowance(from, spender, amount);
        _transfer(from, to, amount);
        _transfer(from, barmen, barmenFee);
        return true;
    }

    function _spendAllowance(address owner, address spender, uint256 amount) internal override virtual {
        uint256 currentAllowance = allowance(owner, spender);
        if (currentAllowance != type(uint256).max) {
            require(currentAllowance >= (amount + barmenFee), "ERC20: insufficient allowance");
            unchecked {
                _approve(owner, spender, currentAllowance - amount);
            }
        }
    }
}