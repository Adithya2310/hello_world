# EquiBaskets - Test Report

## Test Execution Summary

**Test Run Date:** Thursday, November 27, 2025

**Aiken Version:** v1.1.19+e525483

**Build Status:** ✅ Passed

---

## Test Results by Module

### 1. basket_factory (7 tests)

| Test | Status | Memory | CPU |
|------|--------|--------|-----|
| test_tech_basket_weights | ✅ PASS | 18.09 K | 5.54 M |
| test_defi_basket_weights | ✅ PASS | 18.09 K | 5.54 M |
| test_balanced_basket_weights | ✅ PASS | 18.09 K | 5.54 M |
| test_basket_has_id | ✅ PASS | 5.72 K | 1.60 M |
| test_basket_has_assets | ✅ PASS | 13.81 K | 4.04 M |
| test_invalid_weights_over | ✅ PASS | 10.88 K | 3.13 M |
| test_invalid_weights_under | ✅ PASS | 10.88 K | 3.13 M |

**Result:** 7 tests | 7 passed | 0 failed

---

### 2. basket_token_policy (2 tests)

| Test | Status | Memory | CPU |
|------|--------|--------|-----|
| test_mint_action_is_positive | ✅ PASS | 2.06 K | 598.96 K |
| test_burn_action_is_negative | ✅ PASS | 2.06 K | 598.96 K |

**Result:** 2 tests | 2 passed | 0 failed

---

### 3. mock_oracle (7 tests)

| Test | Status | Memory | CPU |
|------|--------|--------|-----|
| test_validate_prices_valid | ✅ PASS | 10.98 K | 3.05 M |
| test_validate_prices_invalid_zero | ✅ PASS | 9.92 K | 2.75 M |
| test_validate_prices_invalid_negative | ✅ PASS | 6.09 K | 1.55 M |
| test_validate_prices_empty | ✅ PASS | 3.33 K | 645.09 K |
| test_default_prices_btc | ✅ PASS | 21.21 K | 6.06 M |
| test_default_prices_ada | ✅ PASS | 32.89 K | 9.43 M |
| test_liquidation_prices_higher | ✅ PASS | 38.84 K | 11.17 M |

**Result:** 7 tests | 7 passed | 0 failed

---

### 4. tests/integration (34 tests)

| Test | Status | Memory | CPU |
|------|--------|--------|-----|
| test_create_basket_valid_weights | ✅ PASS | 38.21 K | 11.56 M |
| test_create_basket_all_samples_valid | ✅ PASS | 56.19 K | 17.34 M |
| test_basket_unique_ids | ✅ PASS | 22.15 K | 6.78 M |
| test_oracle_default_prices_valid | ✅ PASS | 35.75 K | 10.78 M |
| test_oracle_has_required_assets | ✅ PASS | 68.73 K | 19.43 M |
| test_oracle_btc_price | ✅ PASS | 24.10 K | 7.02 M |
| test_oracle_ada_price | ✅ PASS | 35.78 K | 10.40 M |
| test_calculate_tech_basket_price | ✅ PASS | 62.50 K | 18.77 M |
| test_calculate_defi_basket_price | ✅ PASS | 89.76 K | 26.64 M |
| test_calculate_balanced_basket_price | ✅ PASS | 63.91 K | 19.11 M |
| test_vault_deposit_creates_position | ✅ PASS | 13.84 K | 4.19 M |
| test_vault_collateral_ratio_150_percent | ✅ PASS | 200.0 | 16.1 K |
| test_vault_overcollateralized_mint | ✅ PASS | 200.0 | 16.1 K |
| test_vault_undercollateralized_mint_fails | ✅ PASS | 801.0 | 188.14 K |
| test_mint_with_tech_basket_price | ✅ PASS | 63.71 K | 19.26 M |
| test_burn_reduces_minted_tokens | ✅ PASS | 6.51 K | 2.01 M |
| test_withdraw_after_burn | ✅ PASS | 6.11 K | 1.84 M |
| test_partial_withdraw_maintains_ratio | ✅ PASS | 200.0 | 16.1 K |
| test_liquidation_prices_higher_than_default | ✅ PASS | 39.64 K | 11.53 M |
| test_position_becomes_undercollateralized | ✅ PASS | 118.93 K | 35.84 M |
| test_liquidation_triggers_on_price_increase | ✅ PASS | 801.0 | 188.14 K |
| test_liquidation_value_calculation | ✅ PASS | 200.0 | 16.1 K |
| test_liquidation_bonus_for_liquidator | ✅ PASS | 200.0 | 16.1 K |
| test_vault_state_after_deposit | ✅ PASS | 6.28 K | 1.89 M |
| test_vault_state_after_mint | ✅ PASS | 6.51 K | 2.01 M |
| test_vault_state_after_burn | ✅ PASS | 6.51 K | 2.01 M |
| test_vault_state_after_withdraw | ✅ PASS | 6.28 K | 1.89 M |
| test_vault_closed_after_full_burn_and_withdraw | ✅ PASS | 11.11 K | 3.33 M |
| test_minimum_collateral_requirement | ✅ PASS | 5.88 K | 1.72 M |
| test_zero_minted_allows_full_withdraw | ✅ PASS | 200.0 | 16.1 K |
| test_cannot_mint_with_zero_collateral | ✅ PASS | 801.0 | 188.14 K |
| test_price_precision_maintained | ✅ PASS | 200.0 | 16.1 K |
| test_full_mint_burn_cycle | ✅ PASS | 4.50 K | 1.08 M |
| test_multiple_deposit_mint_cycles | ✅ PASS | 3.10 K | 708.24 K |

