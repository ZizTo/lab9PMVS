package com.example.weatherapplication.data


import kotlinx.serialization.SerialName
import kotlinx.serialization.Serializable

@Serializable
data class CurrentWeather(
    val name: String,
    val main: MainWeatherData,
    val weather: List<WeatherDescription>,
    val wind: Wind,
    val sys: Sys
)

@Serializable
data class MainWeatherData(
    val temp: Double,
    val humidity: Int,
    val pressure: Int
)

@Serializable
data class WeatherDescription(
    val description: String,
    val icon: String
)

@Serializable
data class Wind(
    val speed: Double
)

@Serializable
data class Sys(
    val country: String
)

@Serializable
data class ForecastResponse(
    val list: List<ForecastItem>
)

@Serializable
data class ForecastItem(
    @SerialName("dt_txt") val dateTime: String,
    val main: MainWeatherData,
    val weather: List<WeatherDescription>
)
