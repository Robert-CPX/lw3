// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.4;

contract Coin {
    address public minter;
    mapping(address => uint) public balances;

    event Sent(address indexed from, address indexed to, uint amount);

    constructor() {
        minter = msg.sender;
    }

    function mint(address receiver, uint amount) public {
        require(msg.sender == minter);
        balances[receiver] += amount;
    }

    error InsufficientBalance(uint requested, uint available); 
    
    function send(address receiver, uint amount) public {
        if (amount > balances[receiver])
            revert InsufficientBalance({
                requested: amount,
                available: balances[msg.sender]
            });

            balances[msg.sender] -= amount;
            balances[receiver] += amount;
            emit Sent(msg.sender, receiver, amount);
    }
}

