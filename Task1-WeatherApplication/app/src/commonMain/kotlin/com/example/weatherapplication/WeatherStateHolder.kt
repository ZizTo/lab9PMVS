package com.example.weatherapplication

import androidx.compose.runtime.mutableStateListOf
import androidx.compose.runtime.mutableStateOf
import com.example.weatherapplication.data.CurrentWeather
import com.example.weatherapplication.data.ForecastItem
import com.example.weatherapplication.data.WeatherApi
import com.example.weatherapplication.data.WeatherCacheData
import com.example.weatherapplication.data.WeatherCacheRepository
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch

class WeatherStateHolder {
    private val api = WeatherApi()
    private val cacheRepository = WeatherCacheRepository()
    private val scope = CoroutineScope(Dispatchers.Main)

    val cities = mutableStateListOf("Минск", "Москва")
    val weatherData = mutableStateOf<Map<String, CurrentWeather>>(emptyMap())
    val forecastData = mutableStateOf<List<ForecastItem>>(emptyList())
    val isLoading = mutableStateOf(false)
    val errorMessage = mutableStateOf<String?>(null)

    private val forecastCache = mutableMapOf<String, List<ForecastItem>>()

    fun restoreFromCache() {
        val cache = cacheRepository.load() ?: return

        cities.clear()
        cities.addAll(cache.cities.ifEmpty { listOf("Минск", "Москва") })

        weatherData.value = cache.weatherByCity
        forecastCache.clear()
        forecastCache.putAll(cache.forecastByCity)

        errorMessage.value = if (cache.weatherByCity.isNotEmpty()) {
            "Показаны сохранённые данные."
        } else {
            null
        }
    }

    private fun saveCache() {
        cacheRepository.save(
            WeatherCacheData(
                cities = cities.toList(),
                weatherByCity = weatherData.value,
                forecastByCity = forecastCache
            )
        )
    }

    fun addCity(cityName: String) {
        val city = cityName.trim()
        if (city.isNotEmpty() && !cities.contains(city)) {
            cities.add(city)
            saveCache()
            loadWeatherForCity(city)
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
                weatherData.value = weatherData.value + (city to weather)
                errorMessage.value = null
                saveCache()
            } catch (e: Exception) {
                val cached = weatherData.value[city]
                if (cached != null) {
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
                val filtered = response.list
                    .filterIndexed { index, _ -> index % 8 == 0 }
                    .take(5)

                forecastCache[city] = filtered
                forecastData.value = filtered
                errorMessage.value = null
                saveCache()
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