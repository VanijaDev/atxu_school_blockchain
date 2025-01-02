// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

error SenderNotSchool(address sender);
error NotStudent(address addr);
error InvalidStudentInfo();
error StudentIsBlocked(address studentAddress);

error NotTeacher(address addr);
error InvalidTeacherInfo();
error TeacherIsBlocked(address teacherAddress);
error ClassIdsForSemesterReverted();

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
error AddTeacherToSemesterReverted(uint256 semesterId, address teacherAddress);
error ClassNameAlreadyExistsForSemester(uint256 semesterId, string className);
error FailedToAddClassToSemester(uint256 semesterId, string className);


// error ZeroAddressForIndexInArray(uint256 index);