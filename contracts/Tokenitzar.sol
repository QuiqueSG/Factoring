// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

//Necessitem l'estandard ERC20 ja implementant
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract Tokfa is ERC20 {

    constructor(uint256 quants_tokens) ERC20("Tokfa", "TFA") {
        _mint(tx.origin, quants_tokens * 10**uint(decimals()));
    }

    function approve(address owner, address spender, uint256 amount) public {
        _approve(owner, spender, amount);
    }

    function generate(uint256 news) public {
        _mint(tx.origin, news);
    }
}