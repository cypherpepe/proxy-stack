// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;
import "./LogicBase.sol";

contract LogicB is LogicBase {
    constructor(AppRegistry reg) LogicBase(reg) {}

    function double(uint256 x) external view returns (uint256) { return x * 2; }
}
