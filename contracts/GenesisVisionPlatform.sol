pragma solidity ^0.4.13;

import "./libs/Models.sol";
import 'zeppelin-solidity/contracts/token/StandardToken.sol';
import 'zeppelin-solidity/contracts/math/SafeMath.sol';

contract GenesisVisionPlatform {

    modifier genesisVisionManagerOnly {
        require(msg.sender == genesisVisionManager);
        _;
    }

    address contractOwner;
    address genesisVisionManager;

    mapping (string => address) brokers;
    mapping (string => Models.Manager) managers;

    event NewBroker(string brokerName);
    event NewManager(string managerName, string brokerName);
    event ManagerUpdated(string managerName);
    

    function GenesisVisionPlatform() {
        contractOwner = msg.sender;
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
        require(brokers[brokerName] == msg.sender);

        Models.Manager memory manager = Models.Manager(managerName, 1, "");
        managers[managerName] = manager;
    }

    function updateIpfsHash(string managerName, string ipfs) {
        managers[managerName].ipfs = ipfs;
        ManagerUpdated(managerName);
    }

    function() { 
        throw;
    }
}
