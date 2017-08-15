pragma solidity ^0.4.11;

import "./libs/IMap.sol";
import "./libs/Models.sol";
import "./libs/IMapModels.sol";
import 'zeppelin-solidity/contracts/token/StandardToken.sol';

contract GenesisVisionPlatform {
    using IMapModels for IMapModels.iManagerMapping;

    modifier genesisVisionManagerOnly {
        require(msg.sender == genesisVisionManager);
        _;
    }

    uint32[8] tokensPerLevel = [uint32(0), 1000, 9000, 40000, 50000, 100000, 300000, 500000];

    address contractOwner;
    address genesisVisionManager;

    mapping (string => address) brokers;
    IMapModels.iManagerMapping managers;
    mapping (string => string) managerToBroker;
    IMap.iAddressUintMapping investorsManagers;    

    StandardToken gvt;

    event NewBroker(string brokerName);
    event NewManager(string managerName, string brokerName);

    function GenesisVisionPlatform(address _gvt) {
        contractOwner = msg.sender;
        gvt = StandardToken(_gvt);
    }

    function setGenesisVisionManager(address manager) {
        require(msg.sender == contractOwner);
        genesisVisionManager = manager;
    }

    function registerBroker (string brokerName, address brokerContract) genesisVisionManagerOnly {
        require(brokers[brokerName] == 0);

        brokers[brokerName] = brokerContract;
    }

    function getBrokerAddress(string brokerName) genesisVisionManagerOnly returns (address) {
        return brokers[brokerName];
    }

    function registerManager(string managerName, string brokerName, uint8 managementFee, uint8 successFee) genesisVisionManagerOnly {        
        require(!managers.contains(managerName));
        require(brokers[brokerName] != 0);

        managers.insert(managerName, 1, managementFee, successFee);
        managerToBroker[managerName] = brokerName;
        
        mintManagerTokens(managerName, 1);
    }

    function getManager(uint idx) genesisVisionManagerOnly returns (string, uint8, uint32) {
        uint arraySize = managers.size();

        if (idx >= arraySize) {
            idx = arraySize - 1;
        }
        
        Models.Manager memory manager = managers.getValueByIndex(idx);

        return (manager.name, manager.level, manager.freeCoins);
    }

    function levelUp (string managerName) internal {
        Models.Manager memory manager = managers.get(managerName);

        manager.level++;
        mintManagerTokens(managerName, manager.level);
    }

    function mintManagerTokens (string managerName, uint8 managerLevel) internal {
        managers.data[managerName].freeCoins += tokensPerLevel[managerLevel];
    }

    function invest (string managerName, uint amount) {
        require(managers.contains(managerName));

        if (gvt.transferFrom(msg.sender, this, amount)) {
            managers.data[managerName].pendingCoins.insert(msg.sender, amount);
        }
    }

    function() { 
        throw;
    }
}
