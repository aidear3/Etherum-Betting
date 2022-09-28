// SPDX-License-Identifier: ISC
pragma solidity ^0.8.0;

import "../IBet.sol";

/**
 * Standard implementation of IBet.
 */
contract Bet is IBet {
    // Unique identifier of the bet.
    uint256 private id;

    // Unique identifier of the match.
    uint256 private matchId;

    // Bet owner.
    address private owner;

    // The outcome the bet is bidding on.
    IMatch.Outcome private outcome;

    // The deposited value.
    uint256 private deposit;

    // Fee on transactions.
    uint256 private fee;

    constructor(
        uint256 _id,
        uint256 _matchId,
        IMatch.Outcome _outcome,
        uint256 _deposit,
        uint256 _fee
    ) {
        require(
            _outcome != IMatch.Outcome.NOT_AVAILABLE,
            "Outcome must be final"
        );
        id = _id;
        matchId = _matchId;
        outcome = _outcome;
        deposit = _deposit;
        fee = _fee;
    }

    /**
     * Requires sender to own the bet.
     */
    modifier onlyOwner(IBet _bet) {
        require(
            _bet.getOwner() == msg.sender,
            "You are not authorized for this bet"
        );
        _;
    }

    /**
     * Requires the outcome to have a final value.
     */
    modifier outcomeFinal(IMatch.Outcome _outcome) {
        require(
            _outcome != IMatch.Outcome.NOT_AVAILABLE,
            "Outcome must be final"
        );
        _;
    }

    /**
     * Only if bet not withdrawn.
     */
    modifier notWithdrawn() {
        require(deposit != 0, "Bet withdrawn");
        _;
    }

    /**
     * Only if bet not paid out.
     */
    modifier notPaid() {
        require(deposit != 0, "Bet paid out");
        _;
    }

    function getId() external view override returns (uint256) {
        return id;
    }

    function getMatchId() external view override returns (uint256) {
        return matchId;
    }

    function getOwner() external view override returns (address) {
        return owner;
    }

    function setOwner(address _owner) external override onlyOwner(this) {
        owner = _owner;
    }

    function getOutcome() external view override returns (IMatch.Outcome) {
        return outcome;
    }

    function setOutcome(IMatch.Outcome _outcome)
        external
        override
        onlyOwner(this)
        outcomeFinal(_outcome)
    {
        outcome = _outcome;
    }

    function getDeposit()
        external
        view
        override
        onlyOwner(this)
        returns (uint256)
    {
        return deposit;
    }

    function withdraw()
        external
        payable
        override
        onlyOwner(this)
        notPaid
        notWithdrawn
    {
        // #TODO apply a "withdrawing fee"
        (bool success, ) = owner.call{value: deposit}("");
        require(success, "Failed to transfer tokens");
        deposit = 0;
    }

    function payout(IMatch _match)
        external
        payable
        override
        onlyOwner(this)
        outcomeFinal(_match.getOutcome())
        notPaid
    {
        // Bet failed
        if (_match.getOutcome() != outcome) return;
        // Bet success
        uint256 toPay = _match.getOdds(outcome) * deposit * (1 - fee);
        (bool success, ) = owner.call{value: toPay}("");
        require(success, "Failed to transfer tokens");
        deposit = 0;
    }

    function boost(uint256 _amount)
        external
        payable
        override
        onlyOwner(this)
        notWithdrawn
        notPaid
    {
        // #TODO apply a "boosting fee"
        require(_amount > 0, "Cannot boost by 0 tokens");
        (bool success, ) = address(this).call{value: _amount * (1 + fee)}("");
        require(success, "Failed to transfer tokens");
        deposit += _amount;
    }

    function lower(uint256 _amount)
        external
        payable
        override
        onlyOwner(this)
        notWithdrawn
        notPaid
    {
        // #TODO apply a "lowering fee"
        require(_amount < deposit, "Cannot lower more than deposited");
        (bool success, ) = owner.call{value: _amount * (1 + fee)}("");
        require(success, "Failed to transfer tokens");
        deposit -= _amount;
    }
}