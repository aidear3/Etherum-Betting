// SPDX-License-Identifier: ISC
pragma solidity ^0.8.0;

import "../IBettable.sol";

/**
 * Standard implementation of IBettable.
 */
contract Bettable is IBettable {
    // Unique identifier of the bettable.
    uint256 private id;

    // Who created the bettable.
    address private admin;

    // Odds for each outcome, if defined.
    mapping(IBettable.Outcome => uint256) private odds;

    // Odds for each outcome, if defined.
    mapping(IBettable.Outcome => uint256) private deadlines;

    // Represents bets placed on this bettable.
    mapping(uint256 => IBet) private bets;

    // Number of placed bets.
    uint256 private betsCount = 0;

    // Final outcome of the bettable.
    IBettable.Outcome outcome;

    // Info about the bettable.
    string private info;

    constructor(uint256 _id) {
        id = _id;
        admin = msg.sender;
    }

    /**
     * Prevents unwanted modifying.
     */
    modifier onlyAdmin() {
        require(
            msg.sender == admin,
            "You must be the administrator of this bettable"
        );
        _;
    }

    /**
     * Prevents editing after bets placed.
     */
    modifier noBets() {
        require(betsCount == 0, "Bets have already been placed");
        _;
    }

    /**
     * Prevents editing after deadline.
     */
    modifier notStarted(Outcome _outcome) {
        require(
            (this.getDeadline(_outcome) != 0) &&
                (this.getDeadline(_outcome) < block.timestamp),
            "Betting on this outcome is not available"
        );
        _;
    }

    /**
     * Require that a bet is placed.
     */
    modifier betExists(uint256 _id) {
        require(_id == bets[_id].getId(), "Bet not placed");
        _;
    }

    /**
     * Require a bet does not exist.
     */
    modifier betNotExists(uint256 _id) {
        require(bets[_id].getId() == 0, "Bet already placed");
        _;
    }

    /**
     * Requires sender to own the bet.
     */
    modifier ownsBet(IBet _bet) {
        require(
            _bet.getOwner() == msg.sender,
            "You are not authorized for this bet"
        );
        _;
    }

    /**
     * Requires the outcome to have a final value.
     */
    modifier outcomeFinal(Outcome _outcome) {
        require(_outcome != Outcome.NOT_AVAILABLE, "Outcome must be final");
        _;
    }

    function getId() external view override returns (uint256) {
        return id;
    }

    function setAdmin(address _admin) external override onlyAdmin {
        admin = _admin;
    }

    function getAdmin() external view override returns (address) {
        return admin;
    }

    function setDeadline(Outcome _outcome, uint256 _timestamp)
        external
        override
        onlyAdmin
        notStarted(_outcome)
        outcomeFinal(_outcome)
    {
        deadlines[_outcome] = _timestamp;
    }

    function getDeadline(Outcome _outcome)
        external
        view
        override
        notStarted(_outcome)
        outcomeFinal(_outcome)
        returns (uint256)
    {
        return deadlines[_outcome];
    }

    function setOdds(Outcome _outcome, uint256 _odds)
        external
        override
        onlyAdmin
        notStarted(_outcome)
    {
        odds[_outcome] = _odds;
    }

    function getOdds(Outcome _outcome)
        external
        view
        override
        returns (uint256)
    {
        return odds[_outcome];
    }

    function setOutcome(Outcome _outcome)
        external
        override
        onlyAdmin
        outcomeFinal(_outcome)
    {
        outcome = _outcome;
    }

    function getOutcome()
        external
        view
        override
        outcomeFinal(outcome)
        returns (Outcome)
    {
        return outcome;
    }

    function addBet(IBet _bet)
        external
        override
        betNotExists(_bet.getId())
        notStarted(_bet.getOutcome())
        ownsBet(_bet)
    {
        bets[_bet.getId()] = _bet;
        betsCount++;
    }

    function getBet(uint256 _id)
        external
        view
        override
        betExists(_id)
        ownsBet(bets[_id])
        returns (IBet)
    {
        return bets[_id];
    }

    function updateBet(IBet _bet)
        external
        override
        betExists(_bet.getId())
        notStarted(_bet.getOutcome())
        ownsBet(_bet)
    {
        bets[_bet.getId()] = _bet;
    }

    function deleteBet(IBet _bet)
        external
        override
        betExists(_bet.getId())
        notStarted(_bet.getOutcome())
        ownsBet(_bet)
    {
        delete bets[_bet.getId()];
        betsCount--;
        _bet.withdraw();
    }

    function setInfo(string memory _info) external override onlyAdmin {
        info = _info;
    }

    function getInfo() external view override returns (string memory) {
        return info;
    }
}
