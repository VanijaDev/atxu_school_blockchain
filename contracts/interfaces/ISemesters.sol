// SPDX-License-Identifier: MIT
pragma solidity ^0.8.27;

import { SemesterInfo } from "../structs/Structs.sol";

interface ISemesters {
  function startNextSemester(uint256 _startedAt, uint256 _finishedAt) external;
  function finishCurrentSemester() external;
  function checkIfStudentsForSemester(uint256 _semesterId, address[] memory _addresses) external view returns (bool[] memory);
  function semestersInfo(uint256[] memory _semesterIds) external view returns (SemesterInfo[] memory);
  function semesterForTimestamp(uint256 _timestamp, uint256 _avgSemesterDuration) external view returns (SemesterInfo memory);
  function addStudentsToCurrentSemester(address[] memory _addresses) external;
  function addStudentsToNextSemester(address[] memory _addresses) external;
}
