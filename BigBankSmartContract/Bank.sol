// SPDX-License-Identifier: MIT
pragma solidity ^0.8;

import "./IBank.sol";
contract Bank is IBank {
    address public admin;
    mapping (address user => uint256 amount) public deposits;
    address[3] public topUsers;
    uint8 constant TOP_USERS_COUNT = 3;
    
    /// @notice Sets the initial admin to the deployer of the contract.
    constructor () {
        admin = msg.sender;
    }

    /// @notice Fallback function that accepts Ether and treats it as a deposit.
    receive() external payable {
        _handleDeposit();
    }

    /// @notice Allows a user to deposit Ether into the bank.
    /// @dev Updates the user's balance and the top users ranking.
    function deposit() external payable {
        _handleDeposit();
    }

    /// @notice Handles the internal logic for processing a deposit.
    /// @dev Increases the sender's deposit balance and updates the ranking of top users.
    function _handleDeposit() internal {
        deposits[msg.sender] += msg.value;
        updateTopUsers(msg.sender);
    }

    /// @notice Updates the list of top users based on the given user's total deposits.
    /// @param user The address of the user whose deposit has changed.
    function updateTopUsers(address user) internal {
        uint256 userDeposit = deposits[user];
        for (uint256 i = 0; i < TOP_USERS_COUNT; i++) {
            if (topUsers[i] == user) {
                _updateRanking();
                return;
            }
        }

        for (uint8 i = 0; i < TOP_USERS_COUNT; i++) {
            address currentAddr = topUsers[i];
            if (currentAddr == address(0) || userDeposit > deposits[currentAddr]) {
                for (uint8 j = 2; j > i; j--) {
                    topUsers[j] = topUsers[j-1];
                }
                topUsers[i] = user;
                break;
            }
        }
    }

    /// @notice Re-sorts the top users array in descending order of deposit amount.
    /// @dev Uses an insertion sort-like algorithm to keep the ranking array ordered.
    function _updateRanking() internal {
        for (uint8 i = 1; i < TOP_USERS_COUNT; i++) {
            address key = topUsers[i];
            if (key == address(0)) continue; // skip empty addresses
            
            uint keyDeposit = deposits[key];
            int8 j = int8(i) - 1;
            
            while (j >= 0 && (topUsers[uint8(j)] == address(0) || deposits[topUsers[uint8(j)]] < keyDeposit)) {
                topUsers[uint8(j + 1)] = topUsers[uint8(j)];
                j--;
            }
            
            topUsers[uint8(j + 1)] = key;
        }
    }

    /// @notice Returns the addresses of the top three depositors and their corresponding balances.
    /// @return An array of the top three user addresses and an array of their deposit amounts.
    function getTopUsers() external view returns (address[3] memory, uint[3] memory) {
        uint[3] memory amounts;
        for (uint8 i = 0; i < TOP_USERS_COUNT; i++) {
            amounts[i] = deposits[topUsers[i]];
        }
        return (topUsers, amounts);
    }

    /// @notice Withdraws the entire balance of the bank contract to the admin address.
    /// @dev Only the admin can call this function. Reverts if the balance is zero or the transfer fails.
    function withdraw() external {
        require(msg.sender == admin, "Only admin can withdraw");
        uint256 balance = address(this).balance;
        require(balance > 0, "No balance to withdraw");
        (bool success, ) = admin.call{value: balance}("");
        require(success, "Withdrawal failed");
    }
}