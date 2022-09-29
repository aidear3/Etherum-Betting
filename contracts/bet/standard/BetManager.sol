// SPDX-License-Identifier: ISC
pragma solidity ^0.8.0;

import "../../admin/IAdminManager.sol";
import "../../admin/Restricted.sol";
import "../../bettable/IBettableManager.sol";
import "../IBetManager.sol";
import "./Bet.sol";

/**
 * Standard implementation of Bet Manager component.
 */
contract BetManager is IBetManager, Restricted {
    // Admin Manager component.
    IAdminManager private adminManager;

    // Bettable Manager component.
    IBettableManager private bettableManager;

    // Count of bets placed.
    uint256 private betsCount;

    // Bet objects.
    mapping(uint256 => IBet) private bets;

    // Fee for actions.
    uint256 private fee;

    constructor(
        IAdminManager _adminManager,
        IBettableManager _bettableManager,
        uint256 _fee
    ) Restricted(_adminManager) {
        adminManager = _adminManager;
        bettableManager = _bettableManager;
        fee = _fee;
    }

    /**
     * Requires the bet to exist.
     */
    modifier betExists(uint256 _id) {
        require(bets[_id].getId() == _id, "Bet not placed");
        _;
    }

    /**
     * Requires transaction to have some ETH.
     */
    modifier valuePositive() {
        require(
            msg.value > 0.00001 ether,
            "Minimum transaction value: 0.00001 ether"
        );
        _;
    }

    function betPlace(uint256 _bettableId, IBettable.Outcome _outcome)
        external
        payable
        override
        onlyPerm(IAdmin.Permission.BET_PLACE)
        valuePositive
    {
        // #TODO dynamic fees - for example, based on user subscription
        IBet bet = new Bet(
            adminManager,
            bettableManager,
            betsCount,
            _bettableId,
            _outcome,
            msg.value,
            fee,
            IBet.Status.NOT_AVAILABLE
        );
        bets[betsCount] = bet;
        betsCount++;
    }

    function betUpdate(uint256 _id, address _owner)
        external
        override
        betExists(_id)
        onlyPerm(IAdmin.Permission.BET_EDIT)
    {
        bets[_id].setOwner(_owner);
    }

    function betUpdate(uint256 _id, IBettable.Outcome _outcome)
        external
        override
        betExists(_id)
        onlyPerm(IAdmin.Permission.BET_EDIT)
    {
        bets[_id].setOutcome(_outcome);
    }

    function betResult(uint256 _id)
        external
        view
        override
        betExists(_id)
        onlyPerm(IAdmin.Permission.BET_READ)
        returns (IBet.Status)
    {
        return bets[_id].result();
    }

    function betWithdraw(uint256 _id)
        external
        override
        betExists(_id)
        onlyPerm(IAdmin.Permission.BET_WITHDRAW)
    {
        bets[_id].withdraw();
    }

    function betPayout(uint256 _id)
        external
        override
        betExists(_id)
        onlyPerm(IAdmin.Permission.BET_PAY)
    {
        bets[_id].payout();
    }

    function betBoost(uint256 _id)
        external
        payable
        override
        betExists(_id)
        onlyPerm(IAdmin.Permission.BET_BOOST)
        valuePositive
    {
        bets[_id].boost(msg.value);
    }

    function betLower(uint256 _id, uint256 _amount)
        external
        override
        betExists(_id)
        onlyPerm(IAdmin.Permission.BET_LOWER)
    {
        bets[_id].lower(_amount);
    }

    receive() external payable {}

    fallback() external payable {}
}
