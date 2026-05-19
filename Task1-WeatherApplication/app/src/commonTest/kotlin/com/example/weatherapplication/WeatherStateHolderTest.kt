package com.example.weatherapplication


import kotlin.test.Test
import kotlin.test.assertTrue
import kotlin.test.assertEquals

class WeatherStateHolderTest {

    @Test
    fun testCitiesListInitializesCorrectly() {
        val stateHolder = WeatherStateHolder()
        assertEquals(2, stateHolder.cities.size)
        assertTrue(stateHolder.cities.contains("Минск"))
        assertTrue(stateHolder.cities.contains("Москва"))
    }

    @Test
    fun testAddCityAddsNewCityAndIgnoresDuplicates() {
        val stateHolder = WeatherStateHolder()

        stateHolder.addCity("Лондон")
        assertEquals(3, stateHolder.cities.size)
        assertTrue(stateHolder.cities.contains("Лондон"))

        stateHolder.addCity("Лондон")
        assertEquals(3, stateHolder.cities.size, "Количество городов не должно было измениться")
    }

    @Test
    fun testAddEmptyCityIsIgnored() {
        val stateHolder = WeatherStateHolder()
        val initialSize = stateHolder.cities.size

        stateHolder.addCity("   ")
        stateHolder.addCity("")

        assertEquals(initialSize, stateHolder.cities.size)
    }
}