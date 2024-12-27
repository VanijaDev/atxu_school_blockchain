// SPDX-License-Identifier: MIT
pragma solidity 0.8.28;

import { SchoolAsProxy } from "./SchoolAsProxy.sol";
import { StudentInfo, StudentInfoToAdd } from "../structs/Structs.sol";
import { InvalidStudentInfo, NotStudent, StudentIsBlocked } from "../errors/Errors.sol";

contract Students is SchoolAsProxy {
  uint256 public studentsCount;

  mapping(uint256 => StudentInfo) public studentInfoById;
  mapping(address => uint256) public studentIdByAddress;

  constructor(address _schoolAddress) SchoolAsProxy(_schoolAddress) {}

  modifier onlyLifetimeStudent(address _studentAddress) {
    require(_isLifetimeStudent(_studentAddress), NotStudent(_studentAddress));
    _;
  }
  
  /**
   * @dev Checks if the student is a lifetime student.
   * @param _studentAddress The student address.
   * @return bool Whether the student is a lifetime student.
   */
  function isLifetimeStudent(address _studentAddress) external view returns (bool) {
    return _isLifetimeStudent(_studentAddress);
  }

  /**
   * @dev Checks if the student is active.
   * @param _studentAddress The student address.
   * @return bool Whether the student is active.
   */
  function isActiveStudent(address _studentAddress) external view returns (bool) {
    return _isLifetimeStudent(_studentAddress) && !studentInfoById[studentIdByAddress[_studentAddress]].blocked;
  }

  /**
   * @dev Add a student to the list of students.
   * @param _studentInfo The student info.
   */
  function addStudent(StudentInfoToAdd calldata _studentInfo) external onlySchool {
    require(_studentInfo.addr != address(0), InvalidStudentInfo());
    require(_studentInfo.dob != 0, InvalidStudentInfo());
    require(bytes(_studentInfo.firstName).length > 0, InvalidStudentInfo());
    require(bytes(_studentInfo.lastName).length > 0, InvalidStudentInfo());

    studentInfoById[studentsCount] = StudentInfo({
      blocked: false,
      id: studentsCount,
      dob: _studentInfo.dob,
      addr: _studentInfo.addr,
      firstName: _studentInfo.firstName,
      midName: _studentInfo.midName,
      lastName: _studentInfo.lastName,
      photoUrl: _studentInfo.photoUrl,
      additionalInfo: _studentInfo.additionalInfo,
      additionalInfoUrl: _studentInfo.additionalInfoUrl,
      parents: _studentInfo.parents,
      classes: _studentInfo.classes
    });

    studentIdByAddress[_studentInfo.addr] = studentsCount;
    studentsCount++;
  }

  /**
   * @dev Updates student's blocked.
   * @param _studentAddress The student address.
   * @param _blocked Whether the student is blocked.
   */
  function updateStudentblocked(address _studentAddress, bool _blocked) external onlySchool onlyLifetimeStudent(_studentAddress) {
    studentInfoById[studentIdByAddress[_studentAddress]].blocked = _blocked;
  }

  function updateStudentDOB(address _studentAddress, uint256 _dob) external onlySchool onlyLifetimeStudent(_studentAddress) {
    studentInfoById[studentIdByAddress[_studentAddress]].dob = _dob;
  }

  /**
   * @dev Updates student's address.
   * @param _studentAddress The current student address.
   * @param _updatedAddress The updated student address.
   */
  function updateStudentAddress(address _studentAddress, address _updatedAddress) external onlySchool onlyLifetimeStudent(_studentAddress) {
    studentInfoById[studentIdByAddress[_studentAddress]].addr = _updatedAddress;
    studentIdByAddress[_updatedAddress] = studentIdByAddress[_studentAddress];
    delete studentIdByAddress[_studentAddress];
  }

  /**
   * @dev Updates student's names.
   * @param _studentAddress The student address.
   * @param _firstName The first name.
   * @param _midName The middle name.
   * @param _lastName The last name.
   */
  function updateStudentNames(address _studentAddress, string calldata _firstName, string calldata _midName, string calldata _lastName) external onlySchool onlyLifetimeStudent(_studentAddress) {
    studentInfoById[studentIdByAddress[_studentAddress]].firstName = _firstName;
    studentInfoById[studentIdByAddress[_studentAddress]].midName = _midName;
    studentInfoById[studentIdByAddress[_studentAddress]].lastName = _lastName;
  }

  /**
   * @dev Updates student's photo URL.
   * @param _studentAddress The student address.
   * @param _photoUrl The photo URL.
   */
  function updateStudentPhotoUrl(address _studentAddress, string calldata _photoUrl) external onlySchool onlyLifetimeStudent(_studentAddress) {
    studentInfoById[studentIdByAddress[_studentAddress]].photoUrl = _photoUrl;
  }

  /**
   * @dev Updates student's additional info.
   * @param _studentAddress The student address.
   * @param _additionalInfo The additional info.
   */
  function updateStudentAdditionalInfo(address _studentAddress, string calldata _additionalInfo) external onlySchool onlyLifetimeStudent(_studentAddress) {
    studentInfoById[studentIdByAddress[_studentAddress]].additionalInfo = _additionalInfo;
  }

  /**
   * @dev Updates student's additional info URL.
   * @param _studentAddress The student address.
   * @param _additionalInfoUrl The additional info URL.
   */
  function updateStudentAdditionalInfoUrl(address _studentAddress, string calldata _additionalInfoUrl) external onlySchool onlyLifetimeStudent(_studentAddress) {
    studentInfoById[studentIdByAddress[_studentAddress]].additionalInfoUrl = _additionalInfoUrl;
  }

  /**
   * @dev Updates student's parents.
   * @param _studentAddress The student address.
   * @param _parents The parents.
   */
  function updateStudentParents(address _studentAddress, address[] calldata _parents) external onlySchool onlyLifetimeStudent(_studentAddress) {
    studentInfoById[studentIdByAddress[_studentAddress]].parents = _parents;
  }

  /**
   * @dev Adds a student to a class.
   * @param _studentAddress The student address.
   * @param _classId The class id.
   */
  function addStudentToClass(address _studentAddress, uint256 _classId) external onlySchool onlyLifetimeStudent(_studentAddress) {
    require(!studentInfoById[studentIdByAddress[_studentAddress]].blocked, StudentIsBlocked(_studentAddress));

    studentInfoById[studentIdByAddress[_studentAddress]].classes.push(_classId);
  }

  /**
   * @dev Checks if the student is a lifetime student.
   * @param _studentAddress The student address.
   * @return bool Whether the student is a lifetime student.
   */
  function _isLifetimeStudent(address _studentAddress) private view returns (bool) {
    return studentInfoById[studentIdByAddress[_studentAddress]].addr == _studentAddress;
  }
}
