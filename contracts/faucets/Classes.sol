// SPDX-License-Identifier: MIT
pragma solidity 0.8.28;

import { SchoolAsProxy } from "./SchoolAsProxy.sol";
import { ClassInfo, ClassInfoToAdd } from "../structs/Structs.sol";
import { ZeroAddress, StudentNotFoundInClass, TeacherNotFoundInClass } from "../errors/Errors.sol";

/**
 * @title Classes
 * @author Ivan Solomichev.
 * @dev The Classes contract
 */
contract Classes is SchoolAsProxy {
  uint256 public classCount;

  mapping(uint256 => ClassInfo) public classInfoById;

  error NoClassForId(uint256 classId);

  constructor(address _schoolAddress) SchoolAsProxy(_schoolAddress) {}


  /**
   * @dev Checks if the student is in the class.
   * @param _classId The class id.
   * @param _student The student address.
   * @return bool Whether the student is in the class.
   */
  function isStudentOfClass(uint256 _classId, address _student) external view returns (bool) {
    ClassInfo storage classInfo = classInfoById[_classId];
    require(bytes(classInfo.name).length > 0, NoClassForId(_classId));

    uint256 len = classInfo.students.length;

    for (uint256 i = 0; i < len; ) {
      if (classInfo.students[i] == _student) {
        return true;
      }

      unchecked {
        ++i;
      }
    }

    return false;
  }

  /**
   * @dev Creates a class.
   * @param _classInfo The class info.
   */
  function createClass(ClassInfoToAdd calldata _classInfo) external onlySchool {
    ClassInfo storage classInfo = classInfoById[classCount];

    /**
     * TODO
     * check if name is not used
     * check if primaryTeacher is a isLifetimeTeachers
     * check isLifetimeTeachers
     * check isLifetimeStudents
     */

    classInfo.id = classCount;
    classInfo.name = _classInfo.name;
    classInfo.primaryTeacher = _classInfo.primaryTeacher;
    classInfo.teachers = _classInfo.teachers;
    classInfo.students = _classInfo.students;
    classInfo.additionalInfo = _classInfo.additionalInfo;
    classInfo.additionalInfoUrl = _classInfo.additionalInfoUrl;

    unchecked {
      ++classCount;
    }
  }
  
  /**
   * @dev Adds students to the class.
   * @param _classId The class id.
   * @param _students The students.
   */
  function addStudentsToClass(uint256 _classId, address[] calldata _students) external onlySchool {
    ClassInfo storage classInfo = classInfoById[_classId];
    require(bytes(classInfo.name).length > 0, NoClassForId(_classId));

    /**
     * TODO:
      * check Semester for class is current or the next
      * isLifetimeStudents
     */

    uint256 len = _students.length;

    for (uint256 i = 0; i < len; ) {
      classInfo.students.push(_students[i]);

      unchecked {
        ++i;
      }
    } 
  }

  /**
   * @dev Removes a student from the class.
   * @param _student The student address.
   * @param _classId The class id.
   */
  function removeStudentFromClass(address _student, uint256 _classId) external onlySchool {
    require(_student != address(0), ZeroAddress());

    ClassInfo storage classInfo = classInfoById[_classId];
    require(bytes(classInfo.name).length > 0, NoClassForId(_classId));

    /**
     * TODO:
      * check Semester for class is current or the next
     */

    uint256 len = classInfo.students.length;

    for (uint256 i = 0; i < len; ) {
      if (classInfo.students[i] == _student) {
        classInfo.students[i] = classInfo.students[len - 1];
        classInfo.students.pop();
        return;
      }

      unchecked {
        ++i;
      }
    }

    revert StudentNotFoundInClass(_student, _classId);
  }

  /**
   * @dev Adds teachers to the class.
   * @param _classId The class id.
   * @param _teachers The teachers.
   */
  function addTeachersToClass(uint256 _classId, address[] calldata _teachers) external onlySchool {
    ClassInfo storage classInfo = classInfoById[_classId];
    require(bytes(classInfo.name).length > 0, NoClassForId(_classId));

    /**
     * TODO:
      * check Semester for class is current or the next
      * isLifetimeTeachers
     */

    uint256 len = _teachers.length;

    for (uint256 i = 0; i < len; ) {
      classInfo.teachers.push(_teachers[i]);

      unchecked {
        ++i;
      }
    }
  }

  /**
   * @dev Removes a teacher from the class.
   * @param _teacher The teacher address.
   * @param _classId The class id.
   */
  function removeTeacherFromClass(address _teacher, uint256 _classId) external onlySchool {
    require(_teacher != address(0), ZeroAddress());

    ClassInfo storage classInfo = classInfoById[_classId];
    require(bytes(classInfo.name).length > 0, NoClassForId(_classId));

    /**
     * TODO:
      * check Semester for class is current or the next
     */

    uint256 len = classInfo.teachers.length;

    for (uint256 i = 0; i < len; ) {
      if (classInfo.teachers[i] == _teacher) {
        classInfo.teachers[i] = classInfo.teachers[len - 1];
        classInfo.teachers.pop();
        return;
      }

      unchecked {
        ++i;
      }
    }

    revert TeacherNotFoundInClass(_teacher, _classId);
  }

  /**
   * @dev Updates the class name.
   * @param _classId The class id.
   * @param _name The class name.
   */
  function updateClassName(uint256 _classId, string calldata _name) external onlySchool {
    ClassInfo storage classInfo = classInfoById[_classId];
    require(bytes(classInfo.name).length > 0, NoClassForId(_classId));

    /**
     * TODO:
      * check Semester for class is the next
      * name is not used
     */

    classInfo.name = _name;
  }

  /**
   * @dev Updates the class primary teacher.
   * @param _classId The class id.
   * @param _primaryTeacher The primary teacher.
   */
  function updateClassPrimaryTeacher(uint256 _classId, address _primaryTeacher) external onlySchool {
    ClassInfo storage classInfo = classInfoById[_classId];
    require(bytes(classInfo.name).length > 0, NoClassForId(_classId));

    /**
     * TODO:
      * check Semester for class is the next
      * isLifetimeTeacher
     */

    classInfo.primaryTeacher = _primaryTeacher;
  }

  /**
   * @dev Updates the class additional info.
   * @param _classId The class id.
   * @param _additionalInfo The additional info.
   */
  function updateClassAdditionalInfo(uint256 _classId, string calldata _additionalInfo) external onlySchool {
    ClassInfo storage classInfo = classInfoById[_classId];
    require(bytes(classInfo.name).length > 0, NoClassForId(_classId));

    classInfo.additionalInfo = _additionalInfo;
  }

  /**
   * @dev Updates the class additional info URL.
   * @param _classId The class id.
   * @param _additionalInfoUrl The additional info URL.
   */
  function updateClassAdditionalInfoUrl(uint256 _classId, string calldata _additionalInfoUrl) external onlySchool {
    ClassInfo storage classInfo = classInfoById[_classId];
    require(bytes(classInfo.name).length > 0, NoClassForId(_classId));

    classInfo.additionalInfoUrl = _additionalInfoUrl;
  }
}
