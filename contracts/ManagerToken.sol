pragma solidity ^0.4.13;

import 'zeppelin-solidity/contracts/token/StandardToken.sol';

contract ManagerToken is StandardToken {
    
    // Constants
    string public name;
    string public symbol;
    uint   public constant decimals = 18;
    uint   public tokenLimit; 

    // Constructor
    function ManagerToken(string tokenName, string tokenSymbol, address initialHolder) {
        name = tokenName;
        symbol = tokenSymbol;
        balances[initialHolder] = 1000;
        tokenLimit = 1000;
    }

    function changeLimit(uint newLimit, address holderForNewTokens) {
        var tokens = newLimit - tokenLimit;
        tokenLimit = newLimit;
        balances[holderForNewTokens] = tokens;
    }
}