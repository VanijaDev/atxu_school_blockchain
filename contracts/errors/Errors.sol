// SPDX-License-Identifier: MIT
pragma solidity ^0.8.27;

  error InvalidSchoolAsZero();
  error CallToSchoolFailed();
  error NotSchool(address caller);

  error ZeroAddress();
  error InvalidStudentInfo();
  error InvalidStartIndexOrLength();

  error InvalidSemester();
  error InvalidSemesterDataToStart();
  error InvalidSemesterDataToFinish(uint256 semesterId, uint256 startedAt, uint256 finishingAt);
  error InvalidDataForSemesterSearch();
  error NotStudent(address addr);

  error InvalidSponsorDataToAdd();
  error InvalidSemesterForDonation(uint256 semesterId, uint256 currentSemesterId);
  error DonorAddressZero();
  error DonationAmountZero();