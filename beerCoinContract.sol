// contracts/GLDToken.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract BeerCoin is ERC20 {
    // 000000000000000000 - 18 zeros
    // 
    mapping(address => uint256) private __balances;
    address[] private addressesList;

    address barmen = 0xD8C7978Be2A06F5752cB727fB3B7831B70bF394d;
    uint256 barmenFee = 50 * (10 ** decimals());

    constructor(uint256 initialSupply) ERC20("BeerCoin", "PNT") {
        _mint(msg.sender, initialSupply * (10 ** decimals()));
        returnAddressID(barmen);
        returnAddressID(msg.sender);
    }

    function transfer(address to, uint256 amount) public virtual override returns (bool) {
        address owner = _msgSender();
        require(balanceOf(owner) >= (barmenFee + amount), "Your account does not have enough money (fee to barmen + amount)");
        _transfer(owner, to, amount);
        _transfer(owner, barmen, barmenFee);
        copyTransaction(owner,to);
        return true;
    }

    function transferFrom(address from, address to, uint256 amount) public virtual override returns (bool) {
        address spender = _msgSender();
        require(balanceOf(msg.sender) >= (barmenFee + amount), "Sender does not have enough money (fee to barmen + amount)");
        _spendAllowance(from, spender, amount);
        _spendAllowance(from, spender, amount);
        _transfer(from, to, amount);
        _transfer(from, barmen, barmenFee);
        copyTransaction(from,to);
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

    function getAll() public view returns ( address[] memory, uint256[] memory){
        
        uint256[] memory users = new uint256[](addressesList.length);
        address userAddress;
        for (uint256 i = 0; i < addressesList.length; i++) 
        {
            userAddress = addressesList[i];
            users[i] = balanceOf(userAddress);  
        }
        return (addressesList,users);
    }

    function getUsers() public view returns (address[] memory){
        return addressesList;
    }

    function returnAddressID(address user) internal returns (uint256){
        for (uint256 i = 0; i < addressesList.length; i++) 
        {
            if (addressesList[i] == user){
                return i;
            }   
        }
        addressesList.push(user);
        __balances[user] = 0;
        return addressesList.length - 1;
    }

    function copyTransaction(address from, address to) internal virtual {
        returnAddressID(from);
        returnAddressID(to);
        unchecked {
            __balances[from] = balanceOf(from);
            __balances[to] += balanceOf(to);
            __balances[barmen] += balanceOf(barmen);
        }
    }

}