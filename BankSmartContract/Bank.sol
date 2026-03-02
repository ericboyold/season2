// SPDX-License-Identifier: MIT
pragma solidity ^0.8;

contract Bank {
    address public immutable admin;
    mapping (address user => uint256 amount) public deposits;
    address[3] public topUsers;
    uint8 public constant TOP_USERS_COUNT = 3;

    constructor () {
        admin = msg.sender;
    }

    receive() external payable { 
        _handleDeposit();
    }

    function deposit() external payable  {
        _handleDeposit();
    }
    
    function _handleDeposit() internal {
        deposits[msg.sender] += msg.value;
        updateTopUsers(msg.sender);
    }
    
    function updateTopUsers(address user) internal {
        uint256 userDeposit = deposits[user];

        // Check if the user is already in the top users list
        for (uint256 i = 0; i < TOP_USERS_COUNT; i++) {
            if (topUsers[i] == user) {
                // Update the deposit amount for the existing user
                _updateRanking();
                return;
            }
        }   

        for (uint8 i = 0; i < TOP_USERS_COUNT; i++) {
            address currentAddr = topUsers[i];
            // 如果位置为空或者新存款人的存款金额大于当前位置的存款金额
            if (currentAddr == address(0) || userDeposit > deposits[currentAddr]) {
                for (uint8 j = 2; j > i; j--) {
                    topUsers[j] = topUsers[j-1];
                }
                topUsers[i] = user;
                break;
            }
        }    
    }

    function _updateRanking() internal {
        for (uint8 i = 1; i < TOP_USERS_COUNT; i++) {
            address key = topUsers[i];
            if (key == address(0)) continue; // 跳过空地址
            
            uint keyDeposit = deposits[key];
            int8 j = int8(i) - 1;
            
            while (j >= 0 && (topUsers[uint8(j)] == address(0) || deposits[topUsers[uint8(j)]] < keyDeposit)) {
                topUsers[uint8(j + 1)] = topUsers[uint8(j)];
                j--;
            }
            
            topUsers[uint8(j + 1)] = key;
        }
    }

    function getTopUsers() external view returns (address[3] memory, uint256[3] memory) {
        uint256[3] memory amounts;
        for (uint8 i = 0; i < TOP_USERS_COUNT; i++) {
            amounts[i] = deposits[topUsers[i]];
        }
        return (topUsers, amounts);
    }

    function withdraw() external {
        require(msg.sender == admin, "Only admin can withdraw");
        uint256 balance = address(this).balance;
        require(balance > 0, "No balance to withdraw");
        (bool success, ) = admin.call{value: balance}("");
        require(success, "Withdrawal failed");
    }
}