// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

/**
 * @title IClasses
 */
interface IClasses {
  /**
   * @dev Sets the address of the Students contract.
   * @param _studentsContract Address of Students contract
   */

  function setStudentsContract(address _studentsContract) external;

  /**
   * @dev Enrolls students into a specific class.
   * @param _studentAddresses List of student addresses to enroll.
   * @param _classId The unique identifier of the class. Aka "1a-2025-2026".
   */
  function enrollStudentsInClass(address[] calldata _studentAddresses, string memory _classId) external;

  /**
   * @dev Unenrolls students from a specific class.
   * @param _studentAddresses List of student addresses to unenroll.
   * @param _classId The unique identifier of the class. Aka "1a-2025-2026".
   */
  function unenrollStudentsFromClass(address[] calldata _studentAddresses, string memory _classId) external;

  /**
   * @dev Checks if a class is active.
   * @param _classId The unique identifier of the class. Aka "1a-2025-2026".
   */
  function isClassActive(string calldata _classId) external view returns (bool);
}