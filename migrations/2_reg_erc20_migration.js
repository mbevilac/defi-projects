const RToken = artifacts.require("RToken");

module.exports = function (deployer) {
  deployer.deploy(RToken);
};