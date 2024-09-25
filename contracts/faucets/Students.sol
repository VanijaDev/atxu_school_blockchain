// SPDX-License-Identifier: MIT
pragma solidity ^0.8.27;

import { IStudents, StudentInfo } from "../interfaces/IStudents.sol";
import { ISchool } from "../interfaces/ISchool.sol";
import { ZeroAddress, InvalidStudentInfo, InvalidStartIndexOrLength, NotSchool } from "../errors/Errors.sol";
import { HelperLib } from "../libraries/HelperLib.sol";

// Uncomment this line to use console.log
// import "hardhat/console.sol";

contract Students is IStudents {
  ISchool public school;
  address[] private _studentsLifetime;
  mapping(string => address) public studentAddressForFullName;
  mapping(address => StudentInfo) private _studentInfo;

  modifier onlyCorrectStudentData (StudentInfo calldata _info) {
    require(_onlyCorrectStudentData(_info), InvalidStudentInfo());
    _;
  }

  modifier onlySchool() {
    require(HelperLib._isAddressEqual(msg.sender, address(school)), NotSchool(msg.sender)); // TODO: check deployment cost and gas usage
    _;
  }


  /**
   * @dev Constructor.
   * @param _school The address of the School contract.
   */
  constructor(address _school) {
    require(_school != address(0), ZeroAddress());

    school = ISchool(_school);
  }

  /**
   * @dev Add a student to the list of students.
   * @param _info The student info.
   */

  function addStudent(StudentInfo calldata _info) onlyCorrectStudentData(_info) onlySchool external {
    address studentAddr = _info.addr;

    _studentsLifetime.push(studentAddr);
    _studentInfo[studentAddr] = _info;

    string memory fullName = string.concat(_info.firstName, _info.midName, _info.lastName);
    studentAddressForFullName[fullName] = studentAddr;
  }


  /**
   * @dev Get the student info by the address.
   * @param _addresses The addresses of the students.
   * @return The student info.
   */
  function studentsInfo(address[] calldata _addresses) external view returns (StudentInfo[] memory) {
    uint256 len = _addresses.length;
    
    StudentInfo[] memory result = new StudentInfo[](len);
    for (uint256 i = 0; i < len; ++i) {
      result[i] = _studentInfo[_addresses[i]];
    }

    return result;
  }

  /**
   * @dev Get the count of the lifetime students.
   * @return The count of students.
   */
  function studentsLifetimeCount() external view returns (uint256) {
    return _studentsLifetime.length;
  }

  /**
   * @dev Get the lifetime students.
   * @param _startIndex The start index.
   * @param _length The length.
   * @return result The addresses of the students.
   */
  function studentsLifetimeInRange(uint256 _startIndex, uint256 _length) external view returns (address[] memory result) {
    require(_startIndex < _studentsLifetime.length, InvalidStartIndexOrLength());
    require(_length > 0, InvalidStartIndexOrLength());
    require(_startIndex + _length <= _studentsLifetime.length, InvalidStartIndexOrLength());

    result = new address[](_length);

    for (uint256 i = 0; i < _length; ++i) {
      result[i] = _studentsLifetime[_startIndex + i];
    }

    return result;
  }

  /**
   * @dev Check if the students are lifetime students.
   * @param _addresses The addresses of the students.
   * @return Whether the students are lifetime students.
   */
  function checkIfLifetimeStudents(address[] calldata _addresses) external view returns (bool[] memory) {
    uint256 len = _addresses.length;
    bool[] memory result = new bool[](len);

    for (uint256 i = 0; i < len; ++i) {
      result[i] = _studentInfo[_addresses[i]].addr != address(0);
    }

    return result;
  }

  // MODIFIER FUNCTIONS
  /**
   * @dev Check if the student data is correct.
   * @param _info The student info.
   * @return Whether the student data is correct.
   */
  function _onlyCorrectStudentData(StudentInfo calldata _info) private pure returns (bool) {
    return _info.addr != address(0) && bytes(_info.firstName).length > 0 && bytes(_info.lastName).length > 0 && _info.dob > 0 && bytes(_info.photoUrl).length > 0;

    /**
     * TODO
     * - compare gas prices with individual if
     * - midName & additionalInfoUrl
     */

    // if (_info.addr != address(0)) {
    //   return false;
    // }

    // if (bytes(_info.firstName).length == 0) {
    //   return false;
    // }

    // if (bytes(_info.lastName).length == 0) {
    //   return false;
    // }

    // if (_info.dob == 0) {
    //   return false;
    // }

    // if (bytes(_info.photoUrl).length == 0) {
    //   return false;
    // }

    // return true;
  }
}
