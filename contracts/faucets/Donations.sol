// SPDX-License-Identifier: MIT
pragma solidity ^0.8.27;

import { IDonations } from "../interfaces/IDonations.sol";
import { ISchool } from "../interfaces/ISchool.sol";
import { DonationAmountsSummary } from "../structs/Structs.sol";
import { NATIVE_TOKEN_DONATION_ADDRESS } from "../constants/Constants.sol";
import { HelperLib } from "../libraries/HelperLib.sol";
import { NotSchool, CallToSchoolFailed, InvalidSemesterForDonation, DonorAddressZero, DonationAmountZero } from "../errors/Errors.sol";
import { WriteBySchoolOnly } from "./WriteBySchoolOnly.sol";
import { IERC20 } from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

// Uncomment this line to use console.log
// import "hardhat/console.sol";

contract Donations is IDonations, WriteBySchoolOnly {
  address public immutable CASH_DONATION_ADDRESS;

  uint256 public totalCount;

  mapping(uint256 => mapping(address => address[])) private tokensDonatedForSemesterByDonor; // semesterId => donorAddr => tokenAddr[]
  mapping(uint256 => mapping(address => mapping(address => uint256))) private amountDonatedForSemesterByDonorByToken; // semesterId => donorAddr => tokenAddr => amount
  mapping(uint256 => address[]) private donorsDonatedForSemester; // semesterId => donorAddr[]
  mapping(address => uint256[]) private semestersDonatedByDonor; // donorAddr => semesterId[]
  mapping(uint256 => address[]) private tokensDonatedForSemester; // semesterId => tokenAddr[]
  mapping(uint256 => mapping(address => uint256)) private amountDonatedForSemesterByToken; // semesterId => tokenAddr => amount

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

    HelperLib.verifySemesterId(school, _semesterId);

    totalCount++;

    if (amountDonatedForSemesterByDonorByToken[_semesterId][_donor][_tokenAddr] == 0) {
      tokensDonatedForSemesterByDonor[_semesterId][_donor].push(_tokenAddr);
      donorsDonatedForSemester[_semesterId].push(_donor);
      semestersDonatedByDonor[_donor].push(_semesterId);
    }
    amountDonatedForSemesterByDonorByToken[_semesterId][_donor][_tokenAddr] += _amount;

    if (amountDonatedForSemesterByToken[_semesterId][_tokenAddr] == 0) {
      tokensDonatedForSemester[_semesterId].push(_tokenAddr);
    }
    amountDonatedForSemesterByToken[_semesterId][_tokenAddr] += _amount;

    (bool successCallIsSponsor, bytes memory dataIsSponsor) = msg.sender.staticcall(abi.encodeWithSignature("isSponsor(address)", _donor));
    require(successCallIsSponsor, CallToSchoolFailed());
    bool isSponsor = abi.decode(dataIsSponsor, (bool));

    emit DonationMade(isSponsor, _donor, _tokenAddr, _amount);
  }

  /**
   * @dev See {IDonations-withdrawDonationsFromThisContract}.
   */
  function withdrawDonationsFromThisContract(address _tokenAddr, address _to, uint256 _amount) external onlySchool {
    if (_tokenAddr == NATIVE_TOKEN_DONATION_ADDRESS) {
      payable(_to).transfer(_amount);
    } else {
      IERC20(_tokenAddr).transfer(_to, _amount);
    }
  }

  /**
   * @dev See {IDonations-isDonorDonatedForSemester}.
   */
  function isDonorDonatedForSemester(uint256 _semesterId, address _donorAddr) external view returns (bool) {
    return tokensDonatedForSemesterByDonor[_semesterId][_donorAddr].length > 0;
  }

  /**
   * @dev See {IDonations-isDonorDonatedTokenForSemester}.
   */
  function isDonorDonatedTokenForSemester(uint256 _semesterId, address _donorAddr, address _tokenAddr) external view returns (bool) {
    return amountDonatedForSemesterByDonorByToken[_semesterId][_donorAddr][_tokenAddr] > 0;
  }

  /**
   * @dev See {IDonations-donationsSummaryForSemesters}.
   */
  function donationAmountsSummariesForSemesters(uint256[] memory _semesterIds) external view returns (DonationAmountsSummary[] memory) {
    DonationAmountsSummary[] memory result = new DonationAmountsSummary[](_semesterIds.length);

    for (uint256 i = 0; i < _semesterIds.length; ++i) {
      uint256 semesterId = _semesterIds[i];
      HelperLib.verifySemesterId(school, semesterId);

      address[] memory tokens = tokensDonatedForSemester[semesterId];
      uint256[] memory amounts = new uint256[](tokens.length);

      for (uint256 j = 0; j < tokens.length; ++j) {
        amounts[j] = amountDonatedForSemesterByToken[semesterId][tokens[j]];
      }

      result[i] = DonationAmountsSummary(tokens, amounts);
    }

    return result;
  }

  /**
   * @dev See {IDonations-donationsSummaryForSemestersForDonor}.
   */
  function donationAmountsSummariesForSemestersForDonor(uint256[] memory _semesterIds, address _donorAddr) external view returns (DonationAmountsSummary[] memory) {
    DonationAmountsSummary[] memory result = new DonationAmountsSummary[](_semesterIds.length);

    for (uint256 i = 0; i < _semesterIds.length; ++i) {
      uint256 semesterId = _semesterIds[i];
      HelperLib.verifySemesterId(school, semesterId);

      address[] memory tokens = tokensDonatedForSemesterByDonor[semesterId][_donorAddr];
      uint256[] memory amounts = new uint256[](tokens.length);

      for (uint256 j = 0; j < tokens.length; ++j) {
        amounts[j] = amountDonatedForSemesterByDonorByToken[semesterId][_donorAddr][tokens[j]];
      }

      result[i] = DonationAmountsSummary(tokens, amounts);
    }

    return result;
  }

  /**
   * @dev See {IDonations-donationsSummaryForSemesterForDonors}.
   */
  function donationAmountsSummariesForSemesterForDonors(uint256 _semesterId, address[] memory _donorAddr) external view returns (DonationAmountsSummary[] memory) {
    HelperLib.verifySemesterId(school, _semesterId);

    DonationAmountsSummary[] memory result = new DonationAmountsSummary[](_donorAddr.length);

    for (uint256 i = 0; i < _donorAddr.length; ++i) {
      address donorAddr = _donorAddr[i];

      address[] memory tokens = tokensDonatedForSemesterByDonor[_semesterId][donorAddr];
      uint256[] memory amounts = new uint256[](tokens.length);

      for (uint256 j = 0; j < tokens.length; ++j) {
        amounts[j] = amountDonatedForSemesterByDonorByToken[_semesterId][donorAddr][tokens[j]];
      }

      result[i] = DonationAmountsSummary(tokens, amounts);
    }

    return result;
  }

  /**
   * @dev Gets the balance for the token.
   * @param _tokenAddr The token address.
   * @return The balance.
   */
  function balanceForToken(address _tokenAddr) external view returns (uint256) {
    if (_tokenAddr == NATIVE_TOKEN_DONATION_ADDRESS) {
      return address(this).balance;
    } else {
      return IERC20(_tokenAddr).balanceOf(address(this));
    }
  }

  // TODO: add read for all private mappings
}
