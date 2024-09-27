// SPDX-License-Identifier: MIT
pragma solidity ^0.8.27;

interface ISponsors {
  /**
   * @dev Gets a count of sponsors.
   * @return count The count of sponsors.
   */
  function totalCount() external view returns(uint256 count);

  /**
   * @dev Checks if the address is a sponsor.
   * @param _addr The address to check.
   * @return Whether the address is a sponsor.
   */
  function isSponsor(address _addr) external view returns(bool);

  /**
   * @dev Checks if the address is a sponsor.
   * @param _addr The address to check.
   * @return Whether the address is a sponsor.
   */
  function isSponsors(address[] memory _addr) external view returns(bool[] memory);
}
