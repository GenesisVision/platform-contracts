const GenesisVisionPlatform = artifacts.require("./GenesisVisionPlatform.sol");
const ManagerToken = artifacts.require("./ManagerToken.sol");
const TradingHistoryStorage = artifacts.require("./TradingHistoryStorage.sol");

module.exports = function(deployer, network, accounts) {
    deployer.deploy(GenesisVisionPlatform);
    deployer.deploy(ManagerToken,accounts[0],"Test","TST");
    deployer.deploy(TradingHistoryStorage);
};

