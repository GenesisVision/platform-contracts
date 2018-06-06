var GenesisVisionPlatform = artifacts.require("./GenesisVisionPlatform.sol");
var ManagerToken = artifacts.require("./ManagerToken.sol");


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
        return platform.registerExchange("exchange1", "asd")
            .then(() => {
                return platform.getExchange.call("exchange1");
            })
            .then((exchange) => {
                assert.equal("exchange1", exchange[0], "Exchange should exist");
            });
    });

    it("should not register Exchange with the same id", (done) => {
            var a =  platform.registerExchange("exchange1", "").catch(function(error) { 
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
    var tokenAddress;
    it("should register investment program", (done) => {
        platform.createInvestmentProgram("Elshan", "ELS", "idInvestmentProgram1", "exchange1", "ipfsHash")
            .then(() => {
                return platform.getInvestmentProgram.call("idInvestmentProgram1");
            })
            .then((investmentProgram) => {
                assert.equal("idInvestmentProgram1", investmentProgram[1], "investment program exist");
                tokenAddress = investmentProgram[0];
                done(tokenAddress);
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

    it("should transfer manager token" + "Address:" + tokenAddress, () => {
        return platform.transferManagerToken("idInvestmentProgram1",address[1], 10)
            .then(() => {
                return ManagerToken.At(tokenAddress).balanceOf.call(address[1]);
            })
            .then((balance) => {
                assert.equal(10, balance, "Tokens transferred");
            });
    });
});