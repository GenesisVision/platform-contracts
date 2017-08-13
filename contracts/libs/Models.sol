pragma solidity ^0.4.11;

import "./IMap.sol";

library Models {
    struct Manager {
        uint keyIndex;
        string name;
        uint8 level;
        uint8 managementFee;
        uint8 successFee;
        uint32 freeCoins;
        IMap.iAddressUintMapping investorsCoins;
    }
}