// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;
import "./LogicBase.sol";

contract LogicC is LogicBase {
    constructor(AppRegistry reg) LogicBase(reg) {}

    function sum(uint256 a, uint256 b) external view returns (uint256) { return a + b; }
}
