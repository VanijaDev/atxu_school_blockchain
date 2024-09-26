// SPDX-License-Identifier: MIT
pragma solidity ^0.8.27;

import { SemesterInfo } from "../structs/Structs.sol";

interface ISemesters {
  /**
   * @dev Starts the next semester.
   * @param _startedAt The start date of the semester.
   * @param _finishedAt The finish date of the semester.
   */
  function startNextSemester(uint256 _startedAt, uint256 _finishedAt) external;
  
  /**
   * @dev Finishes the current semester.
   */
  function finishCurrentSemester() external;

  /**
   * @dev Checks if students are in the semester.
   * @param _semesterId Semester id.
   * @param _addresses The addresses of the students.
   * @return Whether the students were studying during the semester.
   */
  function checkIfStudentsForSemester(uint256 _semesterId, address[] memory _addresses) external view returns (bool[] memory);

  /**
   * @dev Get the semesters info by the id.
   * @param _semesterIds The ids of the semesters.
   * @return The semesters info.
   */
  function semestersInfo(uint256[] memory _semesterIds) external view returns (SemesterInfo[] memory);

  /**
   * @dev Get the semester for the timestamp.
   * @param _timestamp The timestamp.
   * @param _avgSemesterDuration The average duration of the semester.
   * @return semesterInfo The semester info.
   */
  function semesterForTimestamp(uint256 _timestamp, uint256 _avgSemesterDuration) external view returns (SemesterInfo memory);

  /**
   * @dev Add the students to the current semester.
   * @param _addresses The students address.
   */
  function addStudentsToCurrentSemester(address[] memory _addresses) external;

  /**
   * @dev Add the students to the next semester.
   * @param _addresses The students address.
   */
  function addStudentsToNextSemester(address[] memory _addresses) external;
}
