var GenesisVisionPlatform = artifacts.require("./GenesisVisionPlatform.sol");



contract("GenesisVisionPlatform", function (accounts) {

    var owner = accounts[0];
    var platform;

    before('setup', (done) => {
        platform = GenesisVisionPlatform.at("0xb6764c1084ad2c6aca16c184492ec4a0e4c3d7aa");
        done();
    });
  
    // Exchange
    it("should register Larson & Holz", () => {
        return platform.registerExchange("f06dcc4c-8b21-40b6-aa78-76c5333a1424", "Larson & Holz")
        .then(() => {
            return platform.getExchange.call("f06dcc4c-8b21-40b6-aa78-76c5333a1424");
        })
        .then((exchange) => {
            assert.equal("f06dcc4c-8b21-40b6-aa78-76c5333a1424", exchange[0], "Exchange should exist");
        });
    });
    it("should register Finam", () => {
        return platform.registerExchange("0ca9e297-416d-484f-8ae7-ab211e94071a", "Finam")
        .then(() => {
            return platform.getExchange.call("0ca9e297-416d-484f-8ae7-ab211e94071a");
        })
        .then((exchange) => {
            assert.equal("0ca9e297-416d-484f-8ae7-ab211e94071a", exchange[0], "Exchange should exist");
        });
    });
    it("should register "Tools For Brokers"", () => {
        return platform.registerExchange("aea53708-0397-4706-be35-9e2deda66dc4", "Tools For Brokers")
        .then(() => {
            return platform.getExchange.call("aea53708-0397-4706-be35-9e2deda66dc4");
        })
        .then((exchange) => {
            assert.equal("aea53708-0397-4706-be35-9e2deda66dc4", exchange[0], "Exchange should exist");
        });
    });
	 it("should register IDEX", () => {
        return platform.registerExchange("b3e76ec0-8eef-47ae-9205-e383106c3bf3", "IDEX")
        .then(() => {
            return platform.getExchange.call("b3e76ec0-8eef-47ae-9205-e383106c3bf3");
        })
        .then((exchange) => {
            assert.equal("b3e76ec0-8eef-47ae-9205-e383106c3bf3", exchange[0], "Exchange should exist");
        });
    });
});