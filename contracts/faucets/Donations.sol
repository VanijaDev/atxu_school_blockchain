// SPDX-License-Identifier: MIT
pragma solidity ^0.8.27;

import { IDonations } from "../interfaces/IDonations.sol";
import { DonationSummary } from "../structs/Structs.sol";

// Uncomment this line to use console.log
// import "hardhat/console.sol";

contract Donations is IDonations{
  uint256 public totalCount;

  mapping(uint256 => mapping(address => address[])) private tokensDonatedForSemesterByDonor; // semesterId => donorAddr => tokenAddr[]
  mapping(uint256 => mapping(address => mapping(address => uint256))) private amountDonatedForSemesterByDonorByToken; // semesterId => donorAddr => tokenAddr => amount
  mapping(uint256 => address[]) private donorsDonatedForSemester; // semesterId => donorAddr[]
  mapping(address => uint256[]) private semestersDonatedByDonor; // donorAddr => semesterId[]

  event DonationMade(bool isSponsor, address indexed donorAddr, address indexed token, uint256 indexed amount);


  /**
   * @dev See {IDonations-donate}.
   */
  function donate(uint256 _semesterId, address _tokenAddr, uint256 _amount) external {
    
  }

  /**
   * @dev See {IDonations-isDonorDonatedForSemester}.
   */
  function isDonorDonatedForSemester(uint256 _semesterId, address _donorAddr) external view returns (bool) {

  }

  /**
   * @dev See {IDonations-isDonorDonatedTokenForSemester}.
   */
  function isDonorDonatedTokenForSemester(uint256 _semesterId, address _donorAddr, address _tokenAddr) external view returns (bool) {

  }

  /**
   * @dev See {IDonations-donationsSummaryForSemesters}.
   */
  function donationsSummaryForSemesters(uint256[] memory _semesterId) external view returns (DonationSummary[] memory) {

  }

  /**
   * @dev See {IDonations-donationsSummaryForSemestersForDonor}.
   */
  function donationsSummaryForSemestersForDonor(uint256 _semesterId, address _donorAddr) external view returns (DonationSummary[] memory) {

  }

  /**
   * @dev See {IDonations-donationsSummaryForSemesterForDonors}.
   */
  function donationsSummaryForSemesterForDonors(uint256 _semesterId, address[] memory _donorAddr) external view returns (DonationSummary[] memory) {

  }
}
