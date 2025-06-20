// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

/// @notice Неизменяемые параметры (сеть, версия, время деплоя)
contract StaticConfig {
    uint256 public immutable chainId;
    uint256 public immutable deployedAt;
    string  public /*immutable*/ version;   // <-- убрали immutable

    constructor(string memory _version) {
        chainId    = block.chainid;
        deployedAt = block.timestamp;
        version    = _version;
    }
}
