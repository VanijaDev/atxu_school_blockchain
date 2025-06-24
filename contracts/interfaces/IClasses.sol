// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

interface IClasses {
  function classIdByNameAndYear(string memory _className, uint256 _classYear) external pure returns (bytes32);
  function enrollStudentsInClass(address[] calldata _studentAddresses, string memory _className, uint256 _classYear) external;
}