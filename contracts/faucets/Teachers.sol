// SPDX-License-Identifier: MIT
pragma solidity 0.8.28;

import { SchoolAsProxy } from "./SchoolAsProxy.sol";
import { TeacherInfo, TeacherInfoToAdd } from "../structs/Structs.sol";
import { InvalidTeacherInfo, NotTeacher, TeacherIsBlocked, AddTeacherToSemesterReverted } from "../errors/Errors.sol";
import { TeacherAdded, TeacherInfoUpdated } from "../events/Events.sol";

/**
 * @title Teachers
 * @author Ivan Solomichev.
 * @dev The contract for managing teachers.
 */
contract Teachers is SchoolAsProxy {
  uint256 public teachersCount;

  mapping(uint256 => TeacherInfo) public teacherInfoById;
  mapping(address => uint256) public teacherIdByAddress;
  mapping(address => uint256[]) private semestersForTeacher;
  mapping(address => mapping(uint256 => uint256)) private classeesForSemesterForTeacher;

  constructor(address _schoolAddress) SchoolAsProxy(_schoolAddress) {}

  modifier onlyLifetimeTeacher(address _teacherAddress) {
    require(_isLifetimeTeacher(_teacherAddress), NotTeacher(_teacherAddress));
    _;
  }

  modifier onlyTeacherPresentAndNotBlocked(address _teacherAddress) {
    require(isTeacherPresentAndNotBlocked(_teacherAddress), TeacherIsBlocked(_teacherAddress));
    _;
  }
  
  /**
   * @dev Checks if the teacher is a lifetime teacher.
   * @param _teacherAddress The teacher address.
   * @return bool Whether the teacher is a lifetime teacher.
   */
  function isLifetimeTeacher(address _teacherAddress) external view returns (bool) {
    return _isLifetimeTeacher(_teacherAddress);
  }

  /**
   * @dev Checks if the teacher is present and not blocked.
   * @param _teacherAddress The teacher address.
   * @return bool Whether the teacher is present and blocked.
   */
  function isTeacherPresentAndNotBlocked(address _teacherAddress) external view returns (bool) {
    return _isLifetimeTeacher(_teacherAddress) && !teacherInfoById[teacherIdByAddress[_teacherAddress]].blocked;
  }

  /**
   * @dev Add a teacher to the list of teachers.
   * @param _teacherInfo The teacher info.
   */
  function addTeacher(TeacherInfoToAdd calldata _teacherInfo) external onlySchool {
    require(_teacherInfo.addr != address(0), InvalidTeacherInfo());
    require(_teacherInfo.dob != 0, InvalidTeacherInfo());
    require(bytes(_teacherInfo.firstName).length > 0, InvalidTeacherInfo());
    require(bytes(_teacherInfo.lastName).length > 0, InvalidTeacherInfo());

    // TODO: gas optimization
    // studentInfoById[studentCount] = TeacherInfo({
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

    TeacherInfo storage teacherInfo = teacherInfoById[teachersCount];
    teacherInfo.id = teachersCount;
    teacherInfo.dob = _teacherInfo.dob;
    teacherInfo.addr = _teacherInfo.addr;
    teacherInfo.firstName = _teacherInfo.firstName;
    teacherInfo.midName = _teacherInfo.midName;
    teacherInfo.lastName = _teacherInfo.lastName;
    teacherInfo.photoUrl = _teacherInfo.photoUrl;
    teacherInfo.additionalInfo = _teacherInfo.additionalInfo;
    teacherInfo.additionalInfoUrl = _teacherInfo.additionalInfoUrl;

    teacherIdByAddress[_teacherInfo.addr] = teachersCount;

    emit TeacherAdded(_teacherInfo.addr, teachersCount);

    unchecked {
      ++teachersCount;
    }
  }

  /**
   * @dev Updates teacher's blocked.
   * @param _teacherAddress The teacher address.
   * @param _blocked Whether the teacher is blocked.
   */
  function updateTeacherBlocked(address _teacherAddress, bool _blocked) external onlySchool onlyLifetimeTeacher(_teacherAddress) {
    teacherInfoById[teacherIdByAddress[_teacherAddress]].blocked = _blocked;

    emit TeacherInfoUpdated(_teacherAddress);
  }

  /**
   * @dev Updates teacher's date of birth.
   * @param _teacherAddress The teacher address.
   * @param _dob The date of birth.
   */
  function updateTeacherDOB(address _teacherAddress, uint256 _dob) external onlySchool onlyLifetimeTeacher(_teacherAddress) {
    teacherInfoById[teacherIdByAddress[_teacherAddress]].dob = _dob;

    emit TeacherInfoUpdated(_teacherAddress);
  }

  /**
   * @dev Updates teacher's address.
   * @param _teacherAddress The current teacher address.
   * @param _updatedAddress The updated teacher address.
   */
  function updateTeacherAddress(address _teacherAddress, address _updatedAddress) external onlySchool onlyLifetimeTeacher(_teacherAddress) {
    teacherInfoById[teacherIdByAddress[_teacherAddress]].addr = _updatedAddress;
    teacherIdByAddress[_updatedAddress] = teacherIdByAddress[_teacherAddress];
    delete teacherIdByAddress[_teacherAddress];

    emit TeacherInfoUpdated(_teacherAddress);
  }

  /**
   * @dev Updates teacher's names.
   * @param _teacherAddress The teacher address.
   * @param _firstName The first name.
   * @param _midName The middle name.
   * @param _lastName The last name.
   */
  function updateTeacherNames(address _teacherAddress, string calldata _firstName, string calldata _midName, string calldata _lastName) external onlySchool onlyLifetimeTeacher(_teacherAddress) {
    teacherInfoById[teacherIdByAddress[_teacherAddress]].firstName = _firstName;
    teacherInfoById[teacherIdByAddress[_teacherAddress]].midName = _midName;
    teacherInfoById[teacherIdByAddress[_teacherAddress]].lastName = _lastName;

    emit TeacherInfoUpdated(_teacherAddress);
  }

  /**
   * @dev Updates teacher's photo URL.
   * @param _teacherAddress The teacher address.
   * @param _photoUrl The photo URL.
   */
  function updateTeacherPhotoUrl(address _teacherAddress, string calldata _photoUrl) external onlySchool onlyLifetimeTeacher(_teacherAddress) {
    teacherInfoById[teacherIdByAddress[_teacherAddress]].photoUrl = _photoUrl;

    emit TeacherInfoUpdated(_teacherAddress);
  }

  /**
   * @dev Updates teacher's additional info.
   * @param _teacherAddress The teacher address.
   * @param _additionalInfo The additional info.
   */
  function updateTeacherAdditionalInfo(address _teacherAddress, string calldata _additionalInfo) external onlySchool onlyLifetimeTeacher(_teacherAddress) {
    teacherInfoById[teacherIdByAddress[_teacherAddress]].additionalInfo = _additionalInfo;

    emit TeacherInfoUpdated(_teacherAddress);
  }

  /**
   * @dev Updates teacher's additional info URL.
   * @param _teacherAddress The teacher address.
   * @param _additionalInfoUrl The additional info URL.
   */
  function updateTeacherAdditionalInfoUrl(address _teacherAddress, string calldata _additionalInfoUrl) external onlySchool onlyLifetimeTeacher(_teacherAddress) {
    teacherInfoById[teacherIdByAddress[_teacherAddress]].additionalInfoUrl = _additionalInfoUrl;

    emit TeacherInfoUpdated(_teacherAddress);
  }

  function addTeacherToSemester(address _teacherAddress, uint256 _semesterId) public onlySchool onlyTeacherPresentAndNotBlocked(_teacherAddress) {
    (bool success, bytes memory data) = address(this).delegatecall(abi.encodeWithSignature("isCurrentOrNextSemester(uint256)", _semesterId));
    require(success, AddTeacherToSemesterReverted(_semesterId, _teacherAddress));

    semestersForTeacher[_teacherAddress].push(_semesterId);
  }

  /**
   * @dev Checks if the teacher is present and not blocked.
   * @param _teacherAddress The teacher address.
   * @return bool Whether the teacher is present and not blocked.
   */
  function isTeacherPresentAndNotBlocked(address _teacherAddress) public view returns (bool) {
    return _isLifetimeTeacher(_teacherAddress) && !teacherInfoById[teacherIdByAddress[_teacherAddress]].blocked;
  }


  /**
   * @dev Checks if the teacher is a lifetime teacher.
   * @param _teacherAddress The teacher address.
   * @return bool Whether the teacher is a lifetime teacher.
   */
  function _isLifetimeTeacher(address _teacherAddress) private view returns (bool) {
    return teacherInfoById[teacherIdByAddress[_teacherAddress]].addr == _teacherAddress;
  }
}
