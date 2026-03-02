// SPDX-License-Identifier: MIT
pragma solidity ^0.8;

import "./IBank.sol";

contract Admin {
    address public immutable admin;

    /// @notice Sets the admin to the address that deploys the contract.
    constructor () {
        admin = msg.sender;
    }

    /// @notice Accepts Ether transfers sent directly to this contract.
    receive() external payable {}

    /// @notice Withdraws all Ether from the given Bank contract to this Admin contract.
    /// @dev Can only be called by the admin address stored in this contract.
    /// @param bank The Bank contract instance from which to withdraw funds.
    function adminWithdraw(IBank bank) external {
        require(msg.sender == admin, "Only admin can withdraw");
        bank.withdraw();
    }

    /// @notice Withdraws all Ether held by this contract to the admin address.
    /// @dev Reverts if the caller is not the admin or if the balance is zero.
    function withdrawToOwner() external {
        require(msg.sender == admin, "Only admin can withdraw");
        uint256 balance = address(this).balance;
        require(balance > 0, "No balance to withdraw");
        (bool success, ) = admin.call{value: balance}("");
        require(success, "Withdrawal failed");
    }
}