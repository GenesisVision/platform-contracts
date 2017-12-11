pragma solidity ^0.4.13;

import "./libs/Models.sol";
import 'zeppelin-solidity/contracts/token/StandardToken.sol';
import 'zeppelin-solidity/contracts/math/SafeMath.sol';

contract GenesisVisionPlatform {

    address contractOwner;
    address genesisVisionManager;

    mapping (string => address) brokers;
    mapping (string => Models.Manager) managers;

    event NewBroker(string brokerId);
    event NewManager(string managerId, string brokerId);
    event ManagerUpdated(string managerId);
    
    modifier genesisVisionManagerOnly() {
        require(msg.sender == genesisVisionManager);
        _;
    }

    function GenesisVisionPlatform() {
        contractOwner = msg.sender;
    }

    function setGenesisVisionManager(address manager) {
        require(msg.sender == contractOwner);

        genesisVisionManager = manager;
    }

    function registerBroker (string brokerId, address brokerContract) genesisVisionManagerOnly {
        require(brokers[brokerId] == 0);

        brokers[brokerId] = brokerContract;
        NewBroker(brokerId);
    }

    function registerManager(string managerId, string managerLogin, string brokerId, uint8 managementFee, uint8 successFee) genesisVisionManagerOnly {   
        require(brokers[brokerId] == msg.sender);

        Models.Manager memory manager = Models.Manager(managerId, managerLogin, 1, "");
        managers[managerId] = manager;
        NewManager(managerId, brokerId);
    }

    function getBrokerAddress(string brokerId) genesisVisionManagerOnly constant returns (address) {
        return brokers[brokerId];
    }

    function updateManagerHistoryIpfsHash(string managerId, string ipfsHash) {
        managers[managerId].ipfsHash = ipfsHash;
        ManagerUpdated(managerId);
    }

    function getManagerHistoryIpfsHash(string managerId) constant returns (string) {
        return managers[managerId].ipfsHash;
    }

    function getManagerLogin(string managerId) constant returns (string) {
        return managers[managerId].login;
    }
}