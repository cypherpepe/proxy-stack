// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "./Proxy.sol";

contract ProxyAdmin {
    error Unauthorized();
    address public immutable owner;

    constructor(address _owner) {
        owner = _owner;
    }

    modifier onlyOwner() { if (msg.sender != owner) revert Unauthorized(); _; }

    function upgrade(Proxy proxy, address newImpl) external onlyOwner {
        proxy.upgradeTo(newImpl);
    }
}
