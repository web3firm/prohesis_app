# Prohesis — Web3 Prediction Markets (Monorepo MVP)

Prohesis is a modular, full-stack prediction market system (similar to Polymarket) with:
- On-chain layer (Solidity + Foundry)
- Core backend (Rust)
- API gateway (Go)
- Frontend (Next.js 15 + TypeScript)
- Shared Types/Protos
- Docs

Defaults in this MVP:
- Chain: Base Sepolia (Chain ID 84532)
- Settlement token: Mock USDC for local; real USDC to be wired later
- Auth: Web3Auth (Modal) for wallet auth; SIWE stubs in API
- DB: Postgres 15; Cache: Redis 7
- Local orchestration: docker-compose
- License: MIT

Quickstart (local)
1. Copy .env.example to .env and fill:
   - NEXT_PUBLIC_WEB3AUTH_CLIENT_ID
   - BASE_SEPOLIA_RPC_URL (Alchemy/Infura/etc.)
   - POSTGRES/REDIS creds (defaults are fine for local)
2. Build & run:
   - make dev
   Or:
   - docker compose up --build
3. Frontend at http://localhost:3000
4. API at http://localhost:8080
5. Core at http://localhost:7070 (placeholder service)
6. Anvil chain at http://localhost:8545 (for local contract testing)
7. Foundry contracts:
   - make contracts-test
   - make contracts-deploy-local (demo deploy to Anvil)

Security note
This is an MVP scaffold. Do not use in production without a thorough security review, audits, rate-limiting, monitoring, and comprehensive tests.
