pragma solidity ^0.4.13;

import "./libs/Models.sol";
import "./ManagerToken.sol";

contract GenesisVisionPlatform {

    address contractOwner;
    address genesisVisionAdmin;

    mapping (string => Models.Broker) brokers;
    mapping (string => Models.InvestmentProgram) investmentPrograms;

    event NewBroker(string brokerId, address brokerContract);
    event NewInvestmentProgram(string investmentProgramId, string brokerId);
    event InvestmentProgramUpdated(string investmentProgramId);
    
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
    
    modifier brokerOrGvAdminByManagerOnly(string investmentProgramId) {
        require(msg.sender == genesisVisionAdmin || msg.sender == contractOwner || brokers[investmentPrograms[investmentProgramId].brokerId].brokerContract == msg.sender);
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
        emit NewBroker(brokerId,brokerContract);
    }

    function createInvestmentProgram(string tokenName, string tokenSymbol, string programId, string brokerId, uint8 managementFee, uint8 successFee) brokerOrGvAdminByBrokerOnly(brokerId) {

        var managerToken = new ManagerToken(this, tokenName, tokenSymbol);
        Models.InvestmentProgram memory program = Models.InvestmentProgram(managerToken, programId, brokerId, "");
        investmentPrograms[programId] = program;
        emit NewInvestmentProgram(programId, brokerId);
    }

    function updateManagerHistoryIpfsHash(string programId, string ipfsHash) brokerOrGvAdminByManagerOnly(programId) {
        investmentPrograms[programId].ipfsHash = ipfsHash;
        emit InvestmentProgramUpdated(programId);
    }

    function getBroker(string brokerId) constant returns (address, string, string, string) {
        return (brokers[brokerId].brokerContract, brokers[brokerId].id, brokers[brokerId].name, brokers[brokerId].host);
    }

    function getManager(string programId) constant returns (string, string, string) {
        return (investmentPrograms[programId].id, investmentPrograms[programId].brokerId, investmentPrograms[programId].ipfsHash);
    }

    function getManagerHistoryIpfsHash(string programId) constant returns (string) {
        return investmentPrograms[programId].ipfsHash;
    }
}