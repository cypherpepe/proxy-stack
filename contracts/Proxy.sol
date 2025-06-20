// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

/// @notice Простая EIP-1967-совместимая proxy-реализация
contract Proxy {
    /// keccak256("eip1967.proxy.implementation") − 1
    bytes32 private constant _IMPL_SLOT  = 0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc;
    /// keccak256("eip1967.proxy.admin") − 1
    bytes32 private constant _ADMIN_SLOT = 0xb53127684a568b3173ae13b9f8a6016e019d2cf0e46b97940000000000000000;

    error InvalidAddress();
    error NotAdmin();

    constructor(address implementation_, address admin_, bytes memory initData) payable {
        if (implementation_ == address(0) || admin_ == address(0)) revert InvalidAddress();
        assembly {
            sstore(_ADMIN_SLOT, admin_)
            sstore(_IMPL_SLOT, implementation_)
        }
        if (initData.length > 0) {
            (bool ok,) = implementation_.delegatecall(initData);
            if (!ok) revert InvalidAddress();
        }
    }

    modifier onlyAdmin() {
        assembly {
            if iszero(eq(caller(), sload(_ADMIN_SLOT))) { revert(0,0) }
        }
        _;
    }

    function upgradeTo(address newImpl) external onlyAdmin {
        if (newImpl == address(0)) revert InvalidAddress();
        assembly { sstore(_IMPL_SLOT, newImpl) }
    }

    function admin() external view returns (address a) {
        assembly { a := sload(_ADMIN_SLOT) }
    }

    function implementation() external view returns (address i) {
        assembly { i := sload(_IMPL_SLOT) }
    }

    fallback() external payable {
        assembly {
            let _impl := sload(_IMPL_SLOT)
            calldatacopy(0, 0, calldatasize())
            let res := delegatecall(gas(), _impl, 0, calldatasize(), 0, 0)
            returndatacopy(0, 0, returndatasize())
            switch res case 0 { revert(0, returndatasize()) } default { return(0, returndatasize()) }
        }
    }
    receive() external payable {}
}
