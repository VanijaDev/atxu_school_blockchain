// SPDX-License-Identifier: MIT
pragma solidity ^0.8.27;

import { IStudents } from "./interfaces/IStudents.sol";
import { ISemesters } from "./interfaces/ISemesters.sol";
import { IDonations } from "./interfaces/IDonations.sol";

// Uncomment this line to use console.log
// import "hardhat/console.sol";

/**
 * @title School.
 * @author Ivan Solomichev.
 * @notice The School contract is an interface to use all the functionality through it.
 * @dev The School contract is a Proxy or Diamond storage.
 */
contract School {
    IStudents public students;
    ISemesters public semesters;
    IDonations public donations;
}
