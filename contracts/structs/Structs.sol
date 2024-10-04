// SPDX-License-Identifier: MIT
pragma solidity ^0.8.27;

struct StudentInfo {
  address addr;
  string firstName;
  string lastName;
  string midName;
  uint256 dob;
  string photoUrl;
  string additionalInfoUrl;
}

struct SemesterInfo {
  uint256 semesterId;
  uint256 startedAt;
  uint256 finishedAt;
}

struct DonationAmountsSummary {
  address[] tokens;
  uint256[] amounts;
}

struct SponsorInfo {
  address addr;
  string firstName;
  string lastName;
  string midName;
  uint256 dob;
  string photoUrl;
  string additionalInfoUrl;
}