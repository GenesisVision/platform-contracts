const GenesisVisionPlatform = artifacts.require("./GenesisVisionPlatform.sol");
const ManagerToken = artifacts.require("./ManagerToken.sol");

module.exports = function(deployer, network, accounts) {
    deployer.deploy(GenesisVisionPlatform);
    test:   deployer.deploy(ManagerToken,accounts[0],"Elshan","ELS");
};

