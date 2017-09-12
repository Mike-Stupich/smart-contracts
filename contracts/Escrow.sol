pragma solidity ^0.4.11;

contract Escrow { 
    mapping(address => uint) balances;
    address buyer;
    address seller;

    modifier onlyBuyer () {
        require(msg.sender == buyer);
        _;
    }

    function Escrow() {
        buyer = msg.sender;
    }

    function releaseEscrow(bool goodsReceived) onlyBuyer returns(bool success) {
        if (goodsReceived) {
            
        } else {

        }
    }


}