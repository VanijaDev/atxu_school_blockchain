// SPDX-License-Identifier: MIT
pragma solidity ^0.8.27;

interface ISponsors {
  /**
   * @dev Gets a count of sponsors.
   * @return count The count of sponsors.
   */
  function totalCount() external view returns(uint256 count);
}
