.PHONY: help dev down clean contracts-test contracts-deploy-local contracts-fmt api-test core-test web-dev

help:
	@echo "Prohesis Makefile"
	@echo ""
	@echo "Targets:"
	@echo "  dev                     - Start all services via docker-compose"
	@echo "  down                    - Stop all services"
	@echo "  clean                   - Clean build artifacts"
	@echo "  contracts-test          - Run Foundry tests"
	@echo "  contracts-deploy-local  - Deploy contracts to local Anvil"
	@echo "  contracts-fmt           - Format Solidity code"
	@echo "  api-test                - Run Go API tests"
	@echo "  core-test               - Run Rust core tests"
	@echo "  web-dev                 - Run Next.js dev server locally"

dev:
	docker compose up --build

down:
	docker compose down

clean:
	cd contracts && forge clean
	cd core && cargo clean
	cd api && go clean
	cd web && rm -rf .next node_modules

contracts-test:
	cd contracts && forge test -vv

contracts-deploy-local:
	cd contracts && forge script script/Deploy.s.sol:Deploy --rpc-url http://localhost:8545 --broadcast

contracts-fmt:
	cd contracts && forge fmt

api-test:
	cd api && go test ./...

core-test:
	cd core && cargo test

web-dev:
	cd web && npm run dev
