// SPDX-License-Identifier: MIT
pragma solidity ^0.8.27;

struct StudentInfo {
  bool blocked;
  uint256 id;
  uint256 dob;
  address addr;
  string firstName;
  string midName;
  string lastName;
  string photoUrl;
  string additionalInfo;
  string additionalInfoUrl;
  address[] parents;
  uint256[] classes;
}

struct StudentInfoToAdd {
  uint256 dob;
  address addr;
  string firstName;
  string midName;
  string lastName;
  string photoUrl;
  string additionalInfo;
  string additionalInfoUrl;
  address[] parents;
  uint256[] classes;
}