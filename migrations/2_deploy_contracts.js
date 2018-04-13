var Protchain = artifacts.require("./Protchain.sol");

module.exports = function(deployer) {
  deployer.deploy(Protchain);
};
