package com.example.weatherapplication.data

import kotlinx.serialization.encodeToString
import kotlinx.serialization.json.Json

class WeatherCacheRepository {

    private val json = Json {
        ignoreUnknownKeys = true
        prettyPrint = true
    }

    fun save(cache: WeatherCacheData) {
        val text = json.encodeToString(cache)
        CacheStorage.save(text)
    }

    fun load(): WeatherCacheData? {
        return try {
            val text = CacheStorage.load() ?: return null
            json.decodeFromString<WeatherCacheData>(text)
        } catch (e: Exception) {
            null
        }
    }
}