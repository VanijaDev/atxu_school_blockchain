// SPDX-License-Identifier: MIT
pragma solidity 0.8.28;

import { SenderNotSchool } from "../errors/Errors.sol";

abstract contract SchoolAsProxy {
  modifier onlySchool {
    require(msg.sender == schoolAddress, SenderNotSchool(msg.sender));
    _;
  }

  address public schoolAddress;
  
  constructor(address _schoolAddress) {
    schoolAddress = _schoolAddress;
  }
}