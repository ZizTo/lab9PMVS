package com.example.weatherapplication

import androidx.compose.runtime.mutableStateListOf
import androidx.compose.runtime.mutableStateOf
import com.example.weatherapplication.data.CurrentWeather
import com.example.weatherapplication.data.ForecastItem
import com.example.weatherapplication.data.WeatherApi
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch

class WeatherStateHolder {
    private val api = WeatherApi()
    // 1. ИСПОЛЬЗУЕМ MAIN ДИСПАТЧЕР
    private val scope = CoroutineScope(Dispatchers.Main)

    val cities = mutableStateListOf("Минск", "Москва")
    val weatherData = mutableStateOf<Map<String, CurrentWeather>>(emptyMap())
    val forecastData = mutableStateOf<List<ForecastItem>>(emptyList())
    val isLoading = mutableStateOf(false)
    val errorMessage = mutableStateOf<String?>(null)

    // Блок init удален

    fun addCity(cityName: String) {
        if (cityName.isNotBlank() && !cities.contains(cityName)) {
            cities.add(cityName)
            loadWeatherForCity(cityName)
        }
    }

    // 2. СДЕЛАЛИ ФУНКЦИЮ ПУБЛИЧНОЙ
    fun loadWeatherForAllCities() {
        cities.forEach { loadWeatherForCity(it) }
    }

    private fun loadWeatherForCity(city: String) {
        scope.launch {
            isLoading.value = true
            try {
                val weather = api.getCurrentWeather(city)
                weatherData.value = weatherData.value + (city to weather)
                errorMessage.value = null
            } catch (e: Exception) {
                errorMessage.value = "Ошибка: ${e.message}"
            } finally {
                isLoading.value = false
            }
        }
    }

    fun loadForecast(city: String) {
        scope.launch {
            isLoading.value = true
            try {
                val response = api.getForecast(city)
                forecastData.value = response.list.filterIndexed { index, _ -> index % 8 == 0 }.take(5)
                errorMessage.value = null
            } catch (e: Exception) {
                errorMessage.value = "Ошибка загрузки прогноза"
            } finally {
                isLoading.value = false
            }
        }
    }
}