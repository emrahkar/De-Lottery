//SPDX-License-Identifier: MIT

pragma solidity >=0.5.0 <0.9.0;

contract DeLoto{

    address payable[] public participants;
    address public owner;

    constructor() {

        owner = msg.sender;
        participants.push(payable(owner));
    }

    receive() payable external {

        require(msg.value == 0.1 ether, "You have to pay 0.1 ETH");
        participants.push(payable(msg.sender));

    }

    function getBalance() public view returns(uint){
        
        require(msg.sender == owner);
        return address(this).balance;
    }

    function random() internal view returns(uint){
        return uint(keccak256(abi.encodePacked(block.difficulty, block.timestamp, participants.length)));
    }
    
    
    function selectWinner() public{
        
        require(msg.sender == owner);
        require (participants.length >= 4);
        address payable winner;
        
        uint index = random() % participants.length;
        winner = participants[index]; 
        
        uint winnerPrize = getBalance() * 90 / 100;
        uint commission = getBalance() * 10/100;

        winner.transfer(winnerPrize);
        payable(owner).transfer(commission);

        
        participants = new address payable[](0);
    }
 
}

//This code is for project purposes only, no financial advice;