**Result:** 34 tests | 34 passed | 0 failed

---

### 5. types (9 tests)

| Test | Status | Memory | CPU |
|------|--------|--------|-----|
| test_price_precision | ✅ PASS | 200.0 | 16.1 K |
| test_collateral_ratio | ✅ PASS | 200.0 | 16.1 K |
| test_sum_weights | ✅ PASS | 13.61 K | 4.06 M |
| test_find_price | ✅ PASS | 32.36 K | 8.76 M |
| test_calculate_basket_price | ✅ PASS | 45.46 K | 13.39 M |
| test_is_healthy_good | ✅ PASS | 200.0 | 16.1 K |
| test_is_healthy_under | ✅ PASS | 801.0 | 188.14 K |
| test_is_healthy_over | ✅ PASS | 200.0 | 16.1 K |
| test_liquidation_value | ✅ PASS | 200.0 | 16.1 K |

**Result:** 9 tests | 9 passed | 0 failed

---

### 6. vault (6 tests)

| Test | Status | Memory | CPU |
|------|--------|--------|-----|
| test_sample_vault_creation | ✅ PASS | 16.66 K | 5.53 M |
| test_healthy_ratio_150_percent | ✅ PASS | 200.0 | 16.1 K |
| test_unhealthy_ratio_140_percent | ✅ PASS | 801.0 | 188.14 K |
| test_healthy_ratio_200_percent | ✅ PASS | 200.0 | 16.1 K |
| test_liquidation_value_calculation | ✅ PASS | 200.0 | 16.1 K |
| test_min_collateral | ✅ PASS | 200.0 | 16.1 K |

**Result:** 6 tests | 6 passed | 0 failed

---

## Overall Summary

| Module | Tests | Passed | Failed |
|--------|-------|--------|--------|
| basket_factory | 7 | 7 | 0 |
| basket_token_policy | 2 | 2 | 0 |
| mock_oracle | 7 | 7 | 0 |
| tests/integration | 34 | 34 | 0 |
| types | 9 | 9 | 0 |
| vault | 6 | 6 | 0 |
| **TOTAL** | **65** | **65** | **0** |

---

## ✅ Overall Status: ALL 65 TESTS PASSED!

---

## Test Coverage

### Functional Requirements Covered

| Requirement | Test Coverage |
|-------------|---------------|
| Create Basket | ✅ Covered (test_create_basket_*, test_basket_*) |
| Publish Oracle UTxO | ✅ Covered (test_oracle_*, test_default_prices_*) |
| Deposit and Mint | ✅ Covered (test_vault_deposit_*, test_mint_*) |
| Burn and Withdraw | ✅ Covered (test_burn_*, test_withdraw_*) |
| Liquidation | ✅ Covered (test_liquidation_*, test_position_becomes_undercollateralized) |
| State Transitions | ✅ Covered (test_vault_state_after_*) |
| Collateral Ratio | ✅ Covered (test_*_ratio_*, test_is_healthy_*) |
| Price Calculation | ✅ Covered (test_calculate_*_basket_price) |

### Edge Cases Tested

- ✅ Minimum collateral requirement
- ✅ Zero minted tokens withdrawal
- ✅ Zero collateral minting failure
- ✅ Price precision maintenance
- ✅ Invalid basket weights (over/under)
- ✅ Full mint/burn cycle
- ✅ Multiple deposit/mint cycles

---

## Contract Files

| File | Description | Status |
|------|-------------|--------|
| `validators/types.ak` | Shared type definitions and constants | ✅ Compiled |
| `validators/mock_oracle.ak` | Mock oracle for asset prices | ✅ Compiled |
| `validators/basket_factory.ak` | Basket registration and management | ✅ Compiled |
| `validators/vault.ak` | Collateral and minting logic | ✅ Compiled |
| `validators/basket_token_policy.ak` | Token minting policy | ✅ Compiled |
| `validators/tests/integration.ak` | Integration test suite | ✅ Compiled |

---

## Warnings (Non-Critical)

The following warnings were generated during compilation (do not affect functionality):

- Unused imports: `PolicyId`, `collateral_ratio`, `AssetId`, `dict`, `NoDatum`, `Mint`, etc.
- Unused variables: `owner`, `after_burn_collateral`

These warnings can be resolved by removing unused imports and variables but do not impact contract correctness.

---

## Next Steps

1. ✅ All contracts compiled successfully
2. ✅ All 65 tests passing
3. 📋 Deploy to Preview testnet for integration testing
4. 📋 Connect with offchain UI for end-to-end testing
5. 📋 Security audit before mainnet deployment

---

**Generated by:** EquiBaskets Test Runner  
**Aiken Compiler:** v1.1.19+e525483  
**Target:** Plutus V3

