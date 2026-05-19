package com.example.weatherapplication

import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.ExperimentalCoroutinesApi
import kotlinx.coroutines.test.StandardTestDispatcher
import kotlinx.coroutines.test.resetMain
import kotlinx.coroutines.test.setMain
import kotlin.test.AfterTest
import kotlin.test.BeforeTest
import kotlin.test.Test
import kotlin.test.assertEquals
import kotlin.test.assertTrue

@OptIn(ExperimentalCoroutinesApi::class)
class WeatherStateHolderTest {

    private val testDispatcher = StandardTestDispatcher()

    @BeforeTest
    fun setUp() {
        Dispatchers.setMain(testDispatcher)
    }

    @AfterTest
    fun tearDown() {
        Dispatchers.resetMain()
    }

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
        assertEquals(3, stateHolder.cities.size)
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