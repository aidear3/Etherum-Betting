// SPDX-License-Identifier: ISC
pragma solidity ^0.8.0;

import "../IBet.sol";
import "../../admin/IAdminManager.sol";
import "../../admin/Restricted.sol";
import "../../bettable/IBettableManager.sol";

/**
 * Standard implementation of IBet.
 */
contract Bet is IBet, Restricted {
    // Admin Manager component.
    IAdminManager private adminManager;

    // Bettable Manager component.
    IBettableManager private bettableManager;

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
        IAdminManager _adminManager,
        IBettableManager _bettableManager,
        uint256 _id,
        uint256 _bettableId,
        IBettable.Outcome _outcome,
        uint256 _deposit,
        uint256 _fee,
        Status _status
    ) Restricted(_adminManager) {
        require(
            _outcome != IBettable.Outcome.NOT_AVAILABLE,
            "Outcome must be final"
        );
        adminManager = _adminManager;
        bettableManager = _bettableManager;
        id = _id;
        bettableId = _bettableId;
        outcome = _outcome;
        deposit = _deposit;
        fee = _fee;
        status = _status;
        IBettable bettable = bettableManager.bettableReadInstance(bettableId);
        require(
            bettable.getId() == _bettableId,
            "Bettable event does not exist"
        );
        bettable.addBet(this);
    }

    /**
     * Requires sender to own the bet.
     */
    modifier onlyOwner() {
        require(
            this.getOwner() == msg.sender,
            "You are not authorized for this bet"
        );
        _;
    }

    /**
     * Requires sender to own the bet or have _perm permission.
     */
    modifier onlyOwnerOrPerm(IAdmin.Permission _perm) {
        IAdmin curr = adminManager.adminInit();
        (IAdmin.Permission[] memory perms, uint256 count) = curr
            .getPermissions();
        for (uint i = 0; i < count; i++) {
            if (perms[i] == _perm) {
                _;
            }
        }
        require(
            (this.getOwner() == msg.sender),
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

    function getId()
        external
        view
        override
        onlyOwnerOrPerm(IAdmin.Permission.BET_ADMIN)
        returns (uint256)
    {
        return id;
    }

    function getBettableId()
        external
        view
        override
        onlyOwnerOrPerm(IAdmin.Permission.BET_ADMIN)
        returns (uint256)
    {
        return bettableId;
    }

    function getOwner()
        external
        view
        override
        onlyOwnerOrPerm(IAdmin.Permission.BET_ADMIN)
        returns (address)
    {
        return owner;
    }

    function setOwner(address _owner) external override onlyOwner {
        owner = _owner;
        bettableManager.bettableReadInstance(bettableId).updateBet(this);
    }

    function getOutcome()
        external
        view
        override
        onlyOwnerOrPerm(IAdmin.Permission.BET_ADMIN)
        returns (IBettable.Outcome)
    {
        return outcome;
    }

    function setOutcome(IBettable.Outcome _outcome)
        external
        override
        onlyOwner
        outcomeFinal(_outcome)
    {
        outcome = _outcome;
        bettableManager.bettableReadInstance(bettableId).updateBet(this);
    }

    function getDeposit() external view override onlyOwner returns (uint256) {
        return deposit;
    }

    function withdraw() external override onlyOwner notPaid notWithdrawn {
        // #TODO what if there is not enough to pay out?
        // #TODO what if the division causes a casting error (uint256 -> ufixed)?
        // #TODO apply a "withdrawing fee"
        (bool success, ) = owner.call{value: deposit * (1 - fee / 1000)}("");
        require(success, "Failed to transfer tokens");
        deposit = 0;
        status = Status.WITHDRAWN;
        bettableManager.bettableReadInstance(bettableId).deleteBet(this);
    }

    function payout()
        external
        override
        onlyPerm(IAdmin.Permission.BET_PAY)
        outcomeFinal(
            bettableManager.bettableReadInstance(bettableId).getOutcome()
        )
        notPaid
    {
        IBettable bettable = bettableManager.bettableReadInstance(bettableId);
        // #TODO what if there is not enough to pay out?
        // #TODO what if the division causes a casting error (uint256 -> ufixed)?
        // Bet failed
        if (bettable.getOutcome() != outcome) {
            status = Status.FAILED;
            return;
        }
        // Bet success
        uint256 toPay = (bettable.getOdds(outcome) / 1000) *
            deposit *
            (1 - fee / 1000);
        (bool success, ) = owner.call{value: toPay}("");
        require(success, "Failed to transfer tokens");
        deposit = 0;
        status = Status.PAID;
        bettableManager.bettableReadInstance(bettableId).updateBet(this);
    }

    function boost(uint256 _amount)
        external
        override
        onlyOwner
        notWithdrawn
        notPaid
    {
        // #TODO apply a "boosting fee"
        require(_amount > 0, "Cannot boost by 0 tokens");
        (bool success, ) = address(this).call{
            value: _amount * (1 + fee / 1000)
        }("");
        require(success, "Failed to transfer tokens");
        deposit += _amount;
        bettableManager.bettableReadInstance(bettableId).updateBet(this);
    }

    function lower(uint256 _amount)
        external
        override
        onlyOwner
        notWithdrawn
        notPaid
    {
        // #TODO what if there is not enough to pay out?
        // #TODO what if the division causes a casting error (uint256 -> ufixed)?
        require(_amount < deposit, "Cannot lower more than deposited");
        (bool success, ) = owner.call{value: _amount * (1 - fee / 1000)}("");
        require(success, "Failed to transfer tokens");
        deposit -= _amount;
        bettableManager.bettableReadInstance(bettableId).updateBet(this);
    }

    function getStatus()
        external
        view
        override
        onlyOwnerOrPerm(IAdmin.Permission.BET_ADMIN)
        returns (Status)
    {
        return status;
    }

    function setStatus(Status _status)
        external
        override
        onlyPerm(IAdmin.Permission.BET_ADMIN)
    {
        status = _status;
        bettableManager.bettableReadInstance(bettableId).updateBet(this);
    }

    function result()
        external
        view
        onlyOwnerOrPerm(IAdmin.Permission.BET_ADMIN)
        returns (Status)
    {
        IBettable bettable = bettableManager.bettableReadInstance(bettableId);
        if (bettable.getOutcome() != outcome) {
            return Status.FAILED;
        }
        return Status.PENDING_PAYMENT;
    }
}
