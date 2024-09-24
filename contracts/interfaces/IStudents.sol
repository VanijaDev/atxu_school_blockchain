// SPDX-License-Identifier: MIT
pragma solidity ^0.8.27;

import { StudentInfo } from "../structs/Structs.sol";

interface IStudents {
  function studentsInfo(address[] memory _addresses) external view returns (StudentInfo[] memory);
  function checkIfLifetimeStudents(address[] memory _addresses) external view returns (bool[] memory);
}
