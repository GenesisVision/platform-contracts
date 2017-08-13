const IMap = artifacts.require("./libs/IMap.sol");
const Models = artifacts.require("./libs/Models.sol");
const IMapModels = artifacts.require("./libs/IMapModels.sol");
const GenesisVisionPlatform = artifacts.require("./GenesisVisionPlatform.sol");

module.exports = function(deployer, network, accounts) {
    const manager = accounts[0];

    deployer.deploy(IMap);
    deployer.link(IMap, Models);
    deployer.deploy(Models);
    deployer.link(Models, IMapModels);
    deployer.link(Models, GenesisVisionPlatform);
    deployer.deploy(IMapModels);
    deployer.link(IMapModels, GenesisVisionPlatform);
    deployer.deploy(GenesisVisionPlatform);
};

