package com.example.weatherapplication.data

import io.ktor.client.*
import io.ktor.client.call.*
import io.ktor.client.plugins.contentnegotiation.*
import io.ktor.client.request.*
import io.ktor.serialization.kotlinx.json.*
import kotlinx.serialization.json.Json

class WeatherApi {
    val httpClient = HttpClient {
        install(ContentNegotiation) {
            json(Json {
                ignoreUnknownKeys = true
                coerceInputValues = true
            })
        }
    }

    private val apiKey = "1bafea42aff0cc6f6528b480f29ed028" // Твой ключ из 5-й лабы
    private val baseUrl = "https://api.openweathermap.org/data/2.5"

    suspend fun getCurrentWeather(city: String): CurrentWeather {
        return httpClient.get("$baseUrl/weather") {
            parameter("q", city)
            parameter("appid", apiKey)
            parameter("units", "metric")
            parameter("lang", "ru")
        }.body()
    }

    suspend fun getForecast(city: String): ForecastResponse {
        return httpClient.get("$baseUrl/forecast") {
            parameter("q", city)
            parameter("appid", apiKey)
            parameter("units", "metric")
            parameter("lang", "ru")
        }.body()
    }
}