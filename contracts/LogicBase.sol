// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "./AppRegistry.sol";
import "./Permissions.sol";
import "./Events.sol";

abstract contract LogicBase {
    error Unauthorized();
    AppRegistry public immutable registry;

    constructor(AppRegistry _registry) { registry = _registry; }

    // ────────────────────────────────────────────────────────────────
    // ✦ Хелперы, которые достают адреса из кортежа за один-два шага ✦
    // ────────────────────────────────────────────────────────────────

    function _permissions() internal view returns (Permissions p) {
        (, address perms, , ) = registry.core();
        p = Permissions(perms);
    }

    function _events() internal view returns (Events e) {
        (, , address ev, ) = registry.core();
        e = Events(ev);
    }

    // ────────────────────────────────────────────────────────────────
    //                     Модификаторы / утилиты
    // ────────────────────────────────────────────────────────────────

    modifier onlyWhitelisted() {
        if (!_permissions().check(msg.sender)) revert Unauthorized();
        _;
    }

    function _log(string memory tag, bytes memory data) internal {
        _events().emitEvent(tag, data);
    }
}
