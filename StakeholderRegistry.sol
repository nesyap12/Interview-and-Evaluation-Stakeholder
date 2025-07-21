// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract StakeholderRegistry {

    address public owner;

    enum RoleType { Farmer, Mill, Refinery, Government, Exporter, Importer, Manufacturer, Retailer }

    mapping(address => bool) public isRegistered;
    mapping(address => RoleType) public stakeholderRoles;

    event StakeholderRegistered(address stakeholder, RoleType role);

    constructor() {
        owner = msg.sender;
    }

    modifier OnlyAdmin() {
        require(msg.sender == owner, "Only admin can register stakeholders");
        _;
    }

    function registerStakeholder(address stakeholderID, RoleType roleType) public OnlyAdmin {
        require(!isRegistered[stakeholderID], "Stakeholder already exists");
        isRegistered[stakeholderID] = true;
        stakeholderRoles[stakeholderID] = roleType;
        emit StakeholderRegistered(stakeholderID, roleType);
    }

    function getRole(address stakeholderID) public view returns (uint8) {
        require(isRegistered[stakeholderID], "Stakeholder not registered");
        return uint8(stakeholderRoles[stakeholderID]);
    }

    function isRegisteredStakeholder(address stakeholderID) public view returns (bool) {
        return isRegistered[stakeholderID];
    }
}
