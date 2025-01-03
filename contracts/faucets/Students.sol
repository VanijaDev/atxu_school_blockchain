// SPDX-License-Identifier: MIT
pragma solidity 0.8.28;

import { SchoolAsProxy } from "./SchoolAsProxy.sol";
import { StudentInfo, StudentInfoToAdd } from "../structs/Structs.sol";
import { InvalidStudentInfo, NotStudent, StudentIsBlocked, StudentExistsForAddress, StudentExistsForNames, StudentAlreadyAddedToClass } from "../errors/Errors.sol";
import { StudentAdded, StudentInfoUpdated } from "../events/Events.sol";
import { CurrentOrNextSemester } from "../enums/Enums.sol";

/**
 * @title Students
 * @author Ivan Solomichev.
 * @dev The contract for managing students.
 */
contract Students is SchoolAsProxy {
  uint256 public studentCount;

  mapping(bytes32 => uint256) private _studentIdByNames;
  mapping(address => bool) private _isStudentInClass;
  mapping(uint256 => StudentInfo) public studentInfoById;
  mapping(address => uint256) public studentIdByAddress;

  constructor(address _schoolAddress) SchoolAsProxy(_schoolAddress) {}

  modifier onlyLifetimeStudent(address _studentAddress) {
    require(isLifetimeStudent(_studentAddress), NotStudent(_studentAddress));
    _;
  }

  modifier onlyLifetimeStudentAndNotBlocked(address _studentAddress) {
    require(isLifetimeStudentAndNotBlocked(_studentAddress), StudentIsBlocked(_studentAddress));
    _;
  }


  /**
   * @dev Returns the student info by address.
   * @param _studentAddress The student address.
   * @return StudentInfo The student info.
   */
  function studentInfoByAddress(address _studentAddress) external view onlyLifetimeStudent(_studentAddress) returns (StudentInfo memory) {
    return studentInfoById[studentIdByAddress[_studentAddress]];
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


    require(!isLifetimeStudent(_studentInfo.addr), StudentExistsForAddress(_studentInfo.addr));
    (bool present, ) = _isStudentExistsWithNames(_studentInfo.firstName, _studentInfo.midName, _studentInfo.lastName);
    require(!present, StudentExistsForNames(_studentInfo.firstName, _studentInfo.midName, _studentInfo.lastName));

    // TODO: gas optimization
    // studentInfoById[studentCount] = StudentInfo({
    //   blocked: false,
    //   id: studentCount,
    //   dob: _studentInfo.dob,
    //   addr: _studentInfo.addr,
    //   firstName: _studentInfo.firstName,
    //   midName: _studentInfo.midName,
    //   lastName: _studentInfo.lastName,
    //   photoUrl: _studentInfo.photoUrl,
    //   additionalInfo: _studentInfo.additionalInfo,
    //   additionalInfoUrl: _studentInfo.additionalInfoUrl,
    //   parents: _studentInfo.parents,
    //   classes: _studentInfo.classes
    // });

    StudentInfo storage studentInfo = studentInfoById[studentCount];
    studentInfo.id = studentCount;
    studentInfo.dob = _studentInfo.dob;
    studentInfo.addr = _studentInfo.addr;
    studentInfo.firstName = _studentInfo.firstName;
    studentInfo.midName = _studentInfo.midName;
    studentInfo.lastName = _studentInfo.lastName;
    studentInfo.photoUrl = _studentInfo.photoUrl;
    studentInfo.additionalInfo = _studentInfo.additionalInfo;
    studentInfo.additionalInfoUrl = _studentInfo.additionalInfoUrl;
    studentInfo.parents = _studentInfo.parents;

    studentIdByAddress[_studentInfo.addr] = studentCount;

    _studentIdByNames[keccak256(abi.encodePacked(_studentInfo.firstName, _studentInfo.midName, _studentInfo.lastName))] = studentCount;

    emit StudentAdded(_studentInfo.addr, _studentInfo.firstName, _studentInfo.lastName, studentCount);

    unchecked {
      ++studentCount;
    }
  }

  /**
   * @dev Updates student's blocked.
   * @param _studentAddress The student address.
   * @param _blocked Whether the student is blocked.
   */
  function updateStudentBlocked(address _studentAddress, bool _blocked) external onlySchool onlyLifetimeStudent(_studentAddress) {
    studentInfoById[studentIdByAddress[_studentAddress]].blocked = _blocked;

    emit StudentInfoUpdated(_studentAddress);
  }

  /**
   * @dev Updates student's date of birth.
   * @param _studentAddress The student address.
   * @param _dob The date of birth.
   */
  function updateStudentDOB(address _studentAddress, uint256 _dob) external onlySchool onlyLifetimeStudent(_studentAddress) {
    studentInfoById[studentIdByAddress[_studentAddress]].dob = _dob;

    emit StudentInfoUpdated(_studentAddress);
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

    emit StudentInfoUpdated(_studentAddress);
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

    emit StudentInfoUpdated(_studentAddress);
  }

  /**
   * @dev Updates student's photo URL.
   * @param _studentAddress The student address.
   * @param _photoUrl The photo URL.
   */
  function updateStudentPhotoUrl(address _studentAddress, string calldata _photoUrl) external onlySchool onlyLifetimeStudent(_studentAddress) {
    studentInfoById[studentIdByAddress[_studentAddress]].photoUrl = _photoUrl;

    emit StudentInfoUpdated(_studentAddress);
  }

  /**
   * @dev Updates student's additional info.
   * @param _studentAddress The student address.
   * @param _additionalInfo The additional info.
   */
  function updateStudentAdditionalInfo(address _studentAddress, string calldata _additionalInfo) external onlySchool onlyLifetimeStudent(_studentAddress) {
    studentInfoById[studentIdByAddress[_studentAddress]].additionalInfo = _additionalInfo;

    emit StudentInfoUpdated(_studentAddress);
  }

  /**
   * @dev Updates student's additional info URL.
   * @param _studentAddress The student address.
   * @param _additionalInfoUrl The additional info URL.
   */
  function updateStudentAdditionalInfoUrl(address _studentAddress, string calldata _additionalInfoUrl) external onlySchool onlyLifetimeStudent(_studentAddress) {
    studentInfoById[studentIdByAddress[_studentAddress]].additionalInfoUrl = _additionalInfoUrl;

    emit StudentInfoUpdated(_studentAddress);
  }

  /**
   * @dev Updates student's parents.
   * @param _studentAddress The student address.
   * @param _parents The parents.
   */
  function updateStudentParents(address _studentAddress, address[] calldata _parents) external onlySchool onlyLifetimeStudent(_studentAddress) {
    studentInfoById[studentIdByAddress[_studentAddress]].parents = _parents;

    emit StudentInfoUpdated(_studentAddress);
  }

  /**
   * @dev Adds a student to a class.
   * @param _studentAddress The student address.
   * @param _classId The class id.
   */
  function addStudentToClass(address _studentAddress, uint256 _classId) external onlySchool onlyLifetimeStudent(_studentAddress) {
    require(!studentInfoById[studentIdByAddress[_studentAddress]].blocked, StudentIsBlocked(_studentAddress));
    require(!_isStudentInClass[_studentAddress], StudentAlreadyAddedToClass(_studentAddress, _classId));
    
    (bool success, bytes memory data) = address(schoolAddress).delegatecall(abi.encodeWithSignature("semesterIdForClassId(uint256)", _classId));
    require(success, "semesterIdForClassId(uint256) failed");
    uint256 semesterId = abi.decode(data, (uint256));

    (bool success2, bytes memory data2) = address(schoolAddress).delegatecall(abi.encodeWithSignature("isCurrentOrNextSemester(uint256)", semesterId));
    require(success2, "isCurrentOrNextSemester(uint256) failed");
    require(abi.decode(data2, (CurrentOrNextSemester)) > CurrentOrNextSemester.None, "Cannt add to semester (_semesterId)");

    studentInfoById[studentIdByAddress[_studentAddress]].classes.push(_classId);
    _isStudentInClass[_studentAddress] = true;
  }


  /**
   * @dev Checks if the student is a lifetime student.
   * @param _studentAddress The student address.
   * @return bool Whether the student is a lifetime student.
   */
  function isLifetimeStudent(address _studentAddress) public view returns (bool) {
    return studentInfoById[studentIdByAddress[_studentAddress]].addr == _studentAddress;
  }

  /**
   * @dev Checks if the student a lifetime student and not blocked.
   * @param _studentAddress The student address.
   * @return bool Whether the student a lifetime student and not blocked.
   */
  function isLifetimeStudentAndNotBlocked(address _studentAddress) public view returns (bool) {
    return isLifetimeStudent(_studentAddress) && !studentInfoById[studentIdByAddress[_studentAddress]].blocked;
  }


  /**
   * @dev Checks if the student exists with names.
   * @param _firstName The first name.
   * @param _midName The middle name.
   * @param _lastName The last name.
   * @return present Whether the student exists.
   * @return studentId The student id. 0 if not exist.
   */
  function _isStudentExistsWithNames(string memory _firstName, string memory _midName, string memory _lastName) private view returns (bool present, uint256 studentId) {
    bytes32 namesHash = keccak256(abi.encodePacked(_firstName, _midName, _lastName));
    uint256 id = _studentIdByNames[namesHash];

    StudentInfo memory studentInfo = studentInfoById[id];
    bytes32 studentNamesHash = keccak256(abi.encodePacked(studentInfo.firstName, studentInfo.midName, studentInfo.lastName));

    present = namesHash == studentNamesHash;

    if (present) {
      studentId = id;
    }
  }
}
