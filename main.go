package main

import (
	"encoding/json"
	"fmt"
	"log"
	"net/http"
	"sync"
	"time"
)

// VPNState — состояние подключения
type VPNState struct {
	Connected  bool      `json:"connected"`
	Server     string    `json:"server"`
	Endpoint   string    `json:"endpoint"`
	Upload     int64     `json:"upload"`
	Download   int64     `json:"download"`
	Since      time.Time `json:"since"`
}

var (
	state   VPNState
	stateMu sync.RWMutex
)

// Конфигурация российского сервера
const (
	serverName     = "🇷🇺 Россия (Москва)"
	serverEndpoint = "ru.olegvpn.com:51820"
	serverIP       = "185.147.80.5"
)

// Подключение к VPN
func connect() error {
	stateMu.Lock()
	defer stateMu.Unlock()
	
	// Здесь будет реальное подключение через WireGuard API
	// Пока эмулируем
	state.Connected = true
	state.Server = serverName
	state.Endpoint = serverEndpoint
	state.Since = time.Now()
	state.Upload = 0
	state.Download = 0
	
	return nil
}

// Отключение от VPN
func disconnect() {
	stateMu.Lock()
	defer stateMu.Unlock()
	
	state.Connected = false
	state.Server = ""
	// Здесь будет реальное отключение
}

// HTTP-хендлеры
func statusHandler(w http.ResponseWriter, r *http.Request) {
	stateMu.RLock()
	defer stateMu.RUnlock()
	w.Header().Set("Content-Type", "application/json")
	json.NewEncoder(w).Encode(state)
}

func connectHandler(w http.ResponseWriter, r *http.Request) {
	err := connect()
	w.Header().Set("Content-Type", "application/json")
	if err != nil {
		json.NewEncoder(w).Encode(map[string]interface{}{
			"success": false,
			"error":   err.Error(),
		})
		return
	}
	json.NewEncoder(w).Encode(map[string]interface{}{
		"success":  true,
		"server":   serverName,
		"endpoint": serverEndpoint,
		"ip":       serverIP,
	})
}

func disconnectHandler(w http.ResponseWriter, r *http.Request) {
	disconnect()
	w.Header().Set("Content-Type", "application/json")
	json.NewEncoder(w).Encode(map[string]bool{"success": true})
}

func main() {
	// Фронтенд
	http.Handle("/", http.FileServer(http.Dir("frontend")))

	// API
	http.HandleFunc("/api/status", statusHandler)
	http.HandleFunc("/api/connect", connectHandler)
	http.HandleFunc("/api/disconnect", disconnectHandler)

	fmt.Println("🛡️ OlegVPN запущен на http://localhost:8964")
	fmt.Println("🌍 Сервер:", serverName)
	fmt.Println("📡 Эндпоинт:", serverEndpoint)
	log.Fatal(http.ListenAndServe(":8964", nil))
}
