var TradingHistoryStorage = artifacts.require("./TradingHistoryStorage.sol");


contract("TradingHistoryStorage", function (accounts) {

    var contractOwner = accounts[0];
    var genesisVisionAdmin = accounts[1];
    var platform;

    before('setup', (done) => {
        TradingHistoryStorage.deployed().then((_platform) => {
            platform = _platform;
        })
        .then(() => {
            done();
        });
    });

    it("should set GenesisVisionAdmin", () => {
        return platform.setGenesisVisionAdmin(genesisVisionAdmin)
            .then(() => {
                return platform.genesisVisionAdmin.call();
            })
            .then((admin) => {
                assert.equal(admin,genesisVisionAdmin, "GenesisVisionAdmin must change");
            });
    });

    it("not should set GenesisVisionAdmin", (done) => {
        platform.setGenesisVisionAdmin(genesisVisionAdmin, { from: accounts[2] }).catch(function(error) { 
            if(error.message == "VM Exception while processing transaction: revert"){
                done();
            }else {
                throw new Error("Unexpected exception: " + error.message);
            }  
        });
    });
    
    it("should set new ipfs hash", () => {
        return platform.updateIpfsHash("test1")
            .then(() => {
                return platform.ipfsHash.call();
            })
            .then((hash) => {
                assert.equal(hash,"test1", "Ipfs hash must change");
            });
    });


    it("not should set new ipfs hash", (done) => {
        platform.updateIpfsHash("test1", { from: accounts[2] }).catch(function(error) { 
            if(error.message == "VM Exception while processing transaction: revert"){
                done();
            }else {
                throw new Error("Unexpected exception: " + error.message);
            }  
        });
    });
});