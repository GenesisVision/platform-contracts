var ManagerToken = artifacts.require("./ManagerToken.sol");

contract("ManagerToken", function (accounts) {

    var owner = accounts[0];
    var token;

    before('setup', (done) => {
        ManagerToken.deployed().then(function(_token) {
            token = _token
        }).then(() => {
            done();
        });
    });

    it("should raise limit", () => {
        var totalSupply;
        token.totalSupply.call().then((_totalSupply)=>{ totalSupply = _totalSupply; })
        .then(()=> token.raiseLimit(123))
        .then(() => {
            return token.totalSupply.call();
        })
        .then((newTotalSupply) => {
            assert.equal(Number(totalSupply) + 123, Number(newTotalSupply), "limit up");
        });
    });

    it("should set start total supply", () => {
        token.setStartTotalSupply(2000)
        .then(() => {
            return token.startTotalSupply.call();
        })
        .then((newStartTotalSupply) => {
            assert.equal(2000, newStartTotalSupply, "start total supply edit");
        });
    });
});