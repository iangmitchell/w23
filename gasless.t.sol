// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

import "forge-std/Test.sol";
import "forge-std/console.sol";
import "../src/gasless.sol";
import "../src/token.sol";

contract GaslessTransferTest is Test {
    uint256 constant PRIVATE_KEY = 4125; 
    uint256 constant AMOUNT = 4000;
    uint256 constant FEE = 125;
    address sender;
    address receiver;
    GaslessTransfer private gasless;
    lambdaToken private token;

    function setUp() public {
        sender = vm.addr(PRIVATE_KEY);
        receiver = address(2);
        token = new lambdaToken();
        gasless = new GaslessTransfer();
    }

    function testBalances() public {
        address account = address(1);
        console.log("account address:", address(account));
        deal(address(token), account, 100);
        assertEq(token.balanceOf(account), 100 );
        deal(account, 1 ether);
        assertEq(account.balance, 1 ether);
    }

    function testTotal() public view{
        address account = msg.sender;
        assertEq(token.balanceOf(account), 0);
        assertEq(token.totalSupply(), 1000000000000000000000);
    }

    function testValidSig() public {
        uint256 deadline = block.timestamp + 60;
        /*
          need signature of sender
          prepare the message to send
          then return the signature using vm.sign()
          message requires a format as described in _getHashEthereumMsg below
        */
	token.transfer(sender, 5000);
       /* sign the hash message with the sender's private key  */
	bytes32 hashEthereumMsg = _getHashEthereumMsg(
		sender, address(gasless), AMOUNT + FEE, token.nonces(sender), deadline	
	);
        (uint8 v, bytes32 r, bytes32 s) =
            vm.sign(PRIVATE_KEY, hashEthereumMsg);
        // Execute transfer
        gasless.send(address(token), sender, receiver, AMOUNT, FEE, deadline, v, r, s); 
        // pre-check ether balances
        assertEq(sender.balance, 0, "sender ether balance");
        assertEq(receiver.balance, 0, "receiver ether balance");
	assertEq(token.balanceOf(sender), 875, "sender balance");
	assertEq(token.balanceOf(receiver), AMOUNT, "receiver balance");
//	assertEq(token.balanceOf(address(this), token.totalSupply()-AMOUNT+FEE, "RELAY"); 

    }

    function _getHashEthereumMsg(
	address owner,
	address spender,
	uint256 value,
	uint256 nonce,
	uint256 deadline
        ) private view returns (bytes32) {
        return keccak256(
            abi.encodePacked(
                "\x19\x01",
                token.DOMAIN_SEPARATOR(),
                keccak256(
                    abi.encode(
                        keccak256(
                            "Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)"
                        ),
			owner, spender, value, nonce, deadline
                   )
                )
            )
        );
    }
}

