// SPDX-License-Identifier: ISC
pragma solidity ^0.8.0;

import "./IMatch.sol";

/**
 * Represents a match object.
 */
contract Match is IMatch {
    // Unique identifier of the match.
    uint256 public id;

    // Who created the match.
    address public admin;

    // Until when can players start betting on the match.
    uint256 end;

    // Odds for each outcome, if defined.
    mapping(IMatch.Outcome => uint256) odds;

    // Represents bets placed on this match.
    IBet[] public bets;

    // Number of placed bets.
    uint256 public betCount;

    constructor() {}

    function getId() external view override returns (uint256) {}

    function setEnd(uint256) external override {}

    function getEnd() external view override returns (uint256) {}

    function setOdd(Outcome outcome, uint256) external override {}

    function getOdd(Outcome outcome) external view override returns (uint256) {}

    function addBet(IBet bet) external override {}

    function getBets() external view override returns (IBet[] memory) {}

    function getBetsCount() external view override returns (uint256) {}

    function updateBet(IBet bet) external override {}

    function deleteBet(IBet bet) external override {}
}
