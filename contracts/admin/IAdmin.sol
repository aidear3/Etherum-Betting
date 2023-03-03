// SPDX-License-Identifier: ISC
pragma solidity ^0.8.0;

/**
 * Administrator users.
 */
interface IAdmin {
    /**
     * Permission types.
     */
    enum Permission {
        WALLET_READ,
        WALLET_DEPOSIT,
        WALLET_WITHDRAW,
        BET_PLACE,
        BET_READ,
        BET_EDIT,
        BET_REMOVE,
        BET_ADMIN,
        BET_PAY,
        BET_WITHDRAW,
        BET_BOOST,
        BET_LOWER,
        BETTABLE_READ,
        BETTABLE_CREATE,
        BETTABLE_EDIT,
        BETTABLE_REMOVE,
        ADMIN_READ,
        ADMIN_CREATE,
        ADMIN_EDIT,
        ADMIN_REMOVE,
        ADMIN_PAY,
        ADMIN_PERM_READ,
        ADMIN_PERM_GRANT,
        ADMIN_PERM_REVOKE
    }

    /**
     * Wallet address.
     */
    function getAddress() external view returns (address);

    /**
     * Salary per day (workdays included). E.g. $210/week (5 workdays) => $30/day.
     */
    function getSalary() external view returns (uint256);

    /**
     * Salary per day (workdays included). E.g. $210/week (5 workdays) => $30/day.
     */
    function setSalary() external view returns (uint256);

    /**
     * Timestamp of last salary.
     */
    function getLastSalaryTimestamp() external view returns (uint256);

    /**
     * Set timestamp of last salary.
     */
    function setLastSalaryTimestamp(uint256 _timestamp) external;

    /**
     * Pays admin their salary if more than one day passed since last payment.
     */
    function paySalary() external payable;

    /**
     * Admin permissions and count.
     */
    function getPermissions() external view returns (Permission[] memory, uint256);

    /**
     * Grants new permission to admin.
     */
    function grantPermission(Permission _permission) external;

    /**
     * Revokes permission from admin.
     */
    function revokePermission(Permission _permission) external;
}
