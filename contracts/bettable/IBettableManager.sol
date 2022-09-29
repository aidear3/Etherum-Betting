// SPDX-License-Identifier: ISC
pragma solidity ^0.8.0;

import "../bet/IBet.sol";

/**
 * Manages bettables.
 */
interface IBettableManager {
    /**
     * Creates a new bettable. Only if sufficient perms.
     */
    function bettableCreate(
        uint256 _outcomesDefined,
        IBettable.Outcome[] calldata _outcomes,
        uint256[] calldata _deadlines,
        uint256[] calldata _odds,
        string memory _info
    ) external;

    /**
     * Reads a bettable.
     */
    function bettableRead(uint256 _id)
        external
        view
        returns (
            uint256 _bettableId,
            uint256 _outcomesDefined,
            IBettable.Outcome[] memory _outcomes,
            uint256[] memory _deadlines,
            uint256[] memory _odds,
            string memory _info
        );

    /**
     * Reads a bettable as an object.
     */
    function bettableReadObject(uint256 _id) external view returns (IBettable);

    /**
     * Reads bettable IDs.
     */
    function bettableReadIds()
        external
        view
        returns (uint256[] memory _bettableIds);

    /**
     * Updates an existing bettable. Only if sufficient perms.
     */
    function bettableUpdate(
        uint256 _id,
        uint256 _outcomesDefined,
        IBettable.Outcome[] calldata _outcomes,
        uint256[] calldata _deadlines,
        uint256[] calldata _odds,
        string calldata _info
    ) external;

    /**
     * Deletes a bettable. Only if sufficient perms.
     */
    function bettableDelete(uint256 _id) external;
}
