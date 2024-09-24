// SPDX-License-Identifier: MIT
pragma solidity ^0.8.27;

import { StudentInfo } from "../structs/Structs.sol";

  function studentsInfo(address[] memory _addresses) external returns (StudentInfo[] memory);
  function checkIfLifetimeStudents(address[] memory _addresses) external returns (bool[] memory);
}
