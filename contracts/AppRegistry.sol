// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

/// @notice Единый «справочник» всех ключевых контрактов
contract AppRegistry {
    error InvalidAddress();
    struct Core {
        address proxyAdmin;
        address permissions;
        address events;
        address staticConfig;
    }

    Core public core;

    constructor(Core memory c) {
        if (
            c.proxyAdmin   == address(0) ||
            c.permissions  == address(0) ||
            c.events       == address(0) ||
            c.staticConfig == address(0)
        ) revert InvalidAddress();
        core = c;
    }
}
