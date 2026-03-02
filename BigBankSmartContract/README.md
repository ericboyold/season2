## BigBankSmartContract

BigBankSmartContract is a simple on-chain banking example written in Solidity.  
It demonstrates how to:
- Accept and track user deposits
- Maintain a ranking of the top depositors
- Enforce a minimum deposit amount in a derived contract
- Separate administrative control from user operations

### Contracts Overview

- **IBank**
  - An interface that defines the core banking functions:
    - `deposit()` – deposit Ether into the bank
    - `getTopUsers()` – read the top three depositors and their balances
    - `withdraw()` – withdraw the entire bank balance to the admin

- **Bank**
  - Base implementation of the `IBank` interface.
  - Tracks user balances in the `deposits` mapping.
  - Maintains an array `topUsers` with the top three depositors.
  - Exposes:
    - `deposit()` and `receive()` to accept Ether and update rankings
    - `getTopUsers()` to read the top users and their deposit amounts
    - `withdraw()` for the admin to withdraw the full contract balance

- **BigBank**
  - Inherits from `Bank` and introduces additional constraints and ownership:
    - `owner` – immutable owner set at deployment time.
  - Adds:
    - `depositAmountGreaterThan001Ether` modifier to enforce a minimum deposit of more than `0.001 ether`
    - Overridden `deposit()` and `receive()` that apply the minimum deposit check
    - `transferAdmin()` to allow the `owner` to change the `admin` address of the base `Bank`

- **Admin**
  - A separate administrative helper contract.
  - Stores an immutable `admin` address set at deployment (the deployer).
  - Can:
    - `adminWithdraw(IBank bank)` – call `withdraw()` on a `Bank` contract to move all of its Ether into this `Admin` contract
    - `withdrawToOwner()` – withdraw all Ether from the `Admin` contract to the `admin` address

### Basic Usage Flow

1. **Deploy `Bank` or `BigBank`**
   - The deployer becomes the initial `admin` (in `Bank`) and/or `owner` (in `BigBank`).

2. **Users deposit Ether**
   - Call `deposit()` or send Ether directly to the `receive()` function.
   - In `BigBank`, each deposit must be greater than `0.001 ether`.
   - The contract updates user balances and re-sorts the top three depositors.

3. **Read rankings**
   - Call `getTopUsers()` to obtain:
     - An array of top user addresses
     - A parallel array of their deposit amounts

4. **Administrative withdrawal**
   - For `Bank`: the `admin` can call `withdraw()` to move the full contract balance to the `admin` address.
   - With `Admin`: the `admin` can:
     - Call `adminWithdraw(bank)` to pull all Ether out of a `Bank` contract into the `Admin` contract.
     - Then call `withdrawToOwner()` to move Ether from the `Admin` contract to the `admin` address.

### Notes

- Solidity version: `pragma solidity ^0.8;`
- These contracts are for educational/demo purposes and are **not audited**.  
  Do **not** use them as-is in production environments without proper security review.

