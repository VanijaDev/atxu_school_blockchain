// SPDX-License-Identifier: MIT
pragma solidity ^0.8.27;

interface ISchool {
  function studentsContract() external view returns (address);
  function semestersContract() external view returns (address);
  function donationsContract() external view returns (address);
  function sponsorsContract() external view returns (address);
}
