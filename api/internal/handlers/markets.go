package handlers

import (
	"net/http"

	"github.com/gin-gonic/gin"
)

type Market struct {
	ID       string `json:"id"`
	Question string `json:"question"`
	EndTime  int64  `json:"endTime"`
	Volume   string `json:"volume"`
	Resolved bool   `json:"resolved"`
}

func GetMarkets(c *gin.Context) {
	// Demo data - in production this would query the database
	markets := []Market{
		{
			ID:       "1",
			Question: "Will ETH reach $5000 by end of 2025?",
			EndTime:  1735689600, // Dec 31, 2025
			Volume:   "10000",
			Resolved: false,
		},
		{
			ID:       "2",
			Question: "Will Bitcoin hit $100k in 2025?",
			EndTime:  1735689600,
			Volume:   "25000",
			Resolved: false,
		},
	}

	c.JSON(http.StatusOK, gin.H{
		"markets": markets,
		"count":   len(markets),
	})
}
