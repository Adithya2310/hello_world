# EquiBaskets — Technical Specification

## 1. Overview

EquiBaskets is a Cardano-based DeFi protocol that enables users to mint **tokenized baskets** representing weighted collections of assets. Users deposit ADA as collateral to mint basket tokens, with prices determined by a mock oracle.

---

## 2. Core Components

### 2.1 MockOracle

**Purpose**: Provides hardcoded asset prices and computes basket prices.

**Datum Structure**:
```
OracleDatum {
  prices: List<(AssetId, Int)>        -- Asset prices in 1e6 precision
  last_updated: POSIXTime             -- Timestamp of last update
  admin: VerificationKeyHash          -- Admin who can update prices
}
```

**Redeemer Actions**:
- `UpdatePrices`: Admin updates asset prices
- `ReadPrice`: Reference-only read (no spending)

**Validation Rules**:
- Only admin can update prices
- Prices must be positive integers
- Must preserve oracle UTxO continuity

---

### 2.2 BasketFactory

**Purpose**: Registers and stores basket definitions.

**Datum Structure**:
```
BasketDatum {
  basket_id: ByteArray                -- Unique basket identifier
  name: ByteArray                     -- Human-readable name
  assets: List<(AssetId, Int)>        -- Asset IDs and weights (sum = 10000 = 100%)
  creator: VerificationKeyHash        -- Basket creator
  created_at: POSIXTime               -- Creation timestamp
}
```

**Redeemer Actions**:
- `CreateBasket`: Register a new basket definition
- `UpdateBasket`: Modify basket weights (creator only)

**Validation Rules**:
- Basket ID must be unique
- Weights must sum to 10000 (100% in basis points)
- Only creator can update basket
- All asset IDs must be valid

---

### 2.3 Vault

**Purpose**: Manages collateral deposits, minting, burning, and liquidations.

**Datum Structure**:
```
VaultDatum {
  owner: VerificationKeyHash          -- Position owner
  basket_id: ByteArray                -- Associated basket
  collateral_ada: Int                 -- Deposited ADA (lovelace)
  minted_tokens: Int                  -- Number of basket tokens minted
  created_at: POSIXTime               -- Position creation time
}
```

**Redeemer Actions**:
- `Deposit`: Add ADA collateral
- `Withdraw`: Remove excess collateral
- `Mint`: Mint basket tokens against collateral
- `Burn`: Burn tokens to retrieve collateral
- `Liquidate`: Liquidate undercollateralized position

**Validation Rules**:
- **Collateral Ratio**: Minimum 150% (COLLATERAL_RATIO = 1500000)
- **Minting**: `collateral_value >= minted_value * 1.5`
- **Burning**: Returns proportional collateral
- **Liquidation**: Triggered when ratio < 150%
- **Liquidation Bonus**: 5% discount for liquidator

**Price Precision**: 1e6 (1 ADA = 1,000,000 lovelace)

---

### 2.4 BasketTokenPolicy

**Purpose**: Controls minting and burning of basket tokens.

**Redeemer**:
```
MintRedeemer {
  action: MintAction                  -- Mint or Burn
  vault_ref: OutputReference          -- Reference to Vault UTxO
}
```

**Validation Rules**:
- Minting only allowed through Vault contract
- Burning only allowed through Vault contract
- Must reference valid Vault UTxO in transaction
- Token name derived from basket_id

---

## 3. Data Flow

```
┌─────────────────────────────────────────────────────────────────┐
│                         EquiBaskets Flow                         │
├─────────────────────────────────────────────────────────────────┤
│                                                                  │
│  1. CREATE BASKET                                                │
│     Creator → BasketFactory.CreateBasket → BasketDatum stored   │
│                                                                  │
│  2. PUBLISH ORACLE                                               │
│     Admin → MockOracle → OracleDatum with prices                │
│                                                                  │
│  3. DEPOSIT & MINT                                               │
│     User deposits ADA → Vault.Deposit                            │
│     User mints tokens → Vault.Mint + BasketTokenPolicy.Mint     │
│     Oracle provides price reference                              │
│                                                                  │
│  4. BURN & WITHDRAW                                              │
│     User burns tokens → Vault.Burn + BasketTokenPolicy.Burn     │
│     User withdraws ADA → Vault.Withdraw                          │
│                                                                  │
│  5. LIQUIDATION                                                  │
│     Oracle price changes → Ratio < 150%                          │
│     Liquidator → Vault.Liquidate                                 │
│     Liquidator receives collateral at 5% discount               │
│                                                                  │
└─────────────────────────────────────────────────────────────────┘
```

---

## 4. Constants

| Constant | Value | Description |
|----------|-------|-------------|
| PRICE_PRECISION | 1_000_000 | Price scaling factor (1e6) |
| COLLATERAL_RATIO | 1_500_000 | 150% in 1e6 precision |
| LIQUIDATION_BONUS | 50_000 | 5% bonus (50000/1000000) |
| WEIGHT_PRECISION | 10_000 | Weights in basis points |
| MIN_COLLATERAL | 2_000_000 | Minimum 2 ADA |

---

## 5. Test Scenarios

### 5.1 Create Basket
- Register basket with 3 assets (e.g., BTC: 50%, ETH: 30%, SOL: 20%)
- Verify basket datum stored correctly
- Verify unique basket_id enforcement

### 5.2 Publish Oracle
- Create oracle UTxO with hardcoded prices
- BTC: $60,000, ETH: $3,000, SOL: $150
- Verify price computation for basket

### 5.3 Deposit and Mint
- User deposits 100 ADA
- User mints basket tokens
- Verify collateral ratio >= 150%
- Verify basket token minted to user

### 5.4 Burn and Withdraw
- User burns basket tokens
- Verify proportional ADA returned
- Verify vault datum updated

### 5.5 Liquidation
- Oracle price increases (basket value goes up)
- Position becomes undercollateralized
- Liquidator triggers liquidation
- Verify liquidator receives collateral at discount
- Verify position closed

---

## 6. Security Considerations

1. **Reentrancy**: Each validator checks transaction completeness
2. **Oracle Manipulation**: Admin-only oracle updates
3. **Dust Attacks**: Minimum collateral requirement
4. **Front-running**: POSIX time validity bounds
5. **Integer Overflow**: All math uses safe bounds

---

## 7. File Structure

```
validators/
├── types.ak                 -- Shared type definitions
├── mock_oracle.ak           -- Oracle validator
├── basket_factory.ak        -- Basket registration
├── vault.ak                 -- Collateral & minting logic
├── basket_token_policy.ak   -- Minting policy
└── tests/
    └── integration.ak       -- Full integration tests
```

