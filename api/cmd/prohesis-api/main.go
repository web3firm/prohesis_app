package main

import (
	"log"
	"os"

	"github.com/gin-contrib/cors"
	"github.com/gin-gonic/gin"
	"github.com/web3firm/prohesis-api/internal/handlers"
)

func main() {
	// Read environment
	databaseURL := getEnv("DATABASE_URL", "postgres://prohesis:prohesis@localhost:5432/prohesis")
	redisURL := getEnv("REDIS_URL", "redis://localhost:6379")
	coreURL := getEnv("CORE_URL", "http://localhost:7070")

	log.Printf("Starting Prohesis API Gateway")
	log.Printf("Database URL: %s", databaseURL)
	log.Printf("Redis URL: %s", redisURL)
	log.Printf("Core URL: %s", coreURL)

	// Setup Gin router
	r := gin.Default()

	// CORS
	r.Use(cors.New(cors.Config{
		AllowOrigins:     []string{"*"},
		AllowMethods:     []string{"GET", "POST", "PUT", "DELETE", "OPTIONS"},
		AllowHeaders:     []string{"Origin", "Content-Type", "Authorization"},
		ExposeHeaders:    []string{"Content-Length"},
		AllowCredentials: true,
	}))

	// Routes
	r.GET("/health", handlers.Health)
	r.GET("/markets", handlers.GetMarkets)

	// Start server
	port := getEnv("API_PORT", "8080")
	log.Printf("Listening on :%s", port)
	if err := r.Run(":" + port); err != nil {
		log.Fatalf("Failed to start server: %v", err)
	}
}

func getEnv(key, fallback string) string {
	if value := os.Getenv(key); value != "" {
		return value
	}
	return fallback
}
