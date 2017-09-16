const Escrow = artifacts.require('./Escrow.sol');
contract('Escrow Contract', (accounts) => {
    let EscrowInstance;
    it('should init the contract with 1 eth escrowed', () => {
        return Escrow.new(accounts[1], accounts[2], {
            from: accounts[0],
            value: web3.toWei(1, 'ether'),
            gas: 430000,
            gasPrice: 18
        })
            .then((instance) => {
            EscrowInstance = instance;
            instance.setSeller(accounts[1]);
            return instance.getBalance.call();
        })
            .then((objBalance) => {
            return web3.fromWei(objBalance.toNumber(), 'ether');
        })
            .then((balance) => {
            assert.equal(balance.valueOf(), 1, 'escrow contract does not have 1 eth');
        });
    });
    it('should release the contract funds to the seller', () => {
        return EscrowInstance.releaseEscrow(true)
            .then(() => {
            const sellerBalance = web3.fromWei(web3.eth.getBalance(accounts[1]), 'ether').toNumber();
            console.log(sellerBalance);
            assert.notEqual(sellerBalance, 100, 'seller balance should be greater than 100');
        });
    });
    it('should create a new contract and release funds back to the buyer', () => {
        const buyerStartBalance = web3.fromWei(web3.eth.getBalance(accounts[0]), 'ether').toNumber();
        const sellerStartBalance = web3.fromWei(web3.eth.getBalance(accounts[1]), 'ether').toNumber();
        return Escrow.new(accounts[1], accounts[2], {
            from: accounts[0],
            value: web3.toWei(1, 'ether'),
            gas: 430000,
            gasPrice: 18
        })
            .then((instance) => {
            EscrowInstance = instance;
            instance.setSeller(accounts[1]);
        })
            .then(() => {
            EscrowInstance.releaseEscrow(false);
        })
            .then(() => {
            const sellerBalance = web3.fromWei(web3.eth.getBalance(accounts[1]), 'ether').toNumber();
            assert.equal(sellerBalance, sellerStartBalance, 'seller balance should not have changed');
        });
    });
});
//# sourceMappingURL=escrow.js.map