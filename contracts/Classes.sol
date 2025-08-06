// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import { ENCODING_SEPARATOR } from "./misc/Constants.sol";
import { BaseContract } from "./misc/BaseContract.sol";

import { ISchool } from "./interfaces/ISchool.sol";
import { IStudents } from "./interfaces/IStudents.sol";
import { IClasses } from "./interfaces/IClasses.sol";

contract Classes is BaseContract, IClasses {
  struct Class {
    uint256 classCount;
    uint256 startDate; // timestamp
    uint256 endDate; // timestamp
    string id; // name & year, aka 1a-2025-2026
    address[] students;
  }

  mapping(string => mapping(address => uint256)) private studentIndexInClass; // classId => studentAddress => index in students array

  address public studentsContract;
  uint256 public classCount;

  mapping(string => Class) public classes; // classId => Class

  error ZeroAddress();
  error EmptyClassName();
  error WrongStartDate(uint256 startDate);
  error ClassAlreadyExists(string classId);
  error WrongClass(string classId);
  error WrongSender(address addr);
  error NonStudentAddressInStudents();

  constructor(address _school) BaseContract(_school) { }


  /**
   * interface IClasses
   */

  function setStudentsContract(address _studentsContract) external onlyOwner {
    require(_studentsContract != address(0), ZeroAddress());
    
    studentsContract = _studentsContract;
  }

  function enrollStudentsInClass(address[] calldata _studentAddresses, string memory _classId) external {
    require(msg.sender == studentsContract, WrongSender(studentsContract));

    Class storage class = classes[_classId];
    require(class.startDate != 0 && class.endDate == 0, WrongClass(_classId));

    // Student addresses validation can be omitted because msg.sender is Students contract which must have validated them already

    uint256 len = _studentAddresses.length;

    for (uint256 i = 0; i < len; ++i) {
      class.students.push(_studentAddresses[i]);
    }
  }

  function unenrollStudentsFromClass(address[] calldata _studentAddresses, string calldata _classId) external {
    require(msg.sender == studentsContract, WrongSender(studentsContract));

    Class storage class = classes[_classId];
    require(class.startDate != 0 && class.endDate == 0, WrongClass(_classId));

    uint256 len = _studentAddresses.length;
    for (uint256 i = 0; i < len; ++i) {
      _unenrollStudentFromClass(_studentAddresses[i], class);
    }
  }

  function isClassActive(string calldata _classId) external view returns (bool) {
    Class storage class = classes[_classId];
    return class.startDate > 0 && class.endDate == 0;
  }
  

  /**
    EXTERNAL FUNCTIONS
   */

  /**
   * @dev Checks if a student is enrolled in a specific class.
   * @param _studentAddress The address of the student to check.
   * @param _classId The unique identifier of the class. Aka "1a-2025-2026".
   * @return True if the student is enrolled in the class, false otherwise.
   */
  function isStudentEnrolledInClass(address _studentAddress, string calldata _classId) external view returns (bool) {
    Class storage class = classes[_classId];
    if (class.startDate == 0 || class.students.length == 0) {
      return false;
    }

    uint256 index = studentIndexInClass[_classId][_studentAddress];
    return class.students[index] == _studentAddress;
  }

  function addClass(string memory _classId, uint256 _startDate) external onlyOwner {
    require(bytes(_classId).length > 0, EmptyClassName());
    require(_startDate == 0 || _startDate  > block.timestamp, WrongStartDate(_startDate));
    require(classes[_classId].startDate == 0, ClassAlreadyExists(_classId));

    classes[_classId] = Class({
      classCount: classCount,
      startDate: _startDate,
      endDate: 0,
      id: _classId,
      students: new address[](0)
    });

    classCount++;
  }

  // function startClass(string calldata _classId) external onlyOwner 

  // function finishClass(string calldata _classId) external onlyOwner


  /**
    PRIVATE FUNCTIONS
   */

  /** 
   * @dev Unenrolls a student from a class.
   * @param _studentAddress The address of the student to unenroll.
   * @param _class The class from which the student will be unenrolled.
   */
  function _unenrollStudentFromClass(address _studentAddress, Class storage _class) private {
    uint256 index = studentIndexInClass[_class.id][_studentAddress];
    require(_class.students[index] == _studentAddress, NonStudentAddressInStudents());

    uint256 len = _class.students.length;
    if (index < len - 1) {
      address lastStudent = _class.students[len - 1];
      _class.students[index] = lastStudent;
      studentIndexInClass[_class.id][lastStudent] = index;
    }

    _class.students.pop();
    delete studentIndexInClass[_class.id][_studentAddress];
  }
}
