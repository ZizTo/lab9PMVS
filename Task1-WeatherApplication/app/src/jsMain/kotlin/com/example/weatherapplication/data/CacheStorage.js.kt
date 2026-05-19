package com.example.weatherapplication.data

actual object CacheStorage {
    actual fun save(text: String) {

    }

    actual fun load(): String? {
        return null
    }
}