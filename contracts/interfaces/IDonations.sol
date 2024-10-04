// SPDX-License-Identifier: MIT
pragma solidity ^0.8.27;

import { DonationAmountsSummary } from "../structs/Structs.sol";

interface IDonations {
  /**
   * @dev Adds an offline donation record.
   * @param _donor Donor address.
   * @param _semesterId Semester id.
   * @param _tokenAddr Token address.
   * @param _amount The amount of the donation.
   */
  function addDonationOfflineRecord(address _donor, uint256 _semesterId, address _tokenAddr, uint256 _amount) external;

  // /**
  //  * @dev Donates.
  //  * @param _semesterId Semester id.
  //  * @param _tokenAddr Token address.
  //  * @param _amount The amount of the donation.
  //  */
  // function donate(uint256 _semesterId, address _tokenAddr, uint256 _amount) external;

  // /**
  //  * @dev Withdraws the donations.
  //  * @param _tokenAddr Token address.
  //  * @param _to The address to withdraw to.
  //  * @param _amount The amount of the donation.
  //  */
  // function withdrawDonations(address _tokenAddr, address _to, uint256 _amount) external;

  /**
   * @dev Withdraws the donations from this contract.
   * @param _tokenAddr Token address.
   * @param _to The address to withdraw to.
   * @param _amount The amount of the donation.
   */
  function withdrawDonationsFromThisContract(address _tokenAddr, address _to, uint256 _amount) external;

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
   * @dev Gets the donations amounts summaries for the semester.
   * @param _semesterIds Semester ids.
   * @return The donations summary.
   */
  function donationAmountsSummariesForSemesters(uint256[] memory _semesterIds) external view returns (DonationAmountsSummary[] memory);

  /**
   * @dev Gets the donations amounts summaries for the semesters for the donor.
   * @param _semesterIds Semester ids.
   * @param _donorAddr Donor address.
   * @return The donations summary.
   */
  function donationAmountsSummariesForSemestersForDonor(uint256[] memory _semesterIds, address _donorAddr) external view returns (DonationAmountsSummary[] memory);

  /**
   * @dev Gets the donations amounts summaries for the semester for the donors.
   * @param _semesterId Semester id.
   * @param _donorAddr Donor addresses.
   * @return The donations summary.
   */
  function donationAmountsSummariesForSemesterForDonors(uint256 _semesterId, address[] memory _donorAddr) external view returns (DonationAmountsSummary[] memory);
}
