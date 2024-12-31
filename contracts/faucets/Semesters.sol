// SPDX-License-Identifier: MIT
pragma solidity 0.8.28;

import { SchoolAsProxy } from "./SchoolAsProxy.sol";
import { SemesterInfo, SemesterInfoToAdd } from "../structs/Structs.sol";
import { CurrentOrNextSemester } from "../enums/Enums.sol";
import { NoClassesForSemester, CanntAddClassForSemester, TimestampZero, AvgSemesterDurationZero, TimestampLessThanFirstSemesterStartedAt, InvalidSemesterDiff, FailedToFindSemesterId, ClassNotFoundForSemester } from "../errors/Errors.sol";
import { SemesterAdded, SemesterStarted, SemesterEnded } from "../events/Events.sol";


/**
 * @title Semesters
 * @author Ivan Solomichev.
 * @dev The contract for managing semesters.
 */
contract Students is SchoolAsProxy {
  uint256 public semesterCount;

  mapping(uint256 => SemesterInfo) public semesterInfoById;

  modifier onlycurrentOrNextSemester(uint256 _semesterId) {
    require(isCurrentOrNextSemester(_semesterId) > CurrentOrNextSemester.None, CanntAddClassForSemester(_semesterId));
    _;
  }

  constructor(address _schoolAddress) SchoolAsProxy(_schoolAddress) {}

  /**
   * @dev Returns the current semester id.
   * @return uint256 The current semester id.
   */
  function currentSemesterId() external view returns (uint256) {
    return semesterCount - 1;
  }

  /**
   * @dev Returns the current semester info.
   * @return SemesterInfo The current semester info.
   */
  function currentSemesterInfo() external view returns (SemesterInfo memory) {
    return semesterInfoById[semesterCount - 1];
  }

  /**
   * @dev creates a semester to the list of semesters.
   * @param _semesterInfo The semester info.
   */
  function createNextSemester(SemesterInfoToAdd calldata _semesterInfo) external onlySchool {
    SemesterInfo storage semesterInfo = semesterInfoById[semesterCount];

    semesterInfo.id = semesterCount;
    semesterInfo.additionalInfo = _semesterInfo.additionalInfo;
    semesterInfo.additionalInfoUrl = _semesterInfo.additionalInfoUrl;

    emit SemesterAdded(semesterInfo.id);

    unchecked {
      ++semesterCount;
    }
  }

  /**
   * @dev Starts the next semester.
   */
  function startNextSemester() external onlySchool {
    SemesterInfo storage semesterInfo = semesterInfoById[semesterCount - 1];

    require(semesterInfo.classIds.length > 0, NoClassesForSemester(semesterCount - 1));

    semesterInfo.startedAt = block.timestamp;

    emit SemesterStarted(semesterInfo.id, semesterInfo.startedAt);
  }

  /**
   * @dev Ends the current semester.
   */
  function endCurrentSemester() external onlySchool {
    SemesterInfo storage semesterInfo = semesterInfoById[semesterCount - 1];

    semesterInfo.endedAt = block.timestamp;

    emit SemesterEnded(semesterInfo.id, semesterInfo.endedAt);

    /**
     * TODO
      * uopdate classes
      * mint certificates
      * else?
     */
  }
  
  /**
   * @dev Adds a class to a semester.
   * @param _semesterId The semester id.
   * @param _classId The class id.
   */
  function addClassToSemester(uint256 _semesterId, uint256 _classId) external onlySchool onlycurrentOrNextSemester(_semesterId) {
    // TODO: add class checks
    semesterInfoById[_semesterId].classIds.push(_classId);
  }

  /**
   * @dev Removes a class from a semester.
   * @param _semesterId The semester id.
   * @param _classId The class id.
   */
  function removeClassFromSemester(uint256 _semesterId, uint256 _classId) external onlySchool onlycurrentOrNextSemester(_semesterId) {
    uint256[] storage classIds = semesterInfoById[_semesterId].classIds;
    uint256 len = classIds.length;

    for (uint256 i = 0; i < len; ) {
      if (classIds[i] == _classId) {
        classIds[i] = classIds[len - 1];
        classIds.pop();
        return;
      }

      unchecked {
        ++i;
      }
    }
    
    revert ClassNotFoundForSemester(_classId, _semesterId);
  }


  /**
   * @dev Returns the semester info for a timestamp.
   * @param _timestamp The timestamp.
   * @param _avgSemesterDuration The average semester duration.
   * @return SemesterInfo The semester info.
   */
  function semesterInfoForTimestamp(uint256 _timestamp, uint256 _avgSemesterDuration) external view returns (SemesterInfo memory) {
    return semesterInfoById[semesterIdForTimestamp(_timestamp, _avgSemesterDuration)];
  }


  /**
   * @dev Returns the semester id for a timestamp.
   * @param _timestamp The timestamp.
   * @param _avgSemesterDuration The average semester duration.
   * @return uint256 The semester id.
   */
  function semesterIdForTimestamp(uint256 _timestamp, uint256 _avgSemesterDuration) public view returns (uint256) {
    require(_timestamp > 0, TimestampZero());
    require(_avgSemesterDuration > 0, AvgSemesterDurationZero());
    require(_timestamp < semesterInfoById[0].startedAt, TimestampLessThanFirstSemesterStartedAt(_timestamp, semesterInfoById[0].startedAt));

    uint256 curTimestamp = block.timestamp;
    if (curTimestamp < _timestamp) {
      return semesterCount - 1;
    }

    uint256 approxSemesterDiff = (curTimestamp - _timestamp) / _avgSemesterDuration;
    require(approxSemesterDiff < semesterCount, InvalidSemesterDiff(approxSemesterDiff, semesterCount));

    uint256 semesterId = semesterCount - approxSemesterDiff;

    while (true) {
      if (semesterInfoById[semesterId].startedAt <= _timestamp) {
        if (semesterInfoById[semesterId].endedAt == 0 || semesterInfoById[semesterId].endedAt >= _timestamp) {
          return semesterId;
        } else {
          semesterId++;
        }
      } else {
        semesterId--;
      }
    }

    revert FailedToFindSemesterId();
  }


  /**
   * @dev Checks if the semester id is the current or next semester.
   * @param _semesterId The semester id.
   * @return _res CurrentOrNextSemester The result.
   */
  function isCurrentOrNextSemester(uint256 _semesterId) private view returns (CurrentOrNextSemester _res) {
    if (_semesterId == semesterCount - 1) {
      return CurrentOrNextSemester.Current;
    } else if (_semesterId == semesterCount) {
      return CurrentOrNextSemester.Next;
    }
  }
}