// SPDX-License-Identifier: MIT
pragma solidity ^0.8.27;

import { ISchool } from "./interfaces/ISchool.sol";
import { IStudents } from "./interfaces/IStudents.sol";
import { ISemesters } from "./interfaces/ISemesters.sol";
import { IDonations } from "./interfaces/IDonations.sol";
import { ISponsors } from "./interfaces/ISponsors.sol";
import { AccessControl } from "@openzeppelin/contracts/access/AccessControl.sol";

// Uncomment this line to use console.log
// import "hardhat/console.sol";

/**
 * @title School.
 * @author Ivan Solomichev.
 * @notice The School contract is an interface to use all the functionality through it.
 * @dev The School contract is a Proxy or Diamond storage.
 */
contract School is ISchool, AccessControl {
  IStudents private _studentsContract;
  ISemesters private _semestersContract;
  IDonations private _donationsContract;
  ISponsors private _sponsorsContract;


  /**
   * @dev Constructor.
   * @param _students The address of the Students contract.
   * @param _semesters The address of the Semesters contract.
   * @param _donations The address of the Donations contract.
   * @param _sponsors The address of the Sponsors contract.
   */
  constructor(address _students, address _semesters, address _donations, address _sponsors) {
    _studentsContract = IStudents(_students);
    _semestersContract = ISemesters(_semesters);
    _donationsContract = IDonations(_donations);
    _sponsorsContract = ISponsors(_sponsors);
  }

  function studentsContract() external view override returns (address) {
    return address(_studentsContract);
  }

  function semestersContract() external view override returns (address) {
    return address(_semestersContract);
  }

  function donationsContract() external view override returns (address) {
    return address(_donationsContract);
  }

  function sponsorsContract() external view override returns (address) {
    return address(_sponsorsContract);
  }
}
