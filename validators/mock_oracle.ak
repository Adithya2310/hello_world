//// EquiBaskets - Mock Oracle Validator
////
//// This validator manages a UTxO containing hardcoded asset prices.
//// Only the admin can update prices, but anyone can reference the UTxO.

use aiken/collection/list
use cardano/address.{Script}
use cardano/transaction.{InlineDatum, Output, OutputReference, Transaction}
use types.{
  AssetId, OracleDatum, OracleRedeemer, ReadPrice, UpdatePrices, price_precision,
}

// ============================================================================
// VALIDATOR
// ============================================================================

validator mock_oracle {
  /// Spend validator: controls how oracle UTxO can be spent
  spend(
    datum: Option<OracleDatum>,
    redeemer: OracleRedeemer,
    own_ref: OutputReference,
    tx: Transaction,
  ) {
    // Extract datum
    expect Some(oracle_datum) = datum

    when redeemer is {
      UpdatePrices { new_prices } -> {
        // Only admin can update prices
        let admin_signed = list.has(tx.extra_signatories, oracle_datum.admin)
        // Validate new prices are all positive
        let prices_valid = validate_prices(new_prices)
        // Find continuing output (oracle must persist)
        let continuing_output = find_continuing_output(tx.outputs, own_ref, tx)
        // Verify continuing output has updated datum
        let output_valid =
          validate_continuing_output(
            continuing_output,
            oracle_datum.admin,
            new_prices,
          )
        and {
          admin_signed?,
          prices_valid?,
          output_valid?,
        }
      }

      ReadPrice ->
        // ReadPrice should not consume the UTxO - always fail
        // Use reference inputs instead
        fail @"Use reference inputs to read oracle prices"
    }
  }

  /// Fallback handler for other script purposes
  else(_) {
    fail @"Unsupported script purpose"
  }
}

// ============================================================================
// HELPER FUNCTIONS
// ============================================================================

/// Validate all prices are positive
fn validate_prices(prices: List<(AssetId, Int)>) -> Bool {
  when prices is {
    [] -> True
    [(_, price), ..rest] ->
      if price > 0 {
        validate_prices(rest)
      } else {
        False
      }
  }
}

/// Find the continuing output to this validator
fn find_continuing_output(
  outputs: List<Output>,
  own_ref: OutputReference,
  tx: Transaction,
) -> Output {
  // Get own script hash from the input being spent
  expect Some(own_input) =
    list.find(tx.inputs, fn(input) { input.output_reference == own_ref })
  expect Script(own_hash) = own_input.output.address.payment_credential

  // Find output going back to same script
  expect Some(output) =
    list.find(
      outputs,
      fn(output) {
        when output.address.payment_credential is {
          Script(hash) -> hash == own_hash
          _ -> False
        }
      },
    )
  output
}

/// Validate the continuing output has correct datum
fn validate_continuing_output(
  output: Output,
  expected_admin: ByteArray,
  expected_prices: List<(AssetId, Int)>,
) -> Bool {
  when output.datum is {
    InlineDatum(data) -> {
      expect new_datum: OracleDatum = data
      and {
        // Admin must remain unchanged
        (new_datum.admin == expected_admin)?,
        // Prices must match expected
        (new_datum.prices == expected_prices)?,
        // last_updated should be updated (we don't enforce specific value)
        True,
      }
    }
    _ -> fail @"Continuing output must have inline datum"
  }
}

// ============================================================================
// HARDCODED PRICES FOR TESTING
// ============================================================================

/// Get default hardcoded prices for testing
/// Prices in 1e6 precision (multiply USD by 1_000_000)
pub fn default_prices() -> List<(AssetId, Int)> {
  [
    // BTC: $60,000 -> 60_000_000_000
    ("BTC", 60_000 * price_precision),
    // ETH: $3,000 -> 3_000_000_000
    ("ETH", 3_000 * price_precision),
    // SOL: $150 -> 150_000_000
    ("SOL", 150 * price_precision),
    // ADA: $0.50 -> 500_000
    ("ADA", price_precision / 2),
    // LINK: $15 -> 15_000_000
    ("LINK", 15 * price_precision),
    // DOT: $7 -> 7_000_000
    ("DOT", 7 * price_precision),
  ]
}

/// Alternative prices for liquidation testing (prices increased)
pub fn liquidation_prices() -> List<(AssetId, Int)> {
  [
    // BTC: $90,000 (50% increase) -> 90_000_000_000
    ("BTC", 90_000 * price_precision),
    // ETH: $4,500 (50% increase) -> 4_500_000_000
    ("ETH", 4_500 * price_precision),
    // SOL: $225 (50% increase) -> 225_000_000
    ("SOL", 225 * price_precision),
    // ADA: $0.50 (unchanged) -> 500_000
    ("ADA", price_precision / 2),
    // LINK: $22.50 (50% increase) -> 22_500_000
    ("LINK", 22_500_000),
    // DOT: $10.50 (50% increase) -> 10_500_000
    ("DOT", 10_500_000),
  ]
}

// ============================================================================
// TESTS
// ============================================================================

test test_validate_prices_valid() {
  let prices = [("BTC", 60_000_000_000), ("ETH", 3_000_000_000)]
  validate_prices(prices)
}

test test_validate_prices_invalid_zero() {
  let prices = [("BTC", 60_000_000_000), ("ETH", 0)]
  !validate_prices(prices)
}

test test_validate_prices_invalid_negative() {
  let prices = [("BTC", -100), ("ETH", 3_000_000_000)]
  !validate_prices(prices)
}

test test_validate_prices_empty() {
  validate_prices([])
}

test test_default_prices_btc() {
  let prices = default_prices()
  expect Some((_, btc_price)) = list.find(prices, fn((id, _)) { id == "BTC" })
  btc_price == 60_000_000_000
}

test test_default_prices_ada() {
  let prices = default_prices()
  expect Some((_, ada_price)) = list.find(prices, fn((id, _)) { id == "ADA" })
  ada_price == 500_000
}

test test_liquidation_prices_higher() {
  let default = default_prices()
  let liquidation = liquidation_prices()
  expect Some((_, default_btc)) =
    list.find(default, fn((id, _)) { id == "BTC" })
  expect Some((_, liq_btc)) =
    list.find(liquidation, fn((id, _)) { id == "BTC" })
  liq_btc > default_btc
}
