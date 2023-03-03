// SPDX-License-Identifier: ISC
pragma solidity ^0.8.0;

import "./IAdmin.sol";

/**
 * For managing admins and admin actions.
 */
interface IAdminManager {
    //
    // ---------- Admins ----------
    //

    /**
     * Returns the current admin if the message sender is an admin.
     */
    function adminInit() external view returns (IAdmin);

    /**
     * Read specific admin. Only if user has sufficient perms.
     */
    function adminRead(address _address) external view returns (IAdmin);

    /**
     * Get all admins. Only if user has sufficient perms.
     */
    function adminReadAll() external view returns (IAdmin[] memory);

    /**
     * Creates a new admin. Only if user has sufficient perms.
     */
    function adminCreate(address _address, uint256 _salary)
        external
        view
        returns (IAdmin);

    /**
     * Creates a new admin with passed perms. Only if user has sufficient perms.
     */
    function adminCreate(
        address _address,
        uint256 _salary,
        IAdmin.Permission[] memory _perms
    ) external view returns (IAdmin);

    /**
     * Edits an admin. Only if user has sufficient perms.
     */
    function adminEdit(address _address, uint256 _salary)
        external
        view
        returns (IAdmin);

    /**
     * Edits an admin with passed perms. Only if user has sufficient perms.
     */
    function adminEdit(
        address _address,
        uint256 _salary,
        IAdmin.Permission[] memory _perms
    ) external view returns (IAdmin);

    /**
     * Removes an admin. Only if user has sufficient perms.
     */
    function adminRemove(address _address) external;

    /**
     * Pays an admin their salary. Only if user has sufficient perms.
     */
    function adminPay(address _address) external;

    /**
     * Pays all admins their salary. Only if user has sufficient perms.
     */
    function adminPayAll(address _address) external;

    //
    // ---------- Admin Perms ----------
    //

    /**
     * Get all perms of admin. Only if user has sufficient perms.
     */
    function adminPermRead(address _address)
        external
        view
        returns (IAdmin.Permission[] memory);

    /**
     * Grants permission to admin. Only if user has sufficient perms.
     */
    function adminPermGrant(address _address, IAdmin.Permission _permission)
        external;

    /**
     * Grants permission to admin. Only if user has sufficient perms.
     */
    function adminPermGrant(
        address _address,
        IAdmin.Permission[] memory _permissions
    ) external;

    /**
     * Revokes permission from admin. Only if user has sufficient perms.
     */
    function adminPermRevoke(address _address, IAdmin.Permission _permission)
        external;

    /**
     * Revokes permission from admin. Only if user has sufficient perms.
     */
    function adminPermRevoke(
        address _address,
        IAdmin.Permission[] memory _permissions
    ) external;
}
