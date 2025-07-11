//SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Permit.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract GaslessTransfer  {
    function send(
	address token,
	address sender,
	address receiver,
	uint256 amount,
	uint256 fee,
	uint256 deadline,
	uint8 v,
	bytes32 r,
	bytes32 s	    
    ) external {
        // Permit
	ERC20Permit(token).permit(
		sender, address(this), amount+ fee, deadline, v, r, s		
	);
        // Send amount to receiver
	ERC20Permit(token).transferFrom(sender, receiver, amount);
        // Take fee - send fee to msg.sender
	ERC20Permit(token).transferFrom(sender, msg.sender, fee);
    }
}
