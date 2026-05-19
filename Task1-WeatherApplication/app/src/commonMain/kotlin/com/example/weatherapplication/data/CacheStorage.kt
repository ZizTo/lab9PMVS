package com.example.weatherapplication.data

expect object CacheStorage {
    fun save(text: String)
    fun load(): String?
}