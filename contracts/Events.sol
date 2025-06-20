// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

/// @notice Централизованный «хаб» для событий
contract Events {
    event Executed(address indexed sender, string tag, bytes data);

    function emitEvent(string calldata tag, bytes calldata data) external {
        emit Executed(msg.sender, tag, data);
    }
}
