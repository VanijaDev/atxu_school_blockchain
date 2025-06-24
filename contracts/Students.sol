// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import { ENCODING_SEPARATOR } from "./misc/Constants.sol";
import { BaseContract } from "./misc/BaseContract.sol";

import { ISchool } from "./interfaces/ISchool.sol";
import { IStudents } from "./interfaces/IStudents.sol";
import { IClasses } from "./interfaces/IClasses.sol";

contract Students is BaseContract, IStudents {
  struct Student {
    address studentAddress;
    bool isBanned;
    uint256 dob;
    string firstName;
    string midName;
    string lastName;
    string additionalInfo;
    address[] parents;
    bytes32[] classesEnrolled;
  }

  mapping(address => Student) private students;
  mapping(bytes32 => address) private studentAddressByFullName;
  mapping(address => address) private studentAddressByParentAddress;

  error EmptyStudentsArray();
  error ZeroAddressStudent();
  error ZeroAddressParent();
  error ClassesContractNotSet();
  error NoStudentForAddress(address studentAddress);
  error CantEnrollAddress(address studentAddress);
  error NoStudentForFullName(string firstName, string midName, string lastName);
  error StudentAlreadyExists(address studentAddress);
  error EmptyFirstName();
  error EmptyLastName();
  error EmptyDOB();
  error EmpttyParents();

  constructor(address _school) BaseContract(_school) { }


  /**
   * EXTERNAL FUNCTIONS
   */

  /**
    EXTERNAL FUNCTIONS
   */

  function addStudents(Student[] memory _students) external onlyOwner {
    require(_students.length > 0, EmptyStudentsArray());

    uint256 len = _students.length;
    for (uint256 i = 0; i < len; ++i) {
      _addStudent(_students[i]);
    }
  }

  /**
   * @dev Updates student information.
   * @param _studentAddress Address of the student to update.
   * @param _firstName New first name of the student. Use empty string if no change is needed.
   * @param _midName New middle name of the student. Use empty string if no change is needed.
   * @param _lastName New last name of the student. Use empty string if no change is needed.
   * @param _dob New date of birth of the student. Use 0 if no change is needed.
   * @param _additionalInfo Additional information about the student. Use empty string if no change is needed.
   */
  function updateStudentInfo(
    address _studentAddress,
    string memory _firstName,
    string memory _midName,
    string memory _lastName,
    uint256 _dob,
    string memory _additionalInfo
  ) external onlyOwner {
    Student storage student = students[_studentAddress];
    require(student.studentAddress != address(0), NoStudentForAddress(_studentAddress));

    if (bytes(_firstName).length > 0) {
      student.firstName = _firstName;
    }
    
    if (bytes(_midName).length > 0) {
      student.midName = _midName;
    }
    
    if (bytes(_lastName).length > 0) {
      student.lastName = _lastName;
    }

    _updateStudentAddressByFullName(_studentAddress, _firstName, student.midName, student.lastName);
    
    if (_dob > 0) {
      student.dob = _dob;
    }
    
    if (bytes(_additionalInfo).length > 0) {
      student.additionalInfo = _additionalInfo;
    }
  }

  /**
   * @dev Updates the parents of a student.
   * @param _studentAddress Address of the student whose parents are to be updated.
   * @param _parents Array of addresses of the new parents. Must not be empty.
   */
  function updateStudentParents(address _studentAddress, address[] memory _parents) external onlyOwner {
    _updateStudentParents(_studentAddress, _parents);
  }

  /**
   * @dev Enrolls students into a specific class.
   * @param _studentAddresses List of student addresses to enroll.
   * @param _className The class name.
   * @param _classYear The academic year for the class.
   */
  function enrollStudentsInClass(address[] calldata _studentAddresses, string calldata _className, uint256 _classYear) external onlyOwner {
    address classesContract = school.classesContract();
    require(classesContract != address(0), ClassesContractNotSet());

    for (uint256 i = 0; i < _studentAddresses.length; ++i) {
      require(isStudentAndNotBanned(_studentAddresses[i]), CantEnrollAddress(_studentAddresses[i]));

      bytes32 classId = IClasses(classesContract).classIdByNameAndYear(_className, _classYear);
      students[_studentAddresses[i]].classesEnrolled.push(classId);
    }
    
    IClasses(classesContract).enrollStudentsInClass(_studentAddresses, _className, _classYear);
  }

  /**
   * @dev Validates that all addresses in the array are students.
   * @param _addresses Array of addresses to validate.
   * @return True if all addresses are students, false otherwise.
   */
  function validateAddressesAreStudents(address[] calldata _addresses) external view returns (bool) {
    uint256 len = _addresses.length;
    for (uint256 i = 0; i < len; ++i) {
      if (students[_addresses[i]].studentAddress == address(0)) {
        return false;
      }
    }

    return true;
  }

  /**
   * @dev Gets the student struct by their full name.
   * @param _firstName First name of the student.
   * @param _midName Middle name of the student.
   * @param _lastName Last name of the student.
   * @return Student struct. Empty struct if no student found.
   */
  function getStudentByFullName(string memory _firstName, string memory _midName, string memory _lastName) external view returns (Student memory) {
    address studentAddress = getStudentAddressByFullName(_firstName, _midName, _lastName);
    return students[studentAddress];
  }


  /**
   * PUBLIC FUNCTIONS
   */

  /**
    * @dev Gets the student struct by their address.
    * @param _studentAddress Address of the student.
    * @return Student struct. Empty struct if no student found.
    */
  function getStudentByAddress(address _studentAddress) public view returns (Student memory) {
    return students[_studentAddress];
  }

  /**
    * @dev Gets the address of a student by their full name.
    * @param _firstName First name of the student.
    * @param _midName Middle name of the student.
    * @param _lastName Last name of the student.
    * @return Address of the student. Zero address if no student found.
    */
  function getStudentAddressByFullName(
    string memory _firstName,
    string memory _midName,
    string memory _lastName
  ) public view returns (address) {
    bytes32 studentFullNameHash = keccak256(abi.encodePacked(_firstName, _midName, _lastName));
    return studentAddressByFullName[studentFullNameHash];
  }

  function isStudentAndNotBanned(address _studentAddress) public view returns (bool) {
    Student memory student = students[_studentAddress];
    return student.studentAddress != address(0) && !student.isBanned;
  }


  /**
    PRIVATE FUNCTIONS
   */

  function _addStudent(Student memory _student) private {
    require(_student.studentAddress != address(0), ZeroAddressStudent());
    require(students[_student.studentAddress].studentAddress == address(0), StudentAlreadyExists(_student.studentAddress));
    require(bytes(_student.firstName).length > 0, EmptyFirstName());
    require(bytes(_student.lastName).length > 0, EmptyLastName());
    require(_student.dob > 0, EmptyDOB());

    students[_student.studentAddress] = _student;

    _updateStudentParents(
      _student.studentAddress,
      _student.parents
    );

    _updateStudentAddressByFullName(
      _student.studentAddress,
      _student.firstName,
      _student.midName,
      _student.lastName
    );
  }

  function _updateStudentAddressByFullName(
    address _studentAddress,
    string memory _firstName,
    string memory _midName,
    string memory _lastName
  ) private {
    bytes32 studentFullNameHash = keccak256(abi.encodePacked(_firstName, ENCODING_SEPARATOR, _midName, ENCODING_SEPARATOR, _lastName));
    studentAddressByFullName[studentFullNameHash] = _studentAddress;
  }

  function _updateStudentParents(address _studentAddress, address[] memory _parents) private {
    Student storage student = students[_studentAddress];

    require(student.studentAddress != address(0), NoStudentForAddress(_studentAddress));
    require(_parents.length > 0, EmpttyParents());

    student.parents = _parents;

    for (uint256 i = 0; i < _parents.length; ++i) {
      require(_parents[i] != address(0), ZeroAddressParent());

      studentAddressByParentAddress[_parents[i]] = _studentAddress;
    }
  }
}