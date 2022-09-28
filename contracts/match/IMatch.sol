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
        PLAYER_A,
        PLAYER_B,
        TIE
    }

    /**
     * Unique identifier of the match.
     */
    function getId() external view returns (uint256);

    /**
     * Sets the end timestamp (until when can users place bets.)
     */
    function setEnd(uint256) external;

    /**
     * End timestamp (until when can users place bets.)
     */
    function getEnd() external view returns (uint256);

    /**
     * Sets the odds for the given outcome, if any.
     */
    function setOdd(Outcome outcome, uint256) external;

    /**
     * Odds for the given outcome, if any.
     */
    function getOdd(Outcome outcome) external view returns (uint256);

    /**
     * Places a bet on the match.
     */
    function addBet(IBet bet) external;

    /**
     * All placed bets.
     */
    function getBets() external view returns (IBet[] memory);

    /**
     * Number of bets placed.
     */
    function getBetsCount() external view returns (uint256);

    /**
     * Updates a placed bet.
     */
    function updateBet(IBet bet) external;

    /**
     * Revokes an already placed bet, if any.
     */
    function deleteBet(IBet bet) external;
}
