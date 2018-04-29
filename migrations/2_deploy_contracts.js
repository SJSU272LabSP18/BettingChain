var BettingEtherColor= artifacts.require("./BettingEtherColor.sol");
var BettingEtherDigit= artifacts.require("./BettingEtherDigit.sol");

module.exports = function(deployer) {
    deployer.deploy(BettingEtherColor,BettingEtherDigit);
    //deployer.deploy(BettingEtherDigit);
}
