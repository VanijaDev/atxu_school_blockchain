// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

/**
 * @title IStudents
 */
interface IStudents {
  /**
   * @dev Checks if all provided addresses are registered students.
   * @param _addresses Array of addresses to validate.
   * @return True if all addresses are students, false otherwise.
   */
  function validateAddressesAreStudents(address[] calldata _addresses) external view returns (bool);

  /**
   * @dev Enrolls multiple students into a specific class.
   * @param _studentAddresses List of student addresses to enroll.
   * @param _name The class name.
   * @param _year The academic year for the class.
   */
  function enrollStudentsInClass(address[] calldata _studentAddresses, string calldata _name, uint256 _year) external;
}