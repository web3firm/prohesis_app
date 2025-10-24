# Prohesis API Gateway

Go-based API gateway built with Gin framework.

## Features

- RESTful API
- CORS enabled
- Health check endpoint
- Markets listing endpoint (demo data)

## Development

```bash
go run ./cmd/prohesis-api
```

## Testing

```bash
go test ./...
```

## Environment Variables

- `DATABASE_URL`: PostgreSQL connection string
- `REDIS_URL`: Redis connection string
- `CORE_URL`: Core service URL
- `API_PORT`: Port to listen on (default: 8080)

## Endpoints

- `GET /health`: Health check
- `GET /markets`: List available markets

## Docker

```bash
docker build -t prohesis-api .
docker run -p 8080:8080 prohesis-api
```
