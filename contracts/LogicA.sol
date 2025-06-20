// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;
import "./LogicBase.sol";

contract LogicA is LogicBase {
    uint256 public value;

    constructor(AppRegistry reg) LogicBase(reg) {}

    function setValue(uint256 _value) external onlyWhitelisted {
        value = _value;
        _log("LogicA.setValue", abi.encode(_value));
    }
}
