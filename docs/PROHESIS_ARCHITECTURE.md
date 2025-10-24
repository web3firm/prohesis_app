# Prohesis Architecture

## Overview

Prohesis is a full-stack Web3 prediction market platform inspired by Polymarket, built with a modern, modular architecture targeting Base Sepolia testnet.

## Architecture Layers

### 1. Smart Contracts (Foundry)

**Location**: `/contracts`

**Components**:
- **USDCMock.sol**: ERC20 token with 6 decimals for settlement (testnet/dev only)
- **Market.sol**: Binary prediction market with buy/resolve/redeem logic
- **MarketFactory.sol**: Factory pattern for creating market instances

**Key Features**:
- Simplified 1:1 pricing model (MVP)
- Admin-controlled resolution
- Position tracking per user per outcome

**Next Steps**:
- Implement AMM pricing (LMSR or constant product)
- Add Chainlink oracle integration for automated resolution
- Multi-outcome markets support
- Liquidity mining incentives
- Comprehensive test coverage
- Professional security audit

### 2. Core Service (Rust + Axum)

**Location**: `/core`

**Purpose**: Backend indexer and business logic layer

**Current State**: Basic HTTP server with health/version endpoints

**Planned Features**:
- Event indexing from smart contracts
- Market state management
- Order book aggregation
- User position tracking
- WebSocket support for real-time updates
- Database integration (Postgres)
- Cache layer (Redis)

### 3. API Gateway (Go + Gin)

**Location**: `/api`

**Purpose**: RESTful API for client consumption

**Current Endpoints**:
- `GET /health`: Health check
- `GET /markets`: List markets (demo data)

**Planned Features**:
- Full CRUD for markets
- User authentication via SIWE
- Position management
- Trading endpoints
- Rate limiting
- API key management
- GraphQL support

### 4. Frontend (Next.js 15 + Web3Auth)

**Location**: `/web`

**Features**:
- Server-side rendering with Next.js 15
- Web3Auth Modal for wallet authentication
- Tailwind CSS styling
- TypeScript strict mode

**Current State**: Login/logout demo with Web3Auth

**Planned Features**:
- Market browsing and filtering
- Position management UI
- Trading interface with price charts
- Portfolio dashboard
- Real-time price updates
- Mobile responsive design
- Social features (comments, shares)

### 5. Shared Types

**Location**: `/shared`

**Contents**:
- Protobuf schemas for API contracts
- TypeScript type definitions
- Shared constants

**Purpose**: Ensure type safety across services

## Infrastructure

### Local Development (Docker Compose)

**Services**:
- **postgres:15**: Primary database
- **redis:7**: Caching and pub/sub
- **anvil**: Local Ethereum testnet
- **core**: Rust backend service (port 7070)
- **api**: Go API gateway (port 8080)
- **web**: Next.js frontend (port 3000)

### CI/CD (GitHub Actions)

**Workflow**: `.github/workflows/build.yml`

**Jobs**:
- Build and test web (Node 20)
- Build and test api (Go 1.22)
- Build and test core (Rust stable)

**Future**:
- Automated contract deployment
- Security scanning (Slither, MythX)
- E2E testing
- Deployment to staging/production

## Data Flow

1. **Market Creation**:
   - Admin creates market via MarketFactory contract
   - Core service indexes MarketCreated event
   - API serves market data to frontend

2. **Trading**:
   - User connects wallet via Web3Auth
   - Frontend calls Market.buy() with signed transaction
   - Core indexes Bought event and updates state
   - API reflects new positions and volume

3. **Resolution**:
   - Admin resolves market via Market.resolve()
   - Core indexes Resolved event
   - Users can redeem winning positions
   - Frontend shows payout UI

## Security Considerations

### Smart Contracts
- ⚠️ Requires professional audit before mainnet
- Implement access controls (OpenZeppelin AccessControl)
- Add reentrancy guards
- Consider upgradeable proxy pattern
- Multi-sig for admin operations

### Backend
- Input validation on all endpoints
- Rate limiting to prevent DoS
- SQL injection protection (parameterized queries)
- Secrets management (HashiCorp Vault)
- CORS configuration

### Frontend
- XSS protection
- Content Security Policy
- Secure Web3Auth configuration
- Private key handling best practices

## Next Steps

### Short Term (1-2 months)
- [ ] Implement event indexing in core
- [ ] Add database schema and migrations
- [ ] Complete API CRUD operations
- [ ] Build trading UI
- [ ] Add comprehensive tests

### Medium Term (3-6 months)
- [ ] Deploy to Base Sepolia testnet
- [ ] Implement AMM pricing
- [ ] Add oracle integration
- [ ] Build analytics dashboard
- [ ] Community testing

### Long Term (6+ months)
- [ ] Security audit
- [ ] Mainnet deployment on Base
- [ ] Mobile app (React Native)
- [ ] Advanced market types
- [ ] Governance token
- [ ] Liquidity mining program

## Resources

- **Base Sepolia**: https://docs.base.org/
- **Web3Auth**: https://web3auth.io/docs/
- **Foundry**: https://book.getfoundry.sh/
- **Axum**: https://docs.rs/axum/latest/axum/
- **Gin**: https://gin-gonic.com/docs/
- **Next.js**: https://nextjs.org/docs

## Contributing

This is an MVP scaffold. Contributions welcome! See main README for setup instructions.

## License

MIT License - see LICENSE file for details.
