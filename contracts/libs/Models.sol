pragma solidity ^0.4.13;

library Models {
    
    struct InvestmentProgram {
        address token;
        string id;
        string brokerId;
        string ipfsHash;
    }

    struct Broker {
        address brokerContract;
        string id;
        string name;
        string host;
    }
}