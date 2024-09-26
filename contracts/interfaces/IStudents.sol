// SPDX-License-Identifier: MIT
pragma solidity ^0.8.27;

import { StudentInfo } from "../structs/Structs.sol";

interface IStudents {
  /**
   * @dev Get the student info by the address.
   * @param _addresses The addresses of the students.
   * @return The student info.
   */
  function studentsInfo(address[] memory _addresses) external view returns (StudentInfo[] memory);

  /**
   * @dev Check if the students are lifetime students.
   * @param _addresses The addresses of the students.
   * @return Whether the students are lifetime students.
   */
  function checkIfLifetimeStudents(address[] memory _addresses) external view returns (bool[] memory);
}
