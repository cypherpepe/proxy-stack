// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

contract Permissions {
    error Unauthorized();
    error InvalidAddress();

    address public immutable owner;
    mapping(address => uint8) public whitelist; // 1 – разрешён

    constructor(address _owner) {
        if (_owner == address(0)) revert InvalidAddress();
        owner = _owner;
        whitelist[_owner] = 1;
    }

    modifier onlyOwner() { if (msg.sender != owner) revert Unauthorized(); _; }

    function add(address user) external onlyOwner { whitelist[user] = 1; }

    function check(address user) external view returns (bool) { return whitelist[user] == 1; }
}
