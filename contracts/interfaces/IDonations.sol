// SPDX-License-Identifier: MIT
pragma solidity ^0.8.27;

import { DonationSummary } from "../structs/Structs.sol";

interface IDonations {
  event DonationMade(address indexed donorAddr, address indexed token, uint256 indexed amount);

  function donate(uint256 _semesterId, address _tokenAddr, uint256 _amount) external;
  function isDonorDonatedForSemester(uint256 _semesterId, address _donorAddr) external view returns (bool);
  function isDonorDonatedTokenForSemester(uint256 _semesterId, address _donorAddr, address _tokenAddr) external view returns (bool);
  function donationSummaryForSemesters(uint256[] memory _semesterId) external view returns (DonationSummary[] memory);
  function donationSummaryForSemestersForDonor(uint256 _semesterId, address _donorAddr) external view returns (DonationSummary[] memory);
  function donationSummaryForSemesterForDonors(uint256 _semesterId, address[] memory _donorAddr) external view returns (DonationSummary[] memory);
}
