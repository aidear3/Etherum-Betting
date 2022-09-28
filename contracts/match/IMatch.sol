// SPDX-License-Identifier: ISC
pragma solidity ^0.8.0;

import "../bet/IBet.sol";

/**
 * Represents a match object.
 */
interface IMatch {
    /**
     * Possible outcomes of the match.
     */
    enum Outcome {
        NOT_AVAILABLE,
        PLAYER_A,
        PLAYER_B,
        TIE
    }

    /**
     * Unique identifier of the match.
     */
    function getId() external view returns (uint256);

    /**
     * Sets the administrator of the match.
     */
    function setAdmin(address _admin) external;

    /**
     * Administrator of the match.
     */
    function getAdmin() external view returns (address);

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
     * Odds for the given outcome, if any.
     */
    function getOdds(Outcome _outcome) external view returns (uint256);

    /**
     * Sets the final outcome of the match.
     */
    function setOutcome(Outcome _outcome) external;

    /**
     * Final outcome of the match.
     */
    function getOutcome() external view returns (Outcome);

    /**
     * Places a bet on the match.
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
