const RToken = artifacts.require("RToken");
const LPool = artifacts.require("LiquidityPool");


module.exports = async (deployer) => {

  await deployer.deploy(RToken);
  tokenInstance = await RToken.deployed();
  
  await deployer.deploy(LPool, tokenInstance.address);
  lpInstance = await LPool.deployed();

  await tokenInstance.setIssuer(lpInstance.address);
  
};