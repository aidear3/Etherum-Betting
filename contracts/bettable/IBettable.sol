// SPDX-License-Identifier: ISC
pragma solidity ^0.8.0;

import "../bet/IBet.sol";

/**
 * Represents a bettable object.
 */
interface IBettable {
    /**
     * Possible outcomes of the bettable.
     */
    enum Outcome {
        NOT_AVAILABLE,
        PLAYER_A,
        PLAYER_B,
        TIE
    }

    /**
     * Unique identifier of the bettable.
     */
    function getId() external view returns (uint256);

    /**
     * Sets the deadline timestamp (until when can users place bets) for a certain outcome.
     */
    function setDeadline(Outcome _outcome, uint256 _timestamp) external;

    /**
     * Deadline timestamp (until when can users place bets) for a certain outcome.
     */
    function getDeadline(Outcome _outcome) external view returns (uint256);

    /**
     * Sets the odds for the given outcome, if any.
     */
    function setOdds(Outcome _outcome, uint256 _odds) external;

    /**
     * Odds for the given outcome, if any. Should be >= 100, because Bet
     * divides it by 100 to get the value.
     */
    function getOdds(Outcome _outcome) external view returns (uint256);

    /**
     * Sets the final outcome of the bettable.
     */
    function setOutcome(Outcome _outcome) external;

    /**
     * Final outcome of the bettable.
     */
    function getOutcome() external view returns (Outcome);

    /**
     * Sets the information about the bettable.
     */
    function setInfo(string memory _info) external;

    /**
     * Information about the bettable.
     */
    function getInfo() external view returns (string memory);

    /**
     * Places a bet on the bettable.
     */
    function addBet(IBet _bet) external;

    /**
     * Get bet from bet ID.
     */
    function getBet(uint256 _id) external view returns (IBet);

    /**
     * Updates a placed bet.
     */
    function updateBet(IBet _bet) external;

    /**
     * Revokes an already placed bet, if any.
     */
    function deleteBet(IBet _bet) external;
}
