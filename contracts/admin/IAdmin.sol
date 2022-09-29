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
        FUNDING_READ,
        FUNDING_DEPOSIT,
        FUNDING_WITHDRAW,
        BETS_PAY,
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
     * Admin permissions.
     */
    function getPermission() external view returns (Permission[] memory);

    /**
     * Sets the admin permissions.
     */
    function setPermission(Permission[] memory _permissions) external;
}
