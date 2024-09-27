// SPDX-License-Identifier: MIT
pragma solidity ^0.8.27;

import { DonationSummary } from "../structs/Structs.sol";

interface IDonations {
  /**
   * @dev Donates to the semester.
   * @param _donor Donor address.
   * @param _semesterId Semester id.
   * @param _tokenAddr Token address.
   * @param _amount The amount of the donation.
   */
  function donate(address _donor, uint256 _semesterId, address _tokenAddr, uint256 _amount) external;

  /**
   * @dev Checks if the donor donated to the semester.
   * @param _semesterId Semester id.
   * @param _donorAddr Donor address.
   * @return Whether the donor donated to the semester.
   */
  function isDonorDonatedForSemester(uint256 _semesterId, address _donorAddr) external view returns (bool);

  /**
   * @dev Checks if the donor donated the token to the semester.
   * @param _semesterId Semester id.
   * @param _donorAddr Donor address.
   * @param _tokenAddr Token address.
   * @return Whether the donor donated the token to the semester.
   */
  function isDonorDonatedTokenForSemester(uint256 _semesterId, address _donorAddr, address _tokenAddr) external view returns (bool);

  /**
   * @dev Gets the donations summary for the semesters.
   * @param _semesterId The ids of the semesters.
   * @return The donations summary.
   */
  function donationsSummaryForSemesters(uint256[] memory _semesterId) external view returns (DonationSummary[] memory);

  /**
   * @dev Gets the donations summary for the semester for the donor.
   * @param _semesterId Semester id.
   * @param _donorAddr Donor address.
   * @return The donations summary.
   */
  function donationsSummaryForSemestersForDonor(uint256 _semesterId, address _donorAddr) external view returns (DonationSummary[] memory);

  /**
   * @dev Gets the donations summary for the semester for the donors.
   * @param _semesterId Semester id.
   * @param _donorAddr Donor addresses.
   * @return The donations summary.
   */
  function donationsSummaryForSemesterForDonors(uint256 _semesterId, address[] memory _donorAddr) external view returns (DonationSummary[] memory);
}
