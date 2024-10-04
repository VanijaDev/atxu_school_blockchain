// SPDX-License-Identifier: MIT
pragma solidity ^0.8.27;

import { ISchool } from "../interfaces/ISchool.sol";
import { NotSchool, InvalidSemesterForDonation } from "../errors/Errors.sol";

library HelperLib {
  /**
   * @dev Checks if the address is equal to another address.
   * @param _addr0 The first address.
   * @param _addr1 The second address.
   * @return isEqual True if the addresses are equal, false otherwise.
   */
  function _isAddressEqual(address _addr0, address _addr1) internal pure returns (bool isEqual) {
    isEqual = _addr0 == _addr1;
  }

  /**
   * 
   * @dev Verifies that the semester ID is valid.
   * @param _school The address of the School contract.
   * @param _semesterId The semester id.
   */
  function verifySemesterId(address _school, uint256 _semesterId) internal view {
    uint256 currentSemesterId = ISchool(_school).currentSemesterId();
    require(_semesterId == currentSemesterId || _semesterId == currentSemesterId + 1, InvalidSemesterForDonation(_semesterId, currentSemesterId));
  }
}