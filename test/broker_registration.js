var GenesisVisionPlatform = artifacts.require("./GenesisVisionPlatform.sol");

contract("GenesisVisionPlatform", function (accounts) {
    var account = accounts[0];
    var account1 = accounts[1];
    var account2 = accounts[2];
    var account3 = accounts[3];
    var account4 = accounts[4];

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
        return platform.registerBroker("test", account2)
            .then(() => {
                return platform.getBrokerAddress.call("test");
            })
            .then((broker) => {
                console.log(broker);
                assert.equal(account2, broker.valueOf(), "Broker should exist");
            });
    });
});