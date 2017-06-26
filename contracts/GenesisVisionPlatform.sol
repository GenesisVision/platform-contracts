pragma solidity ^0.4.10;
contract GenesisVisionPlatform {
    
    modifier genesisVisionManagerOnly {
        require(msg.sender == genesisVisionManager);
        _;
    }

    address contractOwner;
    address genesisVisionManager;

    mapping (string => address) brokers;

    mapping (string => uint8) managerLevels;
    mapping (string => string) managerToBroker;
    mapping (string => uint) managerFreeTokens;
    event NewBroker(string brokerName);
    event NewManager(string managerName, string brokerName);

    function GenesisVisionPlatform() {
        contractOwner = msg.sender;
    }

    function setGenesisVisionManager(address manager) {
        genesisVisionManager = manager;
    }

    function registerBroker (string brokerName, address brokerContract) genesisVisionManagerOnly {
        // TODO check exist
        brokers[brokerName] = brokerContract;
    }

    function registerManager(string managerName, string brokerName) genesisVisionManagerOnly {
        // TODO check exist
        managerLevels[managerName] = 1;
        // TODO check broker exist
        managerToBroker[managerName] = brokerName;

        mintManagerTokens(managerName, 1);
    }

    function mintManagerTokens (string managerName, uint8 managerLevel) genesisVisionManagerOnly {
        // TODO another levels
        managerFreeTokens[managerName] = 1000;
    }

    function() { 
        throw;
    }
}
