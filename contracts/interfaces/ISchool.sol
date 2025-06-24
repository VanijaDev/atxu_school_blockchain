// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

interface ISchool {
  function studentsContract() external view returns(address);
  function classesContract() external view returns(address);
}