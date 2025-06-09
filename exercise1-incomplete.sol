//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract MyToken is ______________ {
    constructor(_______ initialOwner)
        _____("MyToken", "MTK")
        _______(initialOwner)
    {}

    function mint(_______ to, _______ amount) public onlyOwner {
        _mint(to, amount);
    }

    function transferFromCall(address _owner, address _to, uint _amount) public {
        transferFrom(_owner, _to, _amount);
    }
}


contract ico is Ownable(msg.sender){
    MyToken public token;
    address tokenAddress;
    _______ (address => uint) public contributors;

    uint mintAmount;

    constructor (_______  _tokenAddress) {
        tokenAddress = _____________;
        Ownable(msg.sender);
        token = MyToken(_____________);
    }

    receive() ________ _______ { }
   
    function exchange( ) external _______ {
        require( msg.value < msg.sender.balance, "Insufficient Funds");
        payable(address(____)).transfer(msg._____); //pay the contract
        contributors[msg.sender] += msg._____; // keep a tally of who has paid, for receipts 
    }

    function approveContractAsSpender(uint _amt) public onlyOwner() {
        token.approve(address(this), _amt);
    }

    function transferTokenCall(uint _amount) public {
        require(contributors[msg.sender] > 0, "must contribute");
        (bool success,) = tokenAddress.call(abi.___________________("transferFromCall(_______________________)", owner(), msg.sender, _amount) );
        require(success, "call failed");
	    contributors[msg.sender] = 0;
    }

    function withdraw () external _______ onlyOwner() {
        payable(owner()).transfer(address(____)._______);
    }       
}
/**********************************************************
Problem: 
when call is made it is from the contract, not tx.origin
so the msg.sender is the contract address
the spender is the contract address
Therefore, the approval is from contract address to contract address.
At first this may seem an inconvenience, however, it is there for security
The logic: Allowing the approval of a spender to a random account could pose problems.
If I could allocate the owner, it stands to reason there must be a way to allocate another account.
If I could approve the contract address to any account, this would raise a security risk
It would mean that I could pass the owner as X and be approved to spend from their account, without
their approval!
There is issues with approval, it can only be completed inside, or call through front-end
**********************************************************/


    
