# Prohesis Core

Rust backend service built with Axum and Tokio.

## Features

- Health check endpoint
- Version endpoint
- CORS enabled
- Environment-based configuration

## Development

```bash
cargo run
```

## Testing

```bash
cargo test
```

## Environment Variables

- `DATABASE_URL`: PostgreSQL connection string
- `REDIS_URL`: Redis connection string
- `BASE_SEPOLIA_RPC_URL`: Base Sepolia RPC endpoint

## Endpoints

- `GET /health`: Health check
- `GET /version`: Service version

## Docker

```bash
docker build -t prohesis-core .
docker run -p 7070:7070 prohesis-core
```
