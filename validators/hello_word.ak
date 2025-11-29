use aiken/collection/dict
use cardano/assets.{PolicyId}
use cardano/transaction.{OutputReference, Transaction}

validator hello_world {
  mint(redeemer token_name: ByteArray, policy_id: PolicyId, tx: Transaction) {
    trace @"hello_world.mint: Starting mint validation"
    trace @"Extracting minted tokens from transaction"
    expect [Pair(minted_token_name, qty)] =
      tx.mint |> assets.tokens(policy_id) |> dict.to_pairs

    trace @"Validating token name and quantity"

    when qty is {
      1 -> {
        trace @"Mint operation: Validating token creation"
        and {
          (minted_token_name == token_name)?,
          (token_name == "Hello, Adithya NG!")?,
        }
      }

      -1 -> {
        trace @"Burn operation: Allowing token burn"
        True
      }

      _ -> {
        trace @"Invalid quantity detected"
        fail @"Invalid Quantity"
      }
    }
  }

  spend(
    _datum: Option<Data>,
    redeemer: Int,
    _o_ref: OutputReference,
    _tx: Transaction,
  ) {
    trace @"hello_world.spend: Validating spend with redeemer"
    (redeemer == 42)?
  }

  else(_) {
    trace @"hello_world: Unsupported script purpose"
    fail
  }
}
