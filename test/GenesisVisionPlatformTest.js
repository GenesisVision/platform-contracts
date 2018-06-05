var GenesisVisionPlatform = artifacts.require("./GenesisVisionPlatform.sol");



contract("GenesisVisionPlatform", function (accounts) {

    var owner = accounts[0];
    var platform;

    before('setup', (done) => {
        GenesisVisionPlatform.deployed().then((_platform) => {
            platform = _platform;
        })
        .then(() => {
            done();
        });
    });
    // Exchange
    it("should register Exchange", () => {
        return platform.registerExchange("exchange1", "asd","host")
            .then(() => {
                return platform.getExchange.call("exchange1");
            })
            .then((exchange) => {
                assert.equal("exchange1", exchange[0], "Exchange should exist");
            });
    });

    it("should not register Exchange with the same id", (done) => {
            var a =  platform.registerExchange("exchange1", "","").catch(function(error) { 
                if(error.message == "VM Exception while processing transaction: revert"){
                    done();
                }else {
                    throw new Error("Unexpected exception: " + error.message);
                }  
            });
    });

    // Investment
    it("should not register investment program with the exchange not found", (done) => {
        platform.createInvestmentProgram("Elshan", "ELS", "idInvestmentProgram1", "asdasd", "ipfsHash").catch(function(error) { 
            if(error.message == "VM Exception while processing transaction: revert"){
                done();
            }else {
                throw new Error("Unexpected exception: " + error.message);
            }  
        });
    });

    it("should register investment program", () => {
        return platform.createInvestmentProgram("Elshan", "ELS", "idInvestmentProgram1", "exchange1", "ipfsHash")
            .then(() => {
                return platform.getInvestmentProgram.call("idInvestmentProgram1");
            })
            .then((investmentProgram) => {
                assert.equal("idInvestmentProgram1", investmentProgram[1], "Broker investment program exist");
            });
    });

    it("should not register investment program with the same id", (done) => {
        var a =  platform.createInvestmentProgram("Elshan", "ELS", "idInvestmentProgram1", "exchange1", "ipfsHash").catch(function(error) { 
            if(error.message == "VM Exception while processing transaction: revert"){
                done();
            }else {
                throw new Error("Unexpected exception: " + error.message);
            }  
        });
    });

    it("should level up investment program", () => {
        return platform.raiseLevelInvestmentProgram("idInvestmentProgram1", 1000)
            .then(() => {
                return platform.getInvestmentProgram.call("idInvestmentProgram1");
            })
            .then((investmentProgram) => {
                assert.equal(2, Number(investmentProgram[4]), "Investment program level up");
            });
    });

    it("should update Investment Program History IpfsHash", () => {
        return platform.updateInvestmentProgramHistoryIpfsHash("idInvestmentProgram1", "NewHash")
            .then(() => {
                return platform.getInvestmentProgram.call("idInvestmentProgram1");
            })
            .then((investmentProgram) => {
                assert.equal("NewHash", investmentProgram[3], "Investment program IpfsHash Updated");
            });
    });

});