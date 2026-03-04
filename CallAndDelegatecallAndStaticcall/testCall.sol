// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Callee {
    uint256 value;

    function getValue() public view returns (uint256) {
        return value;
    }

    function setValue(uint256 value_) public payable {
        require(msg.value > 0);
        value = value_;
    }
}

// Use the call method to invoke Callee's setValue function with 1 Ether.
// If the call fails, revert the transaction with the error message "call function failed".
// If the call succeeds, return true.
contract Caller {
    function callSetValue(address callee, uint256 value) public returns (bool) {
        (bool success, ) = callee.call{value: 1 ether}(
            abi.encodeWithSignature("setValue(uint256)", value)
        );
        require(success, "call function failed");
        return success;
    }
}
