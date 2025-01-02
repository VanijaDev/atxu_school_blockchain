// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import { AccessControl } from "@openzeppelin/contracts/access/AccessControl.sol";

// Uncomment this line to use console.log
// import "hardhat/console.sol";

/**
 * @title School.
 * @author Ivan Solomichev.
 * @notice The School contract is an interface to use all the functionality through it.
 * @dev The School contract is a Proxy or Diamond storage.
 */
contract School is AccessControl {

  enum TestFaucetType {
    Students,
    Semesters,
    Classes,
    Teachers,
    Donations,
    Donors
  }

  address public _studentsContract;
  address public _semestersContract;
  address public _classesContract;
  address public _teachersContract;
  address public _donationsContract;
  address public _donorsContract;


  /**
   * @dev Constructor.
   * @param _defaultAdmin The default admin role.
   */
  constructor(address _defaultAdmin) {
    _grantRole(DEFAULT_ADMIN_ROLE, _defaultAdmin);
  }

  /**
   * @dev Add a faucet contract.
   * @param _faucetType The type of the faucet.
   * @param _faucetAddress The address of the faucet.
   */
  function addFaucet(TestFaucetType _faucetType, address _faucetAddress) external {
    if (_faucetType == TestFaucetType.Students) {
      _studentsContract = _faucetAddress;
    } else if (_faucetType == TestFaucetType.Semesters) {
      _semestersContract = _faucetAddress;
    } else if (_faucetType == TestFaucetType.Classes) {
      _classesContract = _faucetAddress;
    } else if (_faucetType == TestFaucetType.Teachers) {
      _teachersContract = _faucetAddress;
    } else if (_faucetType == TestFaucetType.Donations) {
      _donationsContract = _faucetAddress;
    } else if (_faucetType == TestFaucetType.Donors) {
      _donorsContract = _faucetAddress;
    } else {
      revert("Invalid faucet type");
    }
  }

  /**
   * @dev Get the current semester id.
   * @return The current semester id.
   */
  function currentSemesterId() external view returns (uint256) {
    // TODO: implement via Diamond faucets
    (bool success, bytes memory data) = _semestersContract.staticcall(abi.encodeWithSignature("currentSemesterId()"));
    require(success, "currentSemesterId() failed");
    return abi.decode(data, (uint256));
  }
}
