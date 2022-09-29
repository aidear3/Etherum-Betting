// SPDX-License-Identifier: ISC
pragma solidity ^0.8.0;

import "./Bettable.sol";
import "../IBettableManager.sol";
import "../../admin/IAdmin.sol";
import "../../admin/IAdminManager.sol";
import "../../admin/Restricted.sol";

/**
 * Standard implementation of IBettableManager.
 */
contract BettableManager is IBettableManager, Restricted {
    // AdminManager component.
    IAdminManager private adminManager;

    // Unique identifier of the bettable.
    uint256 private bettablesCount;

    // Who created the bettable.
    mapping(uint256 => IBettable) private bettables;

    constructor(IAdminManager _adminManager) Restricted(_adminManager) {
        adminManager = _adminManager;
    }

    /**
     * Require the bettable with given ID to be defined.
     */
    modifier bettableExists(uint256 _id) {
        require(bettables[_id].getId() == _id, "Bettable event does not exist");
        _;
    }

    function bettableCreate(
        uint256 _outcomesDefined,
        IBettable.Outcome[] calldata _outcomes,
        uint256[] calldata _deadlines,
        uint256[] calldata _odds,
        string memory _info
    ) external override onlyPerm(IAdmin.Permission.BETTABLE_CREATE) {
        IBettable bettable = new Bettable(adminManager, ++bettablesCount);
        for (uint i = 0; i < _outcomesDefined; i++) {
            bettable.setDeadline(_outcomes[i], _deadlines[i]);
            bettable.setOdds(_outcomes[i], _odds[i]);
        }
        bettable.setInfo(_info);
        bettables[bettablesCount] = bettable;
    }

    function bettableRead(uint256 _id)
        external
        view
        override
        bettableExists(_id)
        onlyPerm(IAdmin.Permission.BETTABLE_READ)
        returns (
            uint256 _bettableId,
            uint256 _outcomesDefined,
            IBettable.Outcome[] memory _outcomes,
            uint256[] memory _deadlines,
            uint256[] memory _odds,
            string memory _info
        )
    {
        uint256 outcomesDefined = 0;
        // #TODO number of members should be plucked from Outcome length!
        IBettable.Outcome[] memory outcomes = new IBettable.Outcome[](4);
        uint256[] memory deadlines = new uint256[](4);
        uint256[] memory odds = new uint256[](4);
        uint i = 0;
        uint deadline = 0;
        uint odd = 0;
        while (i < 4) {
            // #TODO this can be done better!
            IBettable.Outcome o;
            if (i == 0) o = IBettable.Outcome.NOT_AVAILABLE;
            else if (i == 1) o = IBettable.Outcome.PLAYER_A;
            else if (i == 2) o = IBettable.Outcome.PLAYER_B;
            else if (i == 3) o = IBettable.Outcome.PLAYER_A;
            else revert("IBettable.Outcome at index 4 not defined");
            deadline = bettables[_id].getDeadline(o);
            odd = bettables[_id].getOdds(o);
            if (deadline != 0 && odd != 0) {
                outcomes[i] = o;
                deadlines[i] = deadline;
                odds[i] = odd;
                outcomesDefined++;
            }
        }
        return (
            bettables[_id].getId(),
            outcomesDefined,
            outcomes,
            deadlines,
            odds,
            bettables[_id].getInfo()
        );
    }

    function bettableReadInstance(uint256 _id)
        external
        view
        override
        bettableExists(_id)
        onlyPerm(IAdmin.Permission.BETTABLE_READ)
        returns (IBettable)
    {
        return bettables[_id];
    }

    function bettableReadIds()
        external
        view
        override
        onlyPerm(IAdmin.Permission.BETTABLE_READ)
        returns (uint256[] memory _bettableIds)
    {
        // #TODO in the future we may use a different ID function, hence why
        // we have syntactic sugar here
        uint256[] memory bettableIds = new uint256[](bettablesCount);
        for (uint i = 0; i < bettablesCount; i++) {
            bettableIds[i] = i;
        }
        return bettableIds;
    }

    function bettableUpdate(
        uint256 _id,
        uint256 _outcomesDefined,
        IBettable.Outcome[] calldata _outcomes,
        uint256[] calldata _deadlines,
        uint256[] calldata _odds,
        string calldata _info
    )
        external
        override
        onlyPerm(IAdmin.Permission.BETTABLE_EDIT)
        bettableExists(_id)
    {
        // #TODO check if object is updated only in memory or actually in storage!
        for (uint i = 0; i < _outcomesDefined; i++) {
            // #TODO this can be done better!
            IBettable.Outcome o = _outcomes[i];
            uint256 deadline = _deadlines[i];
            uint256 odd = _odds[i];
            bettables[_id].setDeadline(o, deadline);
            bettables[_id].setOdds(o, odd);
        }
        bettables[_id].setInfo(_info);
    }

    function bettableDelete(uint256 _id)
        external
        override
        onlyPerm(IAdmin.Permission.BETTABLE_REMOVE)
        bettableExists(_id)
    {
        // #TODO this messes with the IDs!
        delete bettables[_id];
    }
}
