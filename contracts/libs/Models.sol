pragma solidity ^0.4.13;

library Models {
    
    struct Manager {
        string id;
        string brokerId;
        string login;
        string ipfsHash;
        bool isEntity;
    }

    struct Broker {
        address brokerContract;
        string id;
        string name;
        string host;
    }
}