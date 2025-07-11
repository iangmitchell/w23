// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Permit.sol";

contract lambdaToken is ERC20, ERC20Permit{
    constructor() ERC20("lambda", "lam") ERC20Permit('lambda') {
        _mint(msg.sender, 1000 * 10 ** decimals());
  }
 
}
