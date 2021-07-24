const RToken = artifacts.require("RToken");
const LPool = artifacts.require("LiquidityPool");
const TCtrl = artifacts.require("TransferControl.sol");


module.exports = async (deployer) => {

  await deployer.deploy(RToken);
  tokenInstance = await RToken.deployed();
  
  await deployer.deploy(LPool, tokenInstance.address, {value: 10*1e18});
  lpInstance = await LPool.deployed();

  await tokenInstance.setIssuer(lpInstance.address);

  await deployer.deploy(TCtrl);
  txCtrlInstance = await TCtrl.deployed();
  
};