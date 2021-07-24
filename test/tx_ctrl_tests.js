const TxCtrl = artifacts.require('../../TransferControl.sol');

contract('TxCtrl', function(accounts) {

    it('allows global receiver for account 1', async function(){

        const contract = await TxCtrl.deployed();
        await contract.allowGlobalReceiver(accounts[0]);
        var resp = await contract.isTransferAllowed(accounts[1], accounts[0], {from: accounts[0]});
        assert.isTrue(resp, "Global receiver is not allowed ");

    });

    it('allows transfer from 1 to 4', async function(){

        const contract = await TxCtrl.deployed();
        await contract.allowTransfer(accounts[1], accounts[4], {from: accounts[0]});
        var resp = await contract.isTransferAllowed(accounts[1], accounts[4], {from: accounts[0]});
        assert.isTrue(resp, "Global receiver is not allowed ");

    });

});