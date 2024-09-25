// SPDX-License-Identifier: MIT
pragma solidity ^0.8.27;

  error ZeroAddress();
  error InvalidStudentInfo();
  error InvalidStartIndexOrLength();

  error InvalidSemester();
  error InvalidSemesterData();
  error InvalidDataForSemester();
  error NotStudent(address addr);

  error NotSchool(address caller);