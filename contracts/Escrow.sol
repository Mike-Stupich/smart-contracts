pragma solidity ^0.4.11;

contract Escrow { 

    // Declare buyer, seller and arbiter address, and eth balance of the contract
    address public buyer;
    address public seller;
    address public arbiter;

    // Event to be raised when buyer calls releaseEscrow
    event FundsReleased(address _address);

    // Dev event to see contract creation
    event ContractCreated(address _buyer, address _seller, address _arbiter, uint value);
    
    event SellerSet(address _seller);

    event ArbiterSet(address _arbiter);

    // Modifier for allowing only the buyer to call a function
    modifier onlyAuthorized () {
        require(msg.sender == buyer || msg.sender == arbiter);
        _;
    }

    // Constructor of the Escrow contract. Holds the buyers eth value until goods received
    function Escrow(address _seller, address _arbiter) payable {
        buyer = msg.sender;
        seller = _seller;
        arbiter = _arbiter;
        ContractCreated(buyer, seller, arbiter, msg.value);
    }

    function setSeller(address _seller) onlyAuthorized {
        seller = _seller;
        SellerSet(_seller);
    }

    function setArbiter(address _arbiter) onlyAuthorized {
        arbiter = _arbiter;
        ArbiterSet(_arbiter);
    }

    // Function to release the funds when the goods are received
    function releaseEscrow(bool goodsReceived) onlyAuthorized {
        var addr = goodsReceived ? seller : buyer;
        if (goodsReceived) {
            addr.transfer(this.balance);
        } else {
            addr.transfer(this.balance);
        }
        FundsReleased(addr);

        // Destroy contract once escrow has been completed
        selfdestruct(buyer);
    }

    function getBalance() constant returns (uint) {
        return this.balance;
    }
}