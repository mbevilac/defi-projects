const RToken = artifacts.require('../../RToken.sol');
const LPool = artifacts.require('../../LiquidityPool.sol');

contract('Rtoken', function(accounts) {

    it('init rtokencheck supply', async function(){

        const contract = await RToken.deployed();
        const supply = await contract.totalSupply();
        assert.equal(supply, 100, "Supply do not match. Expected 100 got instead ".concat(supply));

    });

    it('balance of issuer account', async function() {
        const contract = await RToken.deployed();
        const balance = await contract.balanceOf(accounts[0]);
        assert.equal(balance, 100, "The whole balance should be assigned to address(0)");

    });

    it('transfers 15 tokens from account0 to account1 with auth', async function() {
        const contract = await RToken.deployed({from: accounts[0]});
        const lpool = await LPool.deployed({from: accounts[0]});
        
        await contract.setIssuer(lpool.address, {from: accounts[0]});
        
        
        console.log("token address: " + contract.address);
        console.log("liquidity pool address: " + lpool.address);

        await contract.authorize(accounts[1], {from: lpool.address});
        await contract.transfer(accounts[1], 15, {from: accounts[0]});
        const balance0 = await contract.balanceOf(accounts[0]);
        const balance1 = await contract.balanceOf(accounts[1]);
        assert.equal(100 - balance0, balance1, "The transferred tokens from 0 to 1 do not match. Balance 0 is: ".concat(balance0).concat(" and Balance1 is: ").concat(balance1));

    });

    it('approves address2 allowance with 20 token', async function() {
        const contract = await RToken.deployed();
        await contract.approve(accounts[2], 20, {from: accounts[0]});
        const allowance = await contract.allowance(accounts[0], accounts[2]);
    
        assert.equal(allowance, 20, "The allowed tokens do not match. Got ".concat(allowance));

    });

    it('transfer 15 tokens from 0 to 2, after auth and approving 20 tokens', async function() {
        const contract = await RToken.deployed();
        const lpool = await LPool.deployed();

        console.log("token address: " + contract.address);
        console.log("liquidity pool address: " + lpool.address);

        await contract.authorize(accounts[2], {from: lpool.address});
        await contract.approve(accounts[2], 20, {from: accounts[0]});
        
        await contract.transferFrom(accounts[0], accounts[2], 15);
        const allowance = await contract.allowance(accounts[0], accounts[2]);
    
        assert.equal(allowance, 5, "The allowed tokens do not match. Got ".concat(allowance));

    });

});