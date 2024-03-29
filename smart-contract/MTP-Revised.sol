// SPDX-License-Identifier: None
pragma solidity 0.8.7;

contract MobileTheftPrevention{
    mapping(bytes32=>bool) private isIMEIexist;
    mapping(bytes32=>bool) private isPhoneNumberexist;
    mapping(address=>mapping(bytes32=>bytes32)) private mapAPI;
    mapping(bytes32=>bool) private isIMEIlost;

    function hash(uint _value) private pure returns(bytes32){
        return keccak256(abi.encodePacked(_value));
    }

    function addIMEI(uint _IMEI, uint _phoneNumber) public{
        require(isIMEIexist[hash(_IMEI)] == false);
        require(isPhoneNumberexist[hash(_phoneNumber)] == false);
        isIMEIexist[hash(_IMEI)] = true;
        isPhoneNumberexist[hash(_phoneNumber)] = true;
        mapAPI[msg.sender][hash(_phoneNumber)] = hash(_IMEI);
    }

    function activateLost(uint _phoneNumber) public{
        require(isIMEIexist[mapAPI[msg.sender][hash(_phoneNumber)]] == true);
        isIMEIlost[mapAPI[msg.sender][hash(_phoneNumber)]] = true;
    }

    function deactivateLost(uint _phoneNumber) public{
        require(isIMEIexist[mapAPI[msg.sender][hash(_phoneNumber)]] == true);
        isIMEIlost[mapAPI[msg.sender][hash(_phoneNumber)]] = false;
    }

    function changeIMEI(uint _IMEI, uint _phoneNumber, uint _newIMEI) public{
        require(isIMEIexist[hash(_IMEI)] == true);
        require(isPhoneNumberexist[hash(_phoneNumber)] == true);
        require(mapAPI[msg.sender][hash(_phoneNumber)] == hash(_IMEI));
        mapAPI[msg.sender][hash(_phoneNumber)] = hash(_newIMEI);
        isIMEIexist[_IMEI] = false;
        if(isIMEIexist[hash(_newIMEI)] == false){
            isIMEIexist[hash(_IMEI)] = true;
        }
    }

    function changePhoneNumber(uint _IMEI, uint _phoneNumber, uint _newPhoneNumber) public{
        require(isIMEIexist[hash(_IMEI)] == true);
        require(isPhoneNumberexist[hash(_phoneNumber)] == true);
        require(mapAPI[msg.sender][hash(_phoneNumber)] == hash(_IMEI));
        mapAPI[msg.sender][hash(_phoneNumber)] = hash(uint(0));
        mapAPI[msg.sender][hash(_newPhoneNumber)] = hash(_IMEI);
        isPhoneNumberexist[_phoneNumber] = false;
    }

    function checkIMEI(uint _IMEI) public view returns(bool){
        return isIMEIlost[hash(_IMEI)];
    }

}
