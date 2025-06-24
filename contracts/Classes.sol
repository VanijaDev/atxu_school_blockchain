// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import { ENCODING_SEPARATOR } from "./misc/Constants.sol";
import { BaseContract } from "./misc/BaseContract.sol";

import { ISchool } from "./interfaces/ISchool.sol";
import { IStudents } from "./interfaces/IStudents.sol";
import { IClasses } from "./interfaces/IClasses.sol";

contract Classes is BaseContract, IClasses {
  struct Class {
    bytes32 id; // encoded name & year, aka 1a-2025
    uint256 classCount;
    uint256 startDate; // timestamp
    uint256 endDate; // timestamp
    string name;
    address[] students;
  }

  uint256 public classCount;

  mapping(bytes32 => Class) private classes; // classId => Class

  error EmptyClassName();
  error WrongStartDate(uint256 startDate);
  error ClassAlreadyExists(string className, uint256 year);
  error NoClassForNameAndYear(string className, uint256 year);
  error SenderNotStudentsContract(address addr);
  error NonStudentAddressInStudents();

  constructor(address _school) BaseContract(_school) { }
  

  /**
    EXTERNAL FUNCTIONS
   */

  function classByNameAndYear(
    string memory _className,
    uint256 _classYear
  ) external view returns (Class memory) {
    bytes32 classId = classIdByNameAndYear(_className, _classYear);
    return classes[classId];
  }

  function addClass(
    string memory _className,
    uint256 _classYear,
    uint256 _startDate
  ) external onlyOwner {
    require(bytes(_className).length > 0, EmptyClassName());
    require(_startDate == 0 || _startDate  > block.timestamp, WrongStartDate(_startDate));

    bytes32 classId = classIdByNameAndYear(_className, _classYear);
    require(classes[classId].startDate == 0, ClassAlreadyExists(_className, _classYear));

    classes[classId] = Class({
      id: classId,
      classCount: classCount,
      startDate: _startDate,
      endDate: 0,
      name: _className,
      students: new address[](0)
    });

    classCount++;
  }

  function enrollStudentsInClass(
    address[] calldata _studentAddresses,
    string memory _className,
    uint256 _classYear
  ) external {
    IStudents studentsContract = IStudents(ISchool(school).studentsContract());
    require(msg.sender == address(studentsContract), SenderNotStudentsContract(address(studentsContract)));

    bytes32 classId = classIdByNameAndYear(_className, _classYear);
    Class storage class = classes[classId];
    require(class.startDate != 0, NoClassForNameAndYear(_className, _classYear));

    // Student addresses validation can be omitted because msg.sender is Students contract

    uint256 len = _studentAddresses.length;
    for (uint256 i = 0; i < len; ++i) {
      class.students.push(_studentAddresses[i]);
    }
  }

  // unenrollStudentFromClass - TODO


  /**
    PUBLIC FUNCTIONS
   */

  function classIdByNameAndYear(
    string memory _className,
    uint256 _classYear
  ) public pure returns (bytes32) {
    return keccak256(abi.encodePacked(_className, ENCODING_SEPARATOR, _classYear));
  }
}
