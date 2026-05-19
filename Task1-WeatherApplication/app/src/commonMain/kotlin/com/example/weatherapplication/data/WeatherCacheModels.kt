package com.example.weatherapplication.data

import kotlinx.serialization.Serializable

@Serializable
data class WeatherCacheData(
    val cities: List<String> = emptyList(),
    val weatherByCity: Map<String, CurrentWeather> = emptyMap(),
    val forecastByCity: Map<String, List<ForecastItem>> = emptyMap()
)