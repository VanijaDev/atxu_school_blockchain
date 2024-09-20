// SPDX-License-Identifier: MIT
pragma solidity ^0.8.27;

interface ISponsors {
  struct SponsorInfo {
    address addr;
    string firstName;
    string lastName;
    string midName;
    uint256 dob;
    string photoUrl;
    string additionalInfoUrl;
  }

  function totalCount() external returns(uint256);
}
