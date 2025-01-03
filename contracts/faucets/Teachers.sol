// SPDX-License-Identifier: MIT
pragma solidity 0.8.28;

import { SchoolAsProxy } from "./SchoolAsProxy.sol";
import { TeacherInfo, TeacherInfoToAdd } from "../structs/Structs.sol";
import { InvalidTeacherInfo, NotTeacher, NoTeacherForNames, TeacherExistsForAddress, TeacherExistsForNames, TeacherIsBlocked, AddTeacherToSemesterReverted, TeacherAlreadyAddedForSemester } from "../errors/Errors.sol";
import { TeacherAdded, TeacherInfoUpdated } from "../events/Events.sol";

/**
 * @title Teachers
 * @author Ivan Solomichev.
 * @dev The contract for managing teachers.
 */
contract Teachers is SchoolAsProxy {
  uint256 public teachersCount;

  mapping(bytes32 => uint256) private _teacherIdByNames;
  mapping(address => uint256[]) private _semesterIdsForTeacher;
  mapping(address => mapping(uint256 => uint256[])) private _classIdsForSemesterForTeacher;
  mapping(address => uint256) public teacherIdByAddress;
  mapping(uint256 => TeacherInfo) public teacherInfoById;

  constructor(address _schoolAddress) SchoolAsProxy(_schoolAddress) {}

  modifier onlyLifetimeTeacher(address _teacherAddress) {
    require(isLifetimeTeacher(_teacherAddress), NotTeacher(_teacherAddress));
    _;
  }

  modifier onlyLifetimeTeacherAndNotBlocked(address _teacherAddress) {
    require(isLifetimeTeacherAndNotBlocked(_teacherAddress), TeacherIsBlocked(_teacherAddress));
    _;
  }
  

  /**
   * @dev Returns the teacher info by address.
   * @param _teacherAddress The teacher address.
   * @return TeacherInfo The teacher info.
   */
  function teacherInfoByAddress(address _teacherAddress) external view onlyLifetimeTeacher(_teacherAddress) returns (TeacherInfo memory) {
    return teacherInfoById[teacherIdByAddress[_teacherAddress]];
  }

  /**
   * @dev Returns the semester ids for the teacher.
   * @param _teacherAddress The teacher address.
   * @return uint256[] The semester ids for the teacher.
   */
  function semesterIdsForTeacher(address _teacherAddress) external view returns (uint256[] memory) {
    return _semesterIdsForTeacher[_teacherAddress];
  }

  /**
   * @dev Returns the class ids for the teacher for the semesters.
   * @param _teacherAddress The teacher address.
   * @param _semesterIds The semester ids.
   * @return uint256[][] The class ids for the teacher for the semesters.
   */
  function classIdsForSemestersForTeacher(address _teacherAddress, uint256[] memory _semesterIds) external view returns (uint256[][] memory) {
    uint256 len = _semesterIds.length;
    uint256[][] memory _classIds = new uint256[][](len);

    for (uint256 i = 0; i < len; ) {
      _classIds[i] = _classIdsForSemesterForTeacher[_teacherAddress][_semesterIds[i]];

      unchecked {
        ++i;
      }
    }

    return _classIds;
  }

  /**
   * @dev Returns the teacher id by names.
   * @param _firstName The first name.
   * @param _midName The middle name.
   * @param _lastName The last name.
   * @return uint256 The teacher id.
   */
  function teacherIdByNames(string memory _firstName, string memory _midName, string memory _lastName) external view returns (uint256) {
    (bool present, uint256 id) = _isTeacherExistsWithNames(_firstName, _midName, _lastName);
    require(!present, NoTeacherForNames(_firstName, _midName, _lastName));

    return id;
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

    require(!isLifetimeTeacher(_teacherInfo.addr), TeacherExistsForAddress(_teacherInfo.addr));
    (bool present, ) = _isTeacherExistsWithNames(_teacherInfo.firstName, _teacherInfo.midName, _teacherInfo.lastName);
    require(!present, TeacherExistsForNames(_teacherInfo.firstName, _teacherInfo.midName, _teacherInfo.lastName));


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
    _teacherIdByNames[keccak256(abi.encodePacked(_teacherInfo.firstName, _teacherInfo.midName, _teacherInfo.lastName))] = teachersCount;

    emit TeacherAdded(_teacherInfo.addr, _teacherInfo.firstName, _teacherInfo.lastName, teachersCount);

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

    uint256 id = teacherIdByAddress[_teacherAddress];
    _teacherIdByNames[keccak256(abi.encodePacked(_firstName, _midName, _lastName))] = id;

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


  /**
   * @dev Checks if the teacher is a lifetime teacher.
   * @param _teacherAddress The teacher address.
   * @return bool Whether the teacher is a lifetime teacher.
   */
  function isLifetimeTeacher(address _teacherAddress) public view returns (bool) {
    return teacherInfoById[teacherIdByAddress[_teacherAddress]].addr == _teacherAddress;
  }

  /**
   * @dev Checks if the teacher is a lifetime teacher and not blocked.
   * @param _teacherAddress The teacher address.
   * @return bool Whether the teacher is a lifetime teacher and not blocked.
   */
  function isLifetimeTeacherAndNotBlocked(address _teacherAddress) public view returns (bool) {
    return isLifetimeTeacher(_teacherAddress) && !teacherInfoById[teacherIdByAddress[_teacherAddress]].blocked;
  }


  function addTeacherToSemester(address _teacherAddress, uint256 _semesterId) public onlySchool onlyLifetimeTeacherAndNotBlocked(_teacherAddress) {
    (bool success, ) = address(this).delegatecall(abi.encodeWithSignature("isCurrentOrNextSemester(uint256)", _semesterId));
    require(success, AddTeacherToSemesterReverted(_semesterId, _teacherAddress));

    uint256[] storage semestersForTeacher = _semesterIdsForTeacher[_teacherAddress];
    uint256 semestersCount = semestersForTeacher.length;

    for (uint256 i = 0; i < 2;) {
      require(_semesterId != semestersForTeacher[semestersCount - 1 - i], TeacherAlreadyAddedForSemester(_teacherAddress, _semesterId));

      unchecked {
        ++i;
      }
    }

    semestersForTeacher.push(_semesterId);
  }


  /**
   * @dev Checks if the teacher exists with names.
   * @param _firstName The first name.
   * @param _midName The middle name.
   * @param _lastName The last name.
   * @return present Whether the teacher iexists.
   * @return teacherId The teacher id. 0 if not exist.
   */
  function _isTeacherExistsWithNames(string memory _firstName, string memory _midName, string memory _lastName) private view returns (bool present, uint256 teacherId) {
    bytes32 namesHash = keccak256(abi.encodePacked(_firstName, _midName, _lastName));
    uint256 id = _teacherIdByNames[namesHash];

    TeacherInfo memory teacherInfo = teacherInfoById[id];
    bytes32 teacherNamesHash = keccak256(abi.encodePacked(teacherInfo.firstName, teacherInfo.midName, teacherInfo.lastName));

    present = namesHash == teacherNamesHash;

    if (present) {
      teacherId = id;
    }
  }
}
