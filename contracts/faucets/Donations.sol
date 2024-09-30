// SPDX-License-Identifier: MIT
pragma solidity ^0.8.27;

import { IDonations } from "../interfaces/IDonations.sol";
import { ISchool } from "../interfaces/ISchool.sol";
import { DonationSummary } from "../structs/Structs.sol";
import { NATIVE_TOKEN_DONATION_ADDRESS } from "../constants/Constants.sol";
import { HelperLib } from "../libraries/HelperLib.sol";
import { NotSchool, CallToSchoolFailed, InvalidSemesterForDonation, DonorAddressZero, DonationAmountZero } from "../errors/Errors.sol";
import { WriteBySchoolOnly } from "./WriteBySchoolOnly.sol";

// Uncomment this line to use console.log
// import "hardhat/console.sol";

contract Donations is IDonations, WriteBySchoolOnly {
  address public immutable CASH_DONATION_ADDRESS;

  uint256 public totalCount;

  mapping(uint256 => mapping(address => address[])) private tokensDonatedForSemesterByDonor; // semesterId => donorAddr => tokenAddr[]
  mapping(uint256 => mapping(address => mapping(address => uint256))) private amountDonatedForSemesterByDonorByToken; // semesterId => donorAddr => tokenAddr => amount
  mapping(uint256 => address[]) private donorsDonatedForSemester; // semesterId => donorAddr[]
  mapping(address => uint256[]) private semestersDonatedByDonor; // donorAddr => semesterId[]

  event DonationMade(bool isSponsor, address indexed donorAddr, address indexed token, uint256 indexed amount);


  /**
   * @dev Constructor.
   * @param _school The address of the School contract.
   */
  constructor(address _school) WriteBySchoolOnly(_school) {
    CASH_DONATION_ADDRESS = _school;
  }

  /**
   * @dev See {IDonations-addDonationOfflineRecord}.
   */
  function addDonationOfflineRecord(address _donor, uint256 _semesterId, address _tokenAddr, uint256 _amount) external onlySchool {
    require(_donor != address(0), DonorAddressZero());
    require(_amount > 0, DonationAmountZero());

    (bool successCallSemester, bytes memory data) = msg.sender.staticcall(abi.encodeWithSignature("currentSemesterId()"));
    require(successCallSemester, CallToSchoolFailed());
    uint256 currentSemesterId = abi.decode(data, (uint256));
    require(_semesterId == currentSemesterId || _semesterId == currentSemesterId + 1, InvalidSemesterForDonation(_semesterId, currentSemesterId));

    totalCount++;

    if (amountDonatedForSemesterByDonorByToken[_semesterId][_donor][_tokenAddr] == 0) {
      tokensDonatedForSemesterByDonor[_semesterId][_donor].push(_tokenAddr);
      donorsDonatedForSemester[_semesterId].push(_donor);
      semestersDonatedByDonor[_donor].push(_semesterId);
    }

    amountDonatedForSemesterByDonorByToken[_semesterId][_donor][_tokenAddr] += _amount;

    (bool successCallIsSponsor, bytes memory dataIsSponsor) = msg.sender.staticcall(abi.encodeWithSignature("isSponsor(address)", _donor));
    require(successCallIsSponsor, CallToSchoolFailed());
    bool isSponsor = abi.decode(dataIsSponsor, (bool));

    emit DonationMade(isSponsor, _donor, _tokenAddr, _amount);
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
   * 
    struct DonationSummary {
      address[] tokens;
      uint256[] amounts;
    }
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
