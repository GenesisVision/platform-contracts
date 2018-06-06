pragma solidity ^0.4.13;

library Models {
    
    struct InvestmentProgram {
        address token;
        string id;
        string exchangeId;
        string ipfsHash;
        uint level;
    }

    struct Exchange {
        string id;
        string name;
    }
}