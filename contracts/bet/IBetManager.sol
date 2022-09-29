// SPDX-License-Identifier: ISC
pragma solidity ^0.8.0;

import "./IBet.sol";

/**
 * Bet Manager component.
 */
interface IBetManager {
    /**
     * Places a bet on a bettable event.
     */
    function betPlace(uint256 _bettableId, IBettable.Outcome _outcome)
        external
        payable;

    /**
     * Updates the bet owner.
     */
    function betUpdate(uint256 _id, address _owner) external;

    /**
     * Updates the outcome of the bet.
     */
    function betUpdate(uint256 _id, IBettable.Outcome _outcome) external;

    /**
     * Calculates the status of the bet (view-only).
     */
    function betResult(uint256 _id) external view returns (IBet.Status);

    /**
     * Withdraws the bet at a cost.
     */
    function betWithdraw(uint256 _id) external;

    /**
     * Determines the outcome of the bet and pays out.
     */
    function betPayout(uint256 _id) external;

    /**
     * Boost the deposit of the bet at a cost.
     */
    function betBoost(uint256 _id) external payable;

    /**
     * Lowers the deposit of the bet at a cost.
     */
    function betLower(uint256 _id, uint256 _amount) external;
}
