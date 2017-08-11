pragma solidity ^0.4.11;

import "./libs/Models.sol";
import "./libs/IterableMap.sol";

contract GenesisVisionPlatform {
    using iManagers for iManagers.iManagerMapping;

    modifier genesisVisionManagerOnly {
        require(msg.sender == genesisVisionManager);
        _;
    }

    uint32[8] tokensPerLevel = [uint32(0), 1000, 9000, 40000, 50000, 100000, 300000, 500000];

    address contractOwner;
    address genesisVisionManager;

    mapping (string => address) brokers;

    iManagers.iManagerMapping managers;

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

    function registerManager(string managerName, string brokerName, uint8 managementFee, uint8 successFee) genesisVisionManagerOnly {        
        require(!managers.contains(managerName));

        managers.insert(managerName, 1, managementFee, successFee);
        managerToBroker[managerName] = brokerName;

        mintManagerTokens(managerName, 1);
    }

    function levelUp (string managerName) internal {
        Models.Manager memory manager = managers.get(managerName);

        manager.level++;
        mintManagerTokens(managerName, manager.level);
    }

    function mintManagerTokens (string managerName, uint8 managerLevel) internal {
        managerFreeTokens[managerName] += tokensPerLevel[managerLevel];
    }

    function() { 
        throw;
    }
}
