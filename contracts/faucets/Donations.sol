// SPDX-License-Identifier: MIT
pragma solidity ^0.8.27;

import { IDonations } from "../interfaces/IDonations.sol";

// Uncomment this line to use console.log
// import "hardhat/console.sol";

contract Donations is IDonations{
  function donate(uint256 _semesterId, address _tokenAddr, uint256 _amount) external {
    // TODO: implement
  }

  function isDonorDonatedForSemester(uint256 _semesterId, address _donorAddr) external returns (bool) {
    // TODO: implement
  }

  function isDonorDonatedTokenForSemester(uint256 _semesterId, address _donorAddr, address _tokenAddr) external returns (bool) {
    // TODO: implement
  }

  function donationSummaryForSemesters(uint256[] memory _semesterId) external returns (DonationSummary[] memory) {
    // TODO: implement
  }

  function donationSummaryForSemestersForDonor(uint256 _semesterId, address _donorAddr) external returns (DonationSummary[] memory) {
    // TODO: implement
  }
  
  function donationSummaryForSemesterForDonors(uint256 _semesterId, address[] memory _donorAddr) external returns (DonationSummary[] memory) {
    // TODO: implement
  }
}
