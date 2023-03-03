// SPDX-License-Identifier: ISC
pragma solidity ^0.8.0;

import "../IAdminManager.sol";

/**
 * Standard implementation for IAdminManager.
 */
contract AdminManager is IAdminManager {
    function adminInit() external view override returns (IAdmin) {}

    function adminRead(address _address)
        external
        view
        override
        returns (IAdmin)
    {}

    function adminReadAll() external view override returns (IAdmin[] memory) {}

    function adminCreate(address _address, uint256 _salary)
        external
        view
        override
        returns (IAdmin)
    {}

    function adminCreate(
        address _address,
        uint256 _salary,
        IAdmin.Permission[] memory _perms
    ) external view override returns (IAdmin) {}

    function adminEdit(address _address, uint256 _salary)
        external
        view
        override
        returns (IAdmin)
    {}

    function adminEdit(
        address _address,
        uint256 _salary,
        IAdmin.Permission[] memory _perms
    ) external view override returns (IAdmin) {}

    function adminRemove(address _address) external override {}

    function adminPay(address _address) external override {}

    function adminPayAll(address _address) external override {}

    function adminPermRead(address _address)
        external
        view
        override
        returns (IAdmin.Permission[] memory)
    {}

    function adminPermGrant(address _address, IAdmin.Permission _permission)
        external
        override
    {}

    function adminPermGrant(
        address _address,
        IAdmin.Permission[] memory _permissions
    ) external override {}

    function adminPermRevoke(address _address, IAdmin.Permission _permission)
        external
        override
    {}

    function adminPermRevoke(
        address _address,
        IAdmin.Permission[] memory _permissions
    ) external override {}
}
