pragma solidity ^0.4.11;

import "./libs/IMap.sol";
import "./libs/Models.sol";
import "./libs/IMapModels.sol";
import 'zeppelin-solidity/contracts/token/StandardToken.sol';
import 'zeppelin-solidity/contracts/math/SafeMath.sol';

contract GenesisVisionPlatform {
    using IMapModels for IMapModels.iManagerMapping;
    using SafeMath for uint32;
    using IMap for IMap.iAddressUintMapping;

    modifier genesisVisionManagerOnly {
        require(msg.sender == genesisVisionManager);
        _;
    }

    uint32[8] tokensPerLevel = [uint32(0), 1000, 10000, 50000, 100000, 200000, 500000, 1000000];

    address contractOwner;
    address genesisVisionManager;

    mapping (string => address) brokers;
    IMapModels.iManagerMapping managers;
    mapping (string => string) managerToBroker;
    IMap.iAddressUintMapping investorsManagers;    

    uint centsPerGVT = 100;

    StandardToken gvt;

    event NewBroker(string brokerName);
    event NewManager(string managerName, string brokerName);
    event NewInvestments(string managerName, uint amount);

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
        require(brokers[brokerName] == msg.sender);

        managers.insert(managerName, 1, managementFee, successFee);
        managerToBroker[managerName] = brokerName;
        
        mintManagerTokens(managerName, 1);
    }

    function getManager(uint idx) returns (string, uint8, uint32) {
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
        managers.data[managerName].freeCoins += (tokensPerLevel[managerLevel] - tokensPerLevel[managerLevel-1]);
    }

    function invest (string managerName, uint gvtAmount) {
        require(managers.contains(managerName));

        //ToDo not enough spare tokens
        var manager = managers.data[managerName];

        var coins = gvtAmount * centsPerGVT;

        manager.freeCoins.sub(coins);

        if (gvt.transferFrom(msg.sender, this, gvtAmount)) {
            manager.pendingGVT += gvtAmount;
            manager.pendingCoins.insert(coins);
        }
    }

    function finishPeriod(string managerName, uint32 profitCents) {
        require(brokers[managerToBroker[managerName]] == msg.sender);

        var manager = managers.data[managerName];

        // 1. Distrubite profit
        distributeProfit(manager, profitCents);
        // 2. Execute withdrawal requests
        // 3. Execute deposit requets
        executeInvestorRequests(manager);
        // 4. Check for levelup
        
    }

    function distributeProfit(Models.Manager storage manager, uint32 profitCents) internal {
        // ToDo: Calculate commissions
        uint32 investorsCoins = tokensPerLevel[manager.level] - manager.freeCoins;
        uint32 totalCoins = investorsCoins + manager.ownCoins;

        uint32 managerShare = 100 * manager.ownCoins / totalCoins;
        uint32 managerProfit = managerShare * profitCents / 100;
        manager.ownCoins += managerProfit / 100;

        uint32 investorsProfit = profitCents - managerProfit;
        uint investorsProfitInGVT = investorsProfit / centsPerGVT;

        //Get profit from Broker
        require(gvt.transferFrom(msg.sender, this, investorsProfitInGVT));

        for (uint i = 0; i < manager.investorsCoins.size(); i++) {
            address investorAddress = manager.investorsCoins.getKeyByIndex(i);
            uint investorCoins = manager.investorsCoins.getValueByIndex(i);

            uint investorShare = 100 * investorCoins / investorsCoins;
            uint investorProfitGVT = investorShare * investorShare / 100;

            gvt.approve(investorAddress, investorProfitGVT);
        }
    }

    function executeInvestorRequests(Models.Manager storage manager) internal {
        for (uint i = 0; i < manager.pendingCoins.size(); i++) {
            address investorAddress = manager.pendingCoins.getKeyByIndex(i);
            uint investorCoins = manager.pendingCoins.getValueByIndex(i);

            manager.investorsCoins.insert(investorAddress, investorCoins);            
        }

        gvt.approve(brokers[managerToBroker[manager.name]], manager.pendingGVT);
        manager.pandingGVT = 0;
        manager.pendingCoins.clear();

        NewInvestments(manager.name, manager.pendingGVT);
    }

    function() { 
        throw;
    }
}
