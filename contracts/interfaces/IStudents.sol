// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

/**
 * @title IStudents
 */
interface IStudents {
  /**
   * @dev Sets the address of the Classes contract.
   * @param _classesContract Address of Classes contract
   */
  function setClassesContract(address _classesContract) external;

  /**
   * @dev Checks if all provided addresses are registered students.
   * @param _addresses Array of addresses to validate.
   * @return True if all addresses are students, false otherwise.
   */
  function validateAllAddressesAreStudents(address[] calldata _addresses) external view returns (bool);

  /**
   * @dev Enrolls students into a specific class.
   * @param _studentAddresses List of student addresses to enroll.
   * @param _classId The unique identifier of the class. Aka "1a-2025-2026".
   */
  function enrollStudentsInClass(address[] calldata _studentAddresses, string calldata _classId) external;

  /**
   * @dev Unenrolls students from a specific class.
   * @param _studentAddresses List of student addresses to unenroll.
   * @param _classId The unique identifier of the class. Aka "1a-2025-2026".
   */
  function unenrollStudentsFromClass(address[] calldata _studentAddresses, string calldata _classId) external;
}