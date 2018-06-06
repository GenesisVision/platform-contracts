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
            platform.registerExchange("exchange1", "").catch(function(error) { 
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
                investmentProgram[0];
                assert.equal("idInvestmentProgram1", investmentProgram[1], "investment program exist");
            });
    });

    it("should not register investment program with the same id", (done) => {
        platform.createInvestmentProgram("Elshan", "ELS", "idInvestmentProgram1", "exchange1", "ipfsHash").catch(function(error) { 
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

    it("should balance platform in ManagerToken idInvestmentProgram1 == 2000", () => {
        platform.getInvestmentProgram.call("idInvestmentProgram1").then((investmentProgram) => {
            return investmentProgram[0];
         })
        .then((tokenAddress) => {
            return ManagerToken.at(tokenAddress).balanceOf.call(platform.address);
        })
        .then((balance) => {
            assert.equal(2000, Number(balance), "Balance == 2000");
        });
    });

    it("should transfer manager token", () => {
        platform.getInvestmentProgram.call("idInvestmentProgram1").then((investmentProgram) => {
                platform.transferManagerToken("idInvestmentProgram1",accounts[1], 10);
                return investmentProgram[0];
             })
            .then((tokenAddress) => {
                return ManagerToken.at(tokenAddress).balanceOf.call(accounts[1]);
            })
            .then((balance) => {
                assert.equal(10, balance, "Tokens transferred");
            });
    });
});