// SPDX-License-Identifier: MIT
pragma solidity ^0.8.27;

import { NotSchool } from "../errors/Errors.sol";

library HelperLib {
  function _isAddressEqual(address _addr0, address _addr1) internal pure returns (bool isEqual) {
    isEqual = _addr0 == _addr1;
  }
}