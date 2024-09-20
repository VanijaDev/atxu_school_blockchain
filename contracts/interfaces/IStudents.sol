// SPDX-License-Identifier: MIT
pragma solidity ^0.8.27;

interface IStudents {

  struct StudentInfo {
    address addr;
    string firstName;
    string lastName;
    string midName;
    uint256 dob;
    string photoUrl;
    string additionalInfoUrl;
  }

  function studentsInfo(address[] memory _addresses) external returns (StudentInfo[] memory);
  function checkIfLifetimeStudents(address[] memory _addresses) external returns (bool[] memory);
}
