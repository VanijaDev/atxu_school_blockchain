// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import { Ownable } from "@openzeppelin/contracts/access/Ownable.sol";
import { ISchool } from "../interfaces/ISchool.sol";

abstract contract BaseContract is Ownable {
  ISchool public school;

  error ZeroAddressForSchool();

  constructor(address _school) Ownable(_school) {
    require(_school != address(0), ZeroAddressForSchool());

    school = ISchool(_school);
  }
}