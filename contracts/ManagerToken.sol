pragma solidity ^0.4.13;

import '../node_modules/zeppelin-solidity/contracts/token/StandardToken.sol';

contract ManagerToken is StandardToken {
    
    // Constants
    string public name;
    string public symbol;
    uint public constant decimals = 18;
    uint256 public startTotalSupply = 1000; 
    address public  gvPlatform;

    modifier gvPlatformOnly() {
        require(msg.sender == gvPlatform);
        _;
    }

    // Constructor
    function ManagerToken(address _gvPlatform, string tokenName, string tokenSymbol) public{
        require(_gvPlatform != 0);
        gvPlatform = _gvPlatform;
        name = tokenName;
        symbol = tokenSymbol;
        totalSupply = startTotalSupply;
        balances[gvPlatform] = startTotalSupply;
    }

    function raiseLimit(uint256 tokenCount) public gvPlatformOnly() {
        totalSupply += tokenCount;
        balances[gvPlatform] += tokenCount;
    }

    function setStartTotalSupply(uint256 newStartTotalSupple) public gvPlatformOnly() {
        startTotalSupply = newStartTotalSupple;
    }

}