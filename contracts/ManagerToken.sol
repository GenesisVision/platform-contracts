pragma solidity ^0.4.13;

import 'zeppelin-solidity/contracts/token/StandardToken.sol';

contract ManagerToken is StandardToken {
    
    // Constants
    string public name;
    string public symbol;
    uint   public constant decimals = 18;
    uint   public tokenLimit; 

    address gvPlatform;

    // Constructor
    function ManagerToken(address _gvPlatform, string tokenName, string tokenSymbol) {
        require(gvPlatform != 0);
        gvPlatform = _gvPlatform;
        name = tokenName;
        symbol = tokenSymbol;
        tokenLimit = 1000;
    }

    function changeLimit(uint newLimit) {
        require(newLimit > tokenLimit);
        tokenLimit = newLimit;
    }

    function mint(address holder, uint amount) {
        require(msg.sender == gvPlatform);
        require(totalSupply + amount <= tokenLimit);
        balances[holder] += amount;
    }

}