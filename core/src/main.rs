use axum::{
    routing::get,
    Router,
    Json,
};
use serde::Serialize;
use std::net::SocketAddr;
use tower_http::cors::CorsLayer;
use tracing_subscriber::{layer::SubscriberExt, util::SubscriberInitExt};

#[derive(Serialize)]
struct HealthResponse {
    status: String,
    service: String,
}

#[derive(Serialize)]
struct VersionResponse {
    version: String,
    service: String,
}

#[tokio::main]
async fn main() {
    // Initialize tracing
    tracing_subscriber::registry()
        .with(
            tracing_subscriber::EnvFilter::try_from_default_env()
                .unwrap_or_else(|_| "prohesis_core=debug,tower_http=debug".into()),
        )
        .with(tracing_subscriber::fmt::layer())
        .init();

    // Read environment variables
    let database_url = std::env::var("DATABASE_URL")
        .unwrap_or_else(|_| "postgres://prohesis:prohesis@localhost:5432/prohesis".to_string());
    let redis_url = std::env::var("REDIS_URL")
        .unwrap_or_else(|_| "redis://localhost:6379".to_string());
    let rpc_url = std::env::var("BASE_SEPOLIA_RPC_URL")
        .unwrap_or_else(|_| "https://sepolia.base.org".to_string());

    tracing::info!("Starting Prohesis Core Service");
    tracing::info!("Database URL: {}", database_url);
    tracing::info!("Redis URL: {}", redis_url);
    tracing::info!("RPC URL: {}", rpc_url);

    // Build router
    let app = Router::new()
        .route("/health", get(health))
        .route("/version", get(version))
        .layer(CorsLayer::permissive());

    // Run server
    let addr = SocketAddr::from(([0, 0, 0, 0], 7070));
    tracing::info!("Listening on {}", addr);

    let listener = tokio::net::TcpListener::bind(addr).await.unwrap();
    axum::serve(listener, app).await.unwrap();
}

async fn health() -> Json<HealthResponse> {
    Json(HealthResponse {
        status: "ok".to_string(),
        service: "prohesis-core".to_string(),
    })
}

async fn version() -> Json<VersionResponse> {
    Json(VersionResponse {
        version: env!("CARGO_PKG_VERSION").to_string(),
        service: "prohesis-core".to_string(),
    })
}

#[cfg(test)]
mod tests {
    use super::*;

    #[tokio::test]
    async fn test_health() {
        let response = health().await;
        assert_eq!(response.0.status, "ok");
        assert_eq!(response.0.service, "prohesis-core");
    }

    #[tokio::test]
    async fn test_version() {
        let response = version().await;
        assert_eq!(response.0.service, "prohesis-core");
    }
}
