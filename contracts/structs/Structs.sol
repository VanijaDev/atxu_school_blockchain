// SPDX-License-Identifier: MIT
pragma solidity ^0.8.27;

struct StudentInfo {
  bool blocked;
  uint256 id;
  uint256 dob;
  address addr;
  string firstName;
  string midName;
  string lastName;
  string photoUrl;
  string additionalInfo;
  string additionalInfoUrl;
  address[] parents;
  uint256[] classes;
}

struct StudentInfoToAdd {
  uint256 dob;
  address addr;
  string firstName;
  string midName;
  string lastName;
  string photoUrl;
  string additionalInfo;
  string additionalInfoUrl;
  address[] parents;
}


struct TeacherInfo {
  bool blocked;
  uint256 id;
  uint256 dob;
  address addr;
  string firstName;
  string midName;
  string lastName;
  string photoUrl;
  string additionalInfo;
  string additionalInfoUrl;
}

struct TeacherInfoToAdd {
  uint256 dob;
  address addr;
  string firstName;
  string midName;
  string lastName;
  string photoUrl;
  string additionalInfo;
  string additionalInfoUrl;
}


struct SemesterInfo {
  uint256 id;
  uint256 startedAt;
  uint256 endedAt;
  uint256[] classIds;
  string additionalInfo;
  string additionalInfoUrl;
}

struct SemesterInfoToAdd {
  string additionalInfo;
  string additionalInfoUrl;
}


struct ClassInfo {
  uint256 id;
  uint256 semesterId;
  string name;
  address primaryTeacher;
  address[] teachers;
  address[] students;
  string additionalInfo;
  string additionalInfoUrl;
}

struct ClassInfoToAdd {
  uint256 semesterId;
  string name;
  address primaryTeacher;
  address[] teachers;
  address[] students;
  string additionalInfo;
  string additionalInfoUrl;
}