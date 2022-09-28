// SPDX-License-Identifier: ISC
pragma solidity ^0.8.0;

import "../bettable/IBettable.sol";

/**
 * Represents a bet.
 */
interface IBet {
    /**
     * Status of the bet.
     */
    enum Status {
        NOT_AVAILABLE,
        FAILED,
        PENDING_PAYMENT,
        PAID,
        WITHDRAWN
    }

    /**
     * Unique identifier of the bet.
     */
    function getId() external view returns (uint256);

    /**
     * ID of the bettable the user bet on.
     */
    function getBettableId() external view returns (uint256);

    /**
     * User who placed bet.
     */
    function getOwner() external view returns (address);

    /**
     * Sets the user who placed bet.
     */
    function setOwner(address _owner) external;

    /**
     * Status of the bet.
     */
    function getStatus() external view returns (Status);

    /**
     * Sets the status of the bet.
     */
    function setStatus(Status _status) external;

    /**
     * Outcome the user is betting on.
     */
    function getOutcome() external view returns (IBettable.Outcome);

    /**
     * Sets the outcome the user is betting on.
     */
    function setOutcome(IBettable.Outcome _outcome) external;

    /**
     * Amount of tokens the user is betting on.
     */
    function getDeposit() external view returns (uint256);

    /**
     * Reverts the bet, sends owner tokens back.
     */
    function withdraw() external payable;

    /**
     * Sends owner tokens based on outcome, deposit and odds.
     */
    function payout(IBettable _bettable) external payable;

    /**
     * Adds more tokens to the bet.
     */
    function boost(uint256 _amount) external payable;

    /**
     * Removes tokens from the bet.
     */
    function lower(uint256 _amount) external payable;
}
