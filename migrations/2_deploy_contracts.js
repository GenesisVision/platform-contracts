const Models = artifacts.require("./libs/Models.sol");
const IterableMap = artifacts.require("./libs/IterableMap.sol");
const GenesisVisionPlatform = artifacts.require("./GenesisVisionPlatform.sol");

module.exports = function(deployer, network, accounts) {
    const manager = accounts[0];

    deployer.deploy(Models);
    deployer.link(Models, IterableMap);
    deployer.link(Models, GenesisVisionPlatform);
    deployer.deploy(IterableMap);
    deployer.link(IterableMap, GenesisVisionPlatform);
    deployer.deploy(GenesisVisionPlatform);
};

