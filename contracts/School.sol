// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import { AccessControl } from "@openzeppelin/contracts/access/AccessControl.sol";
import { ISchool } from "./interfaces/ISchool.sol";

// Uncomment this line to use console.log
// import "hardhat/console.sol";

contract School is AccessControl, ISchool {
  bytes32 public constant ADMIN_ROLE = keccak256("ADMIN_ROLE");

  string public name;

  address public studentsContract;
  address public classesContract;

  error EmptyName();
  error ZeroAddressUsed();

  constructor(string memory _name, address _defaultAdmin, address[] memory _admins) {
    require(bytes(_name).length > 0, EmptyName());
    require(_defaultAdmin != address(0), ZeroAddressUsed());
    
    name = _name;

    _grantRole(DEFAULT_ADMIN_ROLE, _defaultAdmin);
    
    for (uint256 i = 0; i < _admins.length; ++i) {
      _grantRole(ADMIN_ROLE, _admins[i]);
    }
  }


  /**
    EXTERNAL FUNCTIONS
   */

  function updateName(string memory _name) external onlyRole(DEFAULT_ADMIN_ROLE) {
    name = _name;
  }

  function setContracts(
    address _studentsContract,
    address _classesContract
  ) external onlyRole(DEFAULT_ADMIN_ROLE) {
    require(_studentsContract != address(0), ZeroAddressUsed());
    require(_classesContract != address(0), ZeroAddressUsed());

    studentsContract = _studentsContract;
    classesContract = _classesContract;
  }



  // function banStudent(bool _ban, address _student) - TODO
}