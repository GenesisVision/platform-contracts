const GenesisVisionPlatform = artifacts.require("./GenesisVisionPlatform.sol");

module.exports = function(deployer, network, accounts) {
    deployer.deploy(GenesisVisionPlatform);
};

