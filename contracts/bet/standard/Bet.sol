// SPDX-License-Identifier: ISC
pragma solidity ^0.8.0;

import "../IBet.sol";

/**
 * Standard implementation of IBet.
 */
contract Bet is IBet {
    // Unique identifier of the bet.
    uint256 private id;

    // Unique identifier of the bettable.
    uint256 private bettableId;

    // Bet owner.
    address private owner;

    // The outcome the bet is bidding on.
    IBettable.Outcome private outcome;

    // The deposited value.
    uint256 private deposit;

    // Fee on transactions.
    uint256 private fee;

    // Status of the bet.
    Status private status;

    constructor(
        uint256 _id,
        uint256 _bettableId,
        IBettable.Outcome _outcome,
        uint256 _deposit,
        uint256 _fee,
        Status _status
    ) {
        require(
            _outcome != IBettable.Outcome.NOT_AVAILABLE,
            "Outcome must be final"
        );
        id = _id;
        bettableId = _bettableId;
        outcome = _outcome;
        deposit = _deposit;
        fee = _fee;
        status = _status;
    }

    /**
     * Restricted only to admins.
     */
    modifier onlyAdmin() {
        // #TODO should only be accessible by admins
        _;
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
    modifier outcomeFinal(IBettable.Outcome _outcome) {
        require(
            _outcome != IBettable.Outcome.NOT_AVAILABLE,
            "Outcome must be final"
        );
        _;
    }

    /**
     * Only if bet not withdrawn.
     */
    modifier notWithdrawn() {
        require(
            (deposit != 0) && (status != Status.WITHDRAWN),
            "Bet withdrawn"
        );
        _;
    }

    /**
     * Only if bet not paid out.
     */
    modifier notPaid() {
        require((deposit != 0) && (status != Status.PAID), "Bet paid out");
        _;
    }

    function getId() external view override returns (uint256) {
        return id;
    }

    function getBettableId() external view override returns (uint256) {
        return bettableId;
    }

    function getOwner() external view override returns (address) {
        return owner;
    }

    function setOwner(address _owner) external override onlyOwner(this) {
        owner = _owner;
    }

    function getOutcome() external view override returns (IBettable.Outcome) {
        return outcome;
    }

    function setOutcome(IBettable.Outcome _outcome)
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
        // #TODO what if there is not enough to pay out?
        // #TODO what if the division causes a casting error (uint256 -> ufixed)?
        // #TODO apply a "withdrawing fee"
        (bool success, ) = owner.call{value: deposit * (1 - fee / 100)}("");
        require(success, "Failed to transfer tokens");
        deposit = 0;
        status = Status.WITHDRAWN;
    }

    function payout(IBettable _bettable)
        external
        payable
        override
        onlyOwner(this)
        outcomeFinal(_bettable.getOutcome())
        notPaid
    {
        // #TODO what if there is not enough to pay out?
        // #TODO what if the division causes a casting error (uint256 -> ufixed)?
        // Bet failed
        if (_bettable.getOutcome() != outcome) {
            status = Status.FAILED;
            return;
        }
        // Bet success
        uint256 toPay = (_bettable.getOdds(outcome) / 100) *
            deposit *
            (1 - fee / 100);
        (bool success, ) = owner.call{value: toPay}("");
        require(success, "Failed to transfer tokens");
        deposit = 0;
        status = Status.PAID;
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
        (bool success, ) = address(this).call{value: _amount * (1 + fee / 100)}(
            ""
        );
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
        // #TODO what if there is not enough to pay out?
        // #TODO what if the division causes a casting error (uint256 -> ufixed)?
        require(_amount < deposit, "Cannot lower more than deposited");
        (bool success, ) = owner.call{value: _amount * (1 - fee / 100)}("");
        require(success, "Failed to transfer tokens");
        deposit -= _amount;
    }

    function getStatus() external view override returns (Status) {
        return status;
    }

    function setStatus(Status _status) external override onlyAdmin {
        status = _status;
    }
}
