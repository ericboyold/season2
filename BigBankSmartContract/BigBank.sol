// SPDX-License-Identifier: MIT
pragma solidity ^0.8;

import "./Bank.sol";

contract BigBank is Bank {
    address public immutable owner;

    /// @notice Sets the owner of the BigBank contract to the deployer.
    constructor () {
        owner = msg.sender;
    }

    /// @notice Ensures that the deposited amount is greater than 0.001 ether.
    /// @dev Used as a modifier on deposit-related functions.
    modifier depositAmountGreaterThan001Ether() {
        require(msg.value > 0.001 ether, "Deposit amount must be greater than 0.001 ether");
        _;
    }

    /// @notice Allows a user to deposit Ether into the bank, enforcing a minimum amount.
    /// @dev Overrides the base Bank deposit function and applies the minimum deposit modifier.
    function deposit() external payable override depositAmountGreaterThan001Ether {
        _handleDeposit();
    }

    /// @notice Fallback function that accepts Ether deposits greater than 0.001 ether.
    /// @dev Overrides the base Bank receive function and applies the minimum deposit modifier.
    receive() external payable override depositAmountGreaterThan001Ether {
        _handleDeposit();
    }

    /// @notice Transfers the admin role of the underlying Bank to a new address.
    /// @dev Can only be called by the owner of the BigBank contract.
    /// @param newAdmin The address that will become the new admin.
    function transferAdmin(address newAdmin) external {
        require(msg.sender == owner, "Only owner can transfer admin");
        require(newAdmin != address(0), "New admin cannot be the zero address");
        admin = newAdmin;
    }
}