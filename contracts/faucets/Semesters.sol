// SPDX-License-Identifier: MIT
pragma solidity ^0.8.27;

import { ISemesters, SemesterInfo } from "../interfaces/ISemesters.sol";
import { IStudents } from "../interfaces/IStudents.sol";
import { ISchool } from "../interfaces/ISchool.sol";
import { StudentInfo } from "../structs/Structs.sol";
import { HelperLib } from "../libraries/HelperLib.sol";
import { ZeroAddress, InvalidSemesterDataToStart, InvalidDataForSemesterSearch, InvalidSemester, NotStudent, NotSchool } from "../errors/Errors.sol";
import { WriteBySchoolOnly } from "./WriteBySchoolOnly.sol";

// Uncomment this line to use console.log
// import "hardhat/console.sol";

contract Semesters is ISemesters, WriteBySchoolOnly {
  uint256 public semestersCount;

  mapping(uint256 => SemesterInfo) private _semesterInfo;
  mapping(uint256 => address[]) private _studentsAddressForSemester;
  mapping(address => uint256[]) private _semestersForStudent;
  mapping(address => mapping(uint256 => bool)) private _isStudentForSemester;

  event SemesterStarted(uint256 indexed semesterId, uint256 startedAt);
  event SemesterFinished(uint256 indexed semesterId, uint256 finishedAt);


  /**
   * @dev Constructor.
   * @param _school The address of the School contract.
   */
  constructor(address _school) WriteBySchoolOnly(_school) { }

  /**
   * @dev See {ISemesters-currentSemesterId}.
   */
  function currentSemesterId() external view returns (uint256) {
    return semestersCount - 1;
  }

  /**
   * @dev See {ISemesters-startNextSemester}.
   */
  function startNextSemester(uint256 _startedAt, uint256 _finishedAt) onlySchool external {
    require(_startedAt < _finishedAt, InvalidSemesterDataToStart());
    require(_startedAt > _semesterInfo[semestersCount - 1].finishedAt, InvalidSemesterDataToStart());

    _semesterInfo[semestersCount] = SemesterInfo(semestersCount, _startedAt, _finishedAt);

    emit SemesterStarted(semestersCount, _startedAt);
    
    semestersCount++;
  }

  /**
   * @dev See {ISemesters-finishCurrentSemester}.
   */
  function finishCurrentSemester() onlySchool external {
    _semesterInfo[semestersCount - 1].finishedAt = block.timestamp;

    emit SemesterFinished(semestersCount - 1, block.timestamp);

    // TODO: implement the logic for the end of the semester
  }

  /**
   * @dev See {ISemesters-checkIfStudentsForSemester}.
   */
  function checkIfStudentsForSemester(uint256 _semesterId, address[] memory _addresses) external view returns (bool[] memory) {
    uint256 len = _addresses.length;
    bool[] memory result = new bool[](len);

    for (uint256 i = 0; i < len; ++i) {
      result[i] = _isStudentForSemester[_addresses[i]][_semesterId];
    }

    return result;
  }

  /**
   * @dev See {ISemesters-semestersInfo}.
   */
  function semestersInfo(uint256[] memory _semesterIds) external view returns (SemesterInfo[] memory) {
    uint256 len = _semesterIds.length;
    SemesterInfo[] memory result = new SemesterInfo[](len);

    for (uint256 i = 0; i < len; ++i) {
      result[i] = _semesterInfo[_semesterIds[i]];
    }

    return result;
  }

  /**
   * @dev See {ISemesters-semesterForTimestamp}.
   */
  function semesterForTimestamp(uint256 _timestamp, uint256 _avgSemesterDuration) external view returns (SemesterInfo memory semesterInfo) {
    uint256 approxDuration = block.timestamp - _timestamp;
    uint256 approxSemesterCountPast = approxDuration / _avgSemesterDuration;

    require(approxSemesterCountPast <= semestersCount, InvalidDataForSemesterSearch());

    uint256 approxSemesterIndex = semestersCount - approxSemesterCountPast;
    bool found;
    
    semesterInfo = _semesterInfo[approxSemesterIndex];

    while (!found) {
      if (semesterInfo.startedAt <= _timestamp && semesterInfo.finishedAt >= _timestamp) {
        found = true;
      } else {
        if (semesterInfo.startedAt > _timestamp) {
          approxSemesterIndex--;
        } else {
          approxSemesterIndex++;
        }
      }
    }
  }

  /**
   * @dev See {ISemesters-addStudentsToCurrentSemester}.
   */
  function addStudentsToCurrentSemester(address[] memory _addresses) external {
    _addStudentsToSemester(semestersCount - 1, _addresses);
  }

  /**
   * @dev See {ISemesters-addStudentsToNextSemester}.
   */
  function addStudentsToNextSemester(address[] memory _addresses) external {
    _addStudentsToSemester(semestersCount, _addresses);
  }

  /**
   * @dev Get the count of the students for the semester.
   * @param _semesterId The semester id.
   * @return count The count of the students.
   */
  function studentsCountForSemester(uint256 _semesterId) external view returns (uint256 count) {
    count = _studentsAddressForSemester[_semesterId].length;
  }

  /**
   * @dev Get the students info for the semester.
   * @param _semesterId The semester id
   * @return studentsAddress The students address.
   */
  function studentsAddressForSemester(uint256 _semesterId) external view returns (address[] memory studentsAddress) {
    studentsAddress = _studentsAddressForSemester[_semesterId];
  }

  /**
   * @dev Get the students info for the semester.
   * @param _semesterId The semester id
   * @return studentsInfo The students info.
   */
  function studentsInfoForSemester(uint256 _semesterId) external view returns (StudentInfo[] memory studentsInfo) {
    address[] memory studentsAddress = _studentsAddressForSemester[_semesterId];

    IStudents studentsContract = IStudents(ISchool(school).studentsContract());
    studentsInfo = studentsContract.studentsInfo(studentsAddress);
  }

  /**
   * @dev Get semester count for the student.
   * @param _student The address of the student.
   * @return count The count of the semesters.
   */
  function semesterCountForStudent(address _student) external view returns (uint256 count) {
    count = _semestersForStudent[_student].length;
  }

  /**
   * @dev Get the semesters for the student.
   * @param _student The student address.
   * @return semesters The semesters.
   */
  function semestersForStudent(address _student) external view returns (uint256[] memory semesters) {
    semesters = _semestersForStudent[_student];
  }

  /**
   * @dev Check if the student is in the semester.
   * @param _semesterId The semester id.
   * @param _student The student address.
   * @return isStudent Whether the student is in the semester.
   */
  function isStudentForSemester(uint256 _semesterId, address _student) external view returns (bool isStudent) {
    isStudent = _isStudentForSemester[_student][_semesterId];
  }

  /**
   * @notice The students must be lifetime students in Students contract.
   * @dev Add the students to the semester.
   * @param _semesterId The semester id.
   * @param _students The students address.
   */
  function _addStudentsToSemester(uint256 _semesterId, address[] memory _students) onlySchool private {
    require(_semesterId == semestersCount - 1 || _semesterId == semestersCount, InvalidSemester());

    IStudents studentsContract = IStudents(ISchool(school).studentsContract());
    bool[] memory isLifetimeStudents = studentsContract.checkIfLifetimeStudents(_students);

    uint256 len = _students.length;

    for (uint256 i = 0; i < len; ++i) {
      address student = _students[i];
      require(isLifetimeStudents[i], NotStudent(student));

      _studentsAddressForSemester[_semesterId].push(student);
      _semestersForStudent[student].push(_semesterId);
      _isStudentForSemester[student][_semesterId] = true;
    }
  }
}
