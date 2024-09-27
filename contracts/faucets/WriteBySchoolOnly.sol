// SPDX-License-Identifier: MIT

pragma solidity ^0.8.27;

import { HelperLib } from "../libraries/HelperLib.sol";
import { InvalidSchoolAsZero, NotSchool } from "../errors/Errors.sol";

abstract contract WriteBySchoolOnly {
  address public school;

  constructor(address _school) {
    require(_school != address(0), InvalidSchoolAsZero());
    
    school = _school;
  }

  modifier onlySchool() {
    require(HelperLib._isAddressEqual(msg.sender, address(school)), NotSchool(msg.sender)); // TODO: check deployment cost and gas usage
    _;
  }
}