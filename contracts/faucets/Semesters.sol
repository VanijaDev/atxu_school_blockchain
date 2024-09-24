// SPDX-License-Identifier: MIT
pragma solidity ^0.8.27;

import "../interfaces/ISemesters.sol";
import { ISemesters, SemesterInfo } from "../interfaces/ISemesters.sol";
import { ZeroAddress, InvalidSemesterData, InvalidDataForSemester, InvalidSemester, NotStudent } from "../errors/Errors.sol";

// Uncomment this line to use console.log
// import "hardhat/console.sol";

contract Semesters is ISemesters {
  function checkIfStudentsForSemester(uint256 _semesterId, address[] memory _addresses) external returns (bool[] memory) {
    // TODO: implement
  }

  function semestersInfo(uint256[] memory _semesterIds) external returns (SemesterInfo[] memory) {
    // TODO: implement
  }

  function semesterForTimestamp(uint256 _timestamp, uint256 _avgSemesterDuration) external returns (SemesterInfo memory) {
    // TODO: implement
  }
}
