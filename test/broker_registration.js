var GenesisVisionPlatform = artifacts.require("./GenesisVisionPlatform.sol");

contract("GenesisVisionPlatform", function (accounts) {
    var account = accounts[0];
    var account1 = accounts[1];

    var platform;

    before('setup', (done) => {
        GenesisVisionPlatform.deployed().then((_platform) => {
            platform = _platform;
            return platform.setGenesisVisionManager(account);
        })
        .then(() => {
            done();
        });
    });

    it("should register broker", () => {
        return platform.registerBroker("test", account1)
            .then(() => {
                return platform.getBrokerAddress.call("test");
            })
            .then((broker) => {
                assert.equal(account1, broker.valueOf(), "Broker should exist");
            });
    });
});