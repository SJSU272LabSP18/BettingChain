var BettingEther= artifacts.require("./BettingEther.sol");
module.exports = function(deployer) {
  deployer.deploy(BettingEther);
}

