package com.example.weatherapplication.data

import java.io.File

actual object CacheStorage {

    private val file: File
        get() {
            val dir = File(System.getProperty("user.home"), ".weatherapp")
            if (!dir.exists()) dir.mkdirs()
            return File(dir, "weather_cache.json")
        }

    actual fun save(text: String) {
        file.writeText(text)
    }

    actual fun load(): String? {
        return if (file.exists()) file.readText() else null
    }
}