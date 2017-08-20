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

    function insert(iAddressUintMapping storage self, address key, uint value) internal {
        entryAddressUint storage e = self.data[key];
        e.value += value;
        if (e.keyIndex == 0) {
            e.keyIndex = ++self.keys.length;
            self.keys[e.keyIndex - 1] = key;
        }
    }

    function size(iAddressUintMapping storage self) internal constant returns (uint) {
        return self.keys.length;
    }

    function getValueByIndex(iAddressUintMapping storage self, uint idx) internal constant returns (uint) {
        return self.data[self.keys[idx]].value;
    }

    function getKeyByIndex(iAddressUintMapping storage self, uint idx) internal constant returns (address) {
        return self.keys[idx];
    }

    function remove(iAddressUintMapping storage self, address key) internal returns (bool success) {
        entryAddressUint storage e = self.data[key];
        if (e.keyIndex == 0)
            return false;

        if (e.keyIndex <= self.keys.length) {
            // Move an existing element into the empty key slot.
            self.data[self.keys[self.keys.length - 1]].keyIndex = e.keyIndex;
            self.keys[e.keyIndex - 1] = self.keys[self.keys.length - 1];
            self.keys.length -= 1;
            delete self.data[key];
            return true;
        }
    }

    function clear(iAddressUintMapping storage self) {
        for (uint i = 0; i < self.keys.length; i++) {
            delete self.data[self.keys[i]];
        }
        self.keys.length = 0;
    }
}