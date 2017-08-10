pragma solidity ^0.4.11;

library iMap {
    struct Manager {
        uint keyIndex;
        string name;
        uint8 level;
        uint8 managementFee;
        uint8 successFee;
    }

    struct iMapManagers {
        mapping(string => Manager) data;
        string[] keys;
    }

    function insert(Manager storage self, string key, uint8 level, uint8 managementFee, uint8 successFee) internal returns (bool replaced) {
        Manager storage e = self.data[key];
        e.name = key;
        e.level = level;
        e.managementFee = managementFee;
        e.successFee = successFee;
        if (e.keyIndex > 0) {
            return true;
        } else {
            e.keyIndex = ++self.keys.length;
            self.keys[e.keyIndex - 1] = key;
            return false;
        }
    }

    function contains(iMapStringAddress storage self, string key) internal constant returns (bool exists) {
        return self.data[key].keyIndex > 0;
    }
}