// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

event StudentAdded(address indexed studentAddress, uint256 indexed studentId);
event StudentInfoUpdated(address indexed studentAddress);

event TeacherAdded(address indexed teacherAddress, uint256 indexed teacherId);
event TeacherInfoUpdated(address indexed teacherAddress);

event SemesterAdded(uint256 indexed semesterId);
event SemesterStarted(uint256 indexed semesterId, uint256 indexed startedAt);
event SemesterEnded(uint256 indexed semesterId, uint256 indexed endedAt);