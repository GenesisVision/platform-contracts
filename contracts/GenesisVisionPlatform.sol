pragma solidity ^0.4.13;

import "./libs/Models.sol";

contract GenesisVisionPlatform {

    address contractOwner;
    address genesisVisionAdmin;

    mapping (string => Models.Broker) brokers;
    mapping (string => Models.Manager) managers;

    event NewBroker(string brokerId, address brokerContract);
    event NewManager(string managerId, string brokerId);
    event ManagerUpdated(string managerId);
    
    modifier ownerOnly() {
        require(msg.sender == contractOwner);
        _;
    }

    modifier gvAdminOnly() {
        require(msg.sender == genesisVisionAdmin || msg.sender == contractOwner);
        _;
    }
    
    modifier brokerOrGvAdminByBrokerOnly(string brokerId) {
        require(msg.sender == genesisVisionAdmin || msg.sender == contractOwner || brokers[brokerId].brokerContract == msg.sender);
        _;
    }
    
    modifier brokerOrGvAdminByManagerOnly(string managerId) {
        require(msg.sender == genesisVisionAdmin || msg.sender == contractOwner || brokers[managers[managerId].brokerId].brokerContract == msg.sender);
        _;
    }

    function GenesisVisionPlatform() {
        contractOwner = msg.sender;
    }

    function setGenesisVisionAdmin(address admin) ownerOnly {
        genesisVisionAdmin = admin;
    }

    function registerBroker (string brokerId, address brokerContract, string name, string host) gvAdminOnly {
        require(brokers[brokerId].brokerContract == 0);

        Models.Broker memory broker = Models.Broker(brokerContract, brokerId, name, host);
        brokers[brokerId] = broker;
        NewBroker(brokerId,brokerContract);
    }

    function registerManager(string managerId, string managerLogin, string brokerId, uint8 managementFee, uint8 successFee) brokerOrGvAdminByBrokerOnly(brokerId) {
        require(managers[managerId].isEntity == false);

        Models.Manager memory manager = Models.Manager(managerId, brokerId, managerLogin, "", true);
        managers[managerId] = manager;
        NewManager(managerId, brokerId);
    }

    function updateManagerHistoryIpfsHash(string managerId, string ipfsHash) brokerOrGvAdminByManagerOnly(managerId) {
        managers[managerId].ipfsHash = ipfsHash;
        ManagerUpdated(managerId);
    }

    function getBroker(string brokerId) constant returns (address, string, string, string) {
        return (brokers[brokerId].brokerContract, brokers[brokerId].id, brokers[brokerId].name, brokers[brokerId].host);
    }

    function getManager(string managerId) constant returns (string, string, string, string) {
        return (managers[managerId].id, managers[managerId].brokerId, managers[managerId].login, managers[managerId].ipfsHash);
    }

    function getManagerHistoryIpfsHash(string managerId) constant returns (string) {
        return managers[managerId].ipfsHash;
    }
}