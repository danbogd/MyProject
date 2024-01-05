// contracts/MyNFT.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;


import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

contract MyERC20 is ERC20 {
    address immutable owner;
    constructor() ERC20("Token1", "SYM1") {
        owner = msg.sender;
        _mint(msg.sender, 10_000_000);
    }

    function mint(uint256 _amount) external {
        //require(msg.sender == owner, 'not an owner');
        _mint(msg.sender, _amount);
    }
}


