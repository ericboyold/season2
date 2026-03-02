// SPDX-License-Identifier: MIT
pragma solidity ^0.8;

interface IBank {
    /// @notice Allows a user to deposit Ether into the bank.
    function deposit() external payable;

    /// @notice Returns the top three depositors and their respective balances.
    /// @return An array of the top three user addresses and an array of their deposit amounts.
    function getTopUsers() external view returns (address[3] memory, uint256[3] memory);

    /// @notice Withdraws the entire balance of the bank contract to the admin address.
    function withdraw() external;
}
