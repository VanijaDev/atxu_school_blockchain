// SPDX-License-Identifier: MIT
pragma solidity ^0.8.27;

import "../interfaces/IStudents.sol";
import { IStudents, StudentInfo } from "../interfaces/IStudents.sol";
import { ZeroAddress, InvalidStudentInfo, InvalidStartIndexOrLength } from "../errors/Errors.sol";

// Uncomment this line to use console.log
// import "hardhat/console.sol";

contract Students is IStudents {
  function studentsInfo(address[] memory _addresses) external returns (StudentInfo[] memory) {
    // TODO: implement
  }

  function checkIfLifetimeStudents(address[] memory _addresses) external returns (bool[] memory) {
    // TODO: implement
  }
}
