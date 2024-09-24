// SPDX-License-Identifier: MIT
pragma solidity ^0.8.27;

import { SemesterInfo } from "../structs/Structs.sol";

  function checkIfStudentsForSemester(uint256 _semesterId, address[] memory _addresses) external returns (bool[] memory);
  function semestersInfo(uint256[] memory _semesterIds) external returns (SemesterInfo[] memory);
  function semesterForTimestamp(uint256 _timestamp, uint256 _avgSemesterDuration) external returns (SemesterInfo memory);
}
