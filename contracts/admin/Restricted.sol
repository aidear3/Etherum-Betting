// SPDX-License-Identifier: ISC
pragma solidity ^0.8.0;

import "./IAdmin.sol";
import "./IAdminManager.sol";

/**
 * For easier access protection.
 */
contract Restricted {
    // Admin Manager component.
    IAdminManager private adminManager;

    constructor(IAdminManager _adminManager) {
        adminManager = _adminManager;
    }

    /**
     * AdminManager component.
     */
    function getAdminManager() internal view returns (IAdminManager) {
        return adminManager;
    }

    /**
     * Only for callers with a certain permission.
     */
    modifier onlyPerm(IAdmin.Permission _perm) {
        IAdmin curr = adminManager.adminInit();
        (IAdmin.Permission[] memory perms, uint256 count) = curr
            .getPermissions();
        for (uint i = 0; i < count; i++) {
            if (perms[i] == _perm) {
                _;
            }
        }
        revert("Insufficient permissions");
    }

    /**
     * Only for callers with a certain permission.
     */
    modifier onlyPerms(IAdmin.Permission[] memory _perms, uint256 _count) {
        IAdmin curr = adminManager.adminInit();
        (IAdmin.Permission[] memory perms, uint256 count) = curr
            .getPermissions();
        for (uint i = 0; i < _count; i++) {
            for (uint j = 0; j < count; j++) {
                if (_perms[i] == perms[j]) {
                    delete _perms[i]; // #TODO debug!
                    _count--;
                }
            }
        }
        if (_count == 0) {
            _;
        } else {
            revert("Insufficient permissions");
        }
    }
}
