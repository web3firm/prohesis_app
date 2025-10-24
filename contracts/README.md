# Prohesis Contracts

Smart contracts for the Prohesis prediction market platform built with Foundry.

## Contracts

- **USDCMock.sol**: Mock USDC ERC20 token with 6 decimals and a faucet for testing
- **Market.sol**: Binary prediction market contract with buy/resolve/redeem functionality
- **MarketFactory.sol**: Factory contract for deploying new market instances

## Setup

1. Install Foundry dependencies:
```bash
forge install OpenZeppelin/openzeppelin-contracts --no-commit
forge install foundry-rs/forge-std --no-commit
```

2. Build contracts:
```bash
forge build
```

3. Run tests:
```bash
forge test -vv
```

4. Deploy locally (requires Anvil running):
```bash
forge script script/Deploy.s.sol:Deploy --rpc-url http://localhost:8545 --broadcast
```

## Security Warning

⚠️ These contracts are for MVP demonstration purposes only. They have NOT been audited and should NOT be used in production without:
- Professional security audit
- Comprehensive test coverage
- Economic model validation
- Access control review
- Reentrancy protection verification

## Architecture

The market system uses a simplified binary outcome model:
- Users buy positions with USDC
- Admin resolves markets to outcome 0 or 1
- Winners can redeem their positions for USDC

This is a starting point. Production systems should include:
- AMM pricing (LMSR, CPMM, etc.)
- Decentralized oracle integration
- Multi-outcome markets
- Liquidity incentives
- Proper governance
