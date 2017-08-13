pragma solidity ^0.4.11;

library IMap {
    struct entryAddressStringArray {
        uint keyIndex;
        string[] value;
    }

    struct iAddressStringArrayMapping {
        mapping(address => entryAddressStringArray) data;
        address[] keys;
    }

    function insert(iAddressStringArrayMapping storage self, address key, string value) internal returns (bool replaced) {
        entryAddressStringArray storage e = self.data[key];
        e.value.push(value);
        if (e.keyIndex > 0) {
            return true;
        } else {
            e.keyIndex = ++self.keys.length;
            self.keys[e.keyIndex - 1] = key;
            return false;
        }
    }

    struct entryAddressUint {
        uint keyIndex;
        uint value;
    }

    struct iAddressUintMapping {
        mapping(address => entryAddressUint) data;
        address[] keys;
    }

    function insert(iAddressUintMapping storage self, address key, uint value) internal returns (bool replaced) {
        entryAddressUint storage e = self.data[key];
        e.value = value;
        if (e.keyIndex > 0) {
            return true;
        } else {
            e.keyIndex = ++self.keys.length;
            self.keys[e.keyIndex - 1] = key;
            return false;
        }
    }
}