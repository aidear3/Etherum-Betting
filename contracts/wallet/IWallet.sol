// SPDX-License-Identifier: ISC
pragma solidity ^0.8.0;

/**
 * Represents the central DApp wallet.
 */
interface IWallet {
    /**
     * Used to deposit tokens for paying successful bets.
     */
    function deposit() external payable;

    /**
     * Used to withdraw tokens to addresses of owners/shareholders.
     */
    function withdraw(uint256 _amount, address payable _receiver) external;

    /**
     * Wallet balance.
     */
    function balance() external view returns (uint256);
}
