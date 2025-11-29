# Validator Logging Summary

This document summarizes the trace logging added to all Aiken validator files in the EquiBaskets protocol.

## Overview

Comprehensive `trace` statements have been added to all validators to aid in debugging and monitoring on-chain execution. These logs will appear in transaction validation output and can help identify where validation succeeds or fails.

## Files Modified

### 1. `hello_word.ak`
**Logging Added:**
- Mint validation entry point
- Token extraction and validation steps
- Mint vs Burn operation identification
- Spend validation entry point
- Fallback handler

**Key Trace Points:**
- `"hello_world.mint: Starting mint validation"`
- `"Mint operation: Validating token creation"`
- `"Burn operation: Allowing token burn"`
- `"hello_world.spend: Validating spend with redeemer"`

---

### 2. `basket_factory.ak`
**Logging Added:**
- Spend validation entry point
- Datum extraction
- CreateBasket operation with weight, asset, ID, and signature validation
- UpdateBasket operation with creator verification and weight validation
- Fallback handler

**Key Trace Points:**
- `"basket_factory.spend: Starting validation"`
- `"CreateBasket: Validating new basket creation"`
- `"Weight validation completed"`
- `"UpdateBasket: Validating basket weight update"`
- `"Continuing output validated"`

---

### 3. `basket_token_policy.ak`
**Logging Added:**
- Both parameterized and reference-based validators
- Mint validation entry points
- Vault input verification
- Vault datum extraction
- Token name and quantity validation
- MintTokens vs BurnTokens action validation
- Fallback handlers

**Key Trace Points:**
- `"basket_token_policy.mint: Starting validation"`
- `"Finding vault input that authorizes this mint/burn"`
- `"Verifying input is from vault script"`
- `"MintTokens action: Verifying positive quantity"`
- `"BurnTokens action: Verifying negative quantity"`

---

### 4. `mock_oracle.ak`
**Logging Added:**
- Spend validation entry point
- Datum extraction
- UpdatePrices operation with admin verification and price validation
- ReadPrice rejection (must use reference inputs)
- Fallback handler

**Key Trace Points:**
- `"mock_oracle.spend: Starting validation"`
- `"UpdatePrices: Validating price update operation"`
- `"Admin signature verification completed"`
- `"Price validation completed"`
- `"ReadPrice: Rejecting consumption attempt"`

---

### 5. `vault.ak` (Most Comprehensive)
**Logging Added:**

#### Entry Point:
- `"vault.spend: Starting vault validation"`
- `"Vault datum extracted successfully"`

#### Deposit Operation:
- `"vault.Deposit: Starting deposit validation"`
- Owner signature verification
- Amount validation
- Continuing vault output validation

#### Withdraw Operation:
- `"vault.Withdraw: Starting withdrawal validation"`
- Owner signature verification
- Amount validation
- Oracle and basket datum retrieval
- Basket price calculation
- Collateral health check
- Minimum collateral verification
- Output validation

#### Mint Operation:
- `"vault.Mint: Starting mint validation"`
- Owner signature verification
- Amount validation
- Oracle and basket datum retrieval
- Basket price calculation
- Collateralization ratio check
- Token minting verification
- Output validation

#### Burn Operation:
- `"vault.Burn: Starting burn validation"`
- Owner signature verification
- Amount validation
- Token burning verification
- Output validation

#### Liquidate Operation:
- `"vault.Liquidate: Starting liquidation validation"`
- Oracle and basket datum retrieval
- Basket price calculation
- Undercollateralization check
- Token burning verification
- Liquidator payment verification

#### Fallback:
- `"vault: Unsupported script purpose"`

---

## Benefits of Added Logging

1. **Debugging**: Quickly identify which validation step fails during transaction execution
2. **Monitoring**: Track the flow of execution through complex validators
3. **Auditing**: Understand the sequence of checks performed
4. **Development**: Easier to test and verify validator behavior
5. **Production**: Better error messages for users when transactions fail

## Usage

When a transaction fails validation, the trace logs will appear in the error output, showing exactly where the validation stopped. This makes it much easier to:
- Identify incorrect redeemer values
- Spot missing reference inputs
- Verify signature requirements
- Debug collateralization issues
- Track oracle price lookups

## Notes

- All trace statements use the `@"message"` syntax for ByteArray literals
- Trace messages are descriptive and indicate the validator, operation, and step
- No sensitive data is logged (only validation checkpoints)
- Logging adds minimal overhead to validator execution
- The `types.ak` file was not modified as it contains only type definitions and helper functions

## Example Trace Output

When a vault mint operation executes, you would see traces like:
```
trace: vault.spend: Starting vault validation
trace: Vault datum extracted successfully
trace: vault.Mint: Starting mint validation
trace: Owner signature verified
trace: Mint amount validated
trace: Oracle datum retrieved
trace: Basket datum retrieved
trace: Basket price calculated
trace: Checking collateralization ratio
trace: Collateralization check completed
trace: Token minting verified in transaction
trace: Continuing vault output found
trace: Mint output validation completed
```

This sequential output makes it immediately clear which step succeeded and where any failure occurred.
