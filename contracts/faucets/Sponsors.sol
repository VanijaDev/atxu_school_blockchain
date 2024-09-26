// SPDX-License-Identifier: MIT
pragma solidity ^0.8.27;

import { ISponsors } from "../interfaces/ISponsors.sol";
import { ISchool } from "../interfaces/ISchool.sol";
import { SponsorInfo } from "../structs/Structs.sol";
import { ZeroAddress, InvalidStartIndexOrLength, NotSchool, InvalidSponsorDataToAdd } from "../errors/Errors.sol";
import { HelperLib } from "../libraries/HelperLib.sol";

// Uncomment this line to use console.log
// import "hardhat/console.sol";

contract Sponsors is ISponsors {
  ISchool public school;

  address[] private sponsors;
  mapping(address => SponsorInfo) public sponsorInfo;
  mapping(string => address) public sponsorAddressForFullName;

  modifier onlySchool() {
    require(HelperLib._isAddressEqual(msg.sender, address(school)), NotSchool(msg.sender)); // TODO: check deployment cost and gas usage
    _;
  }

  modifier onlyCorrectSponsorData (SponsorInfo calldata _info) {
    require(_onlyCorrectSponsorData(_info), InvalidSponsorDataToAdd());
    _;
  }


  /**
   * @dev Constructor.
   * @param _school The address of the School contract.
   */
  constructor(address _school) {
    require(_school != address(0), ZeroAddress());

    school = ISchool(_school);
  }

  /**
   * @dev See {ISponsors-totalCount}.
   */
  function totalCount() external view returns(uint256 count) {
    count = sponsors.length;
  }

  /**
   * @dev Gets a list of sponsors in the range.
   * @param _startIndex The start index.
   * @param _length The length.
   * @return result The list of sponsors.
   */
  function sponsorsInRange(uint256 _startIndex, uint256 _length) external view returns (address[] memory result) {
    require(_startIndex < sponsors.length, InvalidStartIndexOrLength());
    require(_length > 0, InvalidStartIndexOrLength());
    require(_startIndex + _length <= sponsors.length, InvalidStartIndexOrLength());

    result = new address[](_length);

    for (uint256 i = 0; i < _length; ++i) {
      result[i] = sponsors[_startIndex + i];
    }

    return result;
  }

  /**
   * @dev Add a sponsor to the list of sponsors.
   * @param _info The sponsor info.
   */
  function addSponsor(SponsorInfo calldata _info) onlySchool onlyCorrectSponsorData(_info) external {
    address sponsorAddr = _info.addr;

    sponsors.push(sponsorAddr);
    sponsorInfo[sponsorAddr] = _info;

    string memory fullName = string.concat(_info.firstName, _info.midName, _info.lastName);
    sponsorAddressForFullName[fullName] = sponsorAddr;
  }

  /**
   * @dev Check if the sponsor data is correct.
   * @param _info The sponsor info.
   * @return Whether the sponsor data is correct.
   */
  function _onlyCorrectSponsorData(SponsorInfo calldata _info) internal pure returns (bool) {
    return _info.addr != address(0) && bytes(_info.firstName).length > 0 && bytes(_info.lastName).length > 0 && _info.dob > 0;
    
    /**
     * TODO
     * - compare gas prices with individual if
     * - midName, photoUrl, additionalInfoUrl are optional
     */
  }
}
