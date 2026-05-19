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
    private val scope = CoroutineScope(Dispatchers.Main)

    val cities = mutableStateListOf("Минск", "Москва")
    val weatherData = mutableStateOf<Map<String, CurrentWeather>>(emptyMap())
    val forecastData = mutableStateOf<List<ForecastItem>>(emptyList())
    val isLoading = mutableStateOf(false)
    val errorMessage = mutableStateOf<String?>(null)

    private val weatherCache = mutableMapOf<String, CurrentWeather>()
    private val forecastCache = mutableMapOf<String, List<ForecastItem>>()

    fun addCity(cityName: String) {
        if (cityName.isNotBlank() && !cities.contains(cityName)) {
            cities.add(cityName)
            loadWeatherForCity(cityName)
        }
    }

    fun loadWeatherForAllCities() {
        cities.forEach { loadWeatherForCity(it) }
    }

    private fun loadWeatherForCity(city: String) {
        scope.launch {
            isLoading.value = true
            try {
                val weather = api.getCurrentWeather(city)
                weatherCache[city] = weather
                weatherData.value = weatherData.value + (city to weather)
                errorMessage.value = null
            } catch (e: Exception) {
                val cached = weatherCache[city]
                if (cached != null) {
                    weatherData.value = weatherData.value + (city to cached)
                    errorMessage.value = "Нет сети. Показаны закэшированные данные."
                } else {
                    errorMessage.value = "Ошибка: ${e.message}"
                }
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
                val filtered = response.list.filterIndexed { index, _ -> index % 8 == 0 }.take(5)
                forecastCache[city] = filtered
                forecastData.value = filtered
                errorMessage.value = null
            } catch (e: Exception) {
                val cached = forecastCache[city]
                if (cached != null) {
                    forecastData.value = cached
                    errorMessage.value = "Нет сети. Показаны закэшированные данные."
                } else {
                    errorMessage.value = "Ошибка загрузки прогноза"
                }
            } finally {
                isLoading.value = false
            }
        }
    }
}