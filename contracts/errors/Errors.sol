// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

error SenderNotSchool(address sender);
error NotStudent(address addr);
error InvalidStudentInfo();
error StudentIsBlocked(address studentAddress);

error NoClassesForSemester(uint256 semesterId);
error CanntAddClassForSemester(uint256 semesterId);
error TimestampZero();
error AvgSemesterDurationZero();
error TimestampLessThanFirstSemesterStartedAt(uint256 timestamp, uint256 firstSemsterStartedAt);
error InvalidSemesterDiff(uint256 semesterDiff, uint256 semesterCount);
error FailedToFindSemesterId();
error ClassNotFoundForSemester(uint256 classId, uint256 semesterId);

error ZeroAddress();
error StudentNotFoundInClass(address studentAddress, uint256 classId);
error TeacherNotFoundInClass(address teacherAddress, uint256 classId);


// error ZeroAddressForIndexInArray(uint256 index);