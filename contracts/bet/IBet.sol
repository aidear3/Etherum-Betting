// SPDX-License-Identifier: ISC
pragma solidity ^0.8.0;

import "../match/IMatch.sol";

/**
 * Represents a bet.
 */
interface IBet {
    /**
     * Unique identifier of the bet.
     */
    function getId() external view returns (uint256);

    /**
     * ID of the match the user bet on.
     */
    function getMatchId() external view returns (uint256);

    /**
     * User who placed bet.
     */
    function getOwner() external view returns (address);

    /**
     * Sets the user who placed bet.
     */
    function setOwner(address _owner) external;

    /**
     * Outcome the user is betting on.
     */
    function getOutcome() external view returns (IMatch.Outcome);

    /**
     * Sets the outcome the user is betting on.
     */
    function setOutcome(IMatch.Outcome _outcome) external;

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
    function payout(IMatch _match) external payable;

    /**
     * Adds more tokens to the bet.
     */
    function boost(uint256 _amount) external payable;

    /**
     * Removes tokens from the bet.
     */
    function lower(uint256 _amount) external payable;
}
