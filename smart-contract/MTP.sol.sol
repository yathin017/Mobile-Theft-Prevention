// SPDX-License-Identifier: None
pragma solidity 0.8.7;

contract MobileTheftPrevention{
    mapping(address=>mapping(bytes32=>bytes32)) private mapAPI;
    mapping(bytes32=>bool) private isIMEIlost;
    mapping(bytes32=>bool) private isIMEIexist;

    function addIMEI(uint _IMEI, uint _phoneNumber) public{
        require(isIMEIexist[keccak256(abi.encodePacked(_IMEI))] == false);
        isIMEIexist[keccak256(abi.encodePacked(_IMEI))] = true;
        mapAPI[msg.sender][keccak256(abi.encodePacked(_phoneNumber))] = keccak256(abi.encodePacked(_IMEI));
    }

    function activateLost(uint _phoneNumber) public{
        require(isIMEIexist[mapAPI[msg.sender][keccak256(abi.encodePacked(_phoneNumber))]] == true);
        isIMEIlost[mapAPI[msg.sender][keccak256(abi.encodePacked(_phoneNumber))]] = true;
    }

    function deactivateLost(uint _phoneNumber) public{
        require(isIMEIexist[mapAPI[msg.sender][keccak256(abi.encodePacked(_phoneNumber))]] == true);
        isIMEIlost[mapAPI[msg.sender][keccak256(abi.encodePacked(_phoneNumber))]] = false;
    }

    function changeOwnership(uint _IMEI, uint _phoneNumber, uint _newIMEI) public{
        require(isIMEIexist[keccak256(abi.encodePacked(_IMEI))] == true);
        mapAPI[msg.sender][keccak256(abi.encodePacked(_phoneNumber))] = keccak256(abi.encodePacked(_newIMEI));
        if(isIMEIexist[keccak256(abi.encodePacked(_newIMEI))] == false){
            isIMEIexist[keccak256(abi.encodePacked(_IMEI))] = true;
        }
    }

    function changePhoneNumber(uint _IMEI, uint _phoneNumber, uint _newPhoneNumber) public{
        require(isIMEIexist[keccak256(abi.encodePacked(_IMEI))] == true);
        require(mapAPI[msg.sender][keccak256(abi.encodePacked(_phoneNumber))] == keccak256(abi.encodePacked(_IMEI)));
        mapAPI[msg.sender][keccak256(abi.encodePacked(_phoneNumber))] = keccak256(abi.encodePacked(uint(0)));
        mapAPI[msg.sender][keccak256(abi.encodePacked(_newPhoneNumber))] = keccak256(abi.encodePacked(_IMEI));
    }

    function checkIMEI(uint _IMEI) public view returns(bool){
        return isIMEIlost[keccak256(abi.encodePacked(_IMEI))];
    }

}