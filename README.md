## Solidity Practice Projects – Season 2

This repository contains a collection of small Solidity projects that demonstrate common Ethereum smart‑contract patterns and language features.  
All examples target Solidity `^0.8` and are intended for learning and experimentation, **not** for production use.

### Directory Overview

- **ABI_practise/**
  - Demonstrates how to work with the Solidity ABI:
    - `ABIEncoder` and `ABIDecoder` for encoding/decoding values with `abi.encode` / `abi.decode`.
    - `FunctionSelector` for reading or computing function selectors.
- **BankSmartContract/**
  - A simple on‑chain bank:
    - Accepts Ether deposits via `deposit()` and `receive()`.
    - Tracks per‑user balances in a `deposits` mapping.
    - Maintains a leaderboard of the top three depositors.
    - Allows the admin to withdraw the contract balance.
- **BigBankSmartContract/**
  - A more advanced version of the bank example with:
    - An interface `IBank`.
    - A base `Bank` implementation that tracks deposits and top users.
    - A `BigBank` contract that adds ownership and a minimum‑deposit constraint.
    - An `Admin` helper contract for administrative withdrawals.
  - See `BigBankSmartContract/README.md` for a detailed explanation and usage flow.
- **CallAndDelegatecallAndStaticcall/**
  - Shows different low‑level call patterns between contracts:
    - `call` to invoke a payable function and forward Ether, with error handling.
    - `delegatecall` to execute another contract’s code in the caller’s storage context.
    - `staticcall` to perform read‑only calls and decode return values.

### Getting Started

1. **Prerequisites**
   - Any recent Solidity toolchain such as:
     - Hardhat, Foundry, Truffle, or Remix.
   - Node.js is recommended if you plan to use Hardhat or Truffle.

2. **Compile & Run (example workflows)**
   - **Remix (easiest for quick experiments)**
     - Copy the contracts from a subdirectory into Remix.
     - Select compiler version `^0.8.x` and compile.
     - Deploy and interact with the contracts from the Remix UI.
   - **Local frameworks (Hardhat/Foundry/Truffle)**
     - Create a new project with your preferred framework.
     - Copy the desired `.sol` files into the project’s `contracts/` folder.
     - Use the framework’s standard commands to compile, deploy, and test.

### Notes

- These contracts are **for educational purposes only** and have **not been audited**.
- Do **not** deploy them to mainnet or use them to manage real funds without a thorough security review and appropriate modifications.

