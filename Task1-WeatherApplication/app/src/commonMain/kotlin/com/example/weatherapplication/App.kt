package com.example.weatherapplication

import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.items
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.Add
import androidx.compose.material.icons.filled.ArrowBack
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.RectangleShape
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import com.example.weatherapplication.data.CurrentWeather

enum class Screen { Cities, Details, Forecast }

@Composable
fun App(platform: Platform) {
    MaterialTheme {
        val stateHolder = remember { WeatherStateHolder() }

        LaunchedEffect(Unit) {
            stateHolder.loadWeatherForAllCities()
        }

        var currentScreen by remember { mutableStateOf(Screen.Cities) }
        var selectedCity by remember { mutableStateOf("") }

        when (currentScreen) {
            Screen.Cities -> CitiesScreen(
                platform.isDesktop,
                stateHolder = stateHolder,
                onNavigateToDetails = { city ->
                    selectedCity = city
                    currentScreen = Screen.Details
                }
            )
            Screen.Details -> DetailsScreen(
                stateHolder = stateHolder,
                city = selectedCity,
                onBack = { currentScreen = Screen.Cities },
                onNavigateToForecast = { city ->
                    selectedCity = city
                    stateHolder.loadForecast(city)
                    currentScreen = Screen.Forecast
                }
            )
            Screen.Forecast -> ForecastScreen(
                stateHolder = stateHolder,
                city = selectedCity,
                onBack = { currentScreen = Screen.Details }
            )
        }
    }
}

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun CitiesScreen(isDesktop: Boolean, stateHolder: WeatherStateHolder, onNavigateToDetails: (String) -> Unit) {
    var showDialog by remember { mutableStateOf(false) }
    var newCity by remember { mutableStateOf("") }

    Scaffold(
        topBar = {
            TopAppBar(
                title = { Text("Погода") },
                actions = {
                    IconButton(onClick = { showDialog = true }) {
                        Icon(Icons.Default.Add, "Добавить")
                    }
                }
            )
        }
    ) { padding ->
        Column(Modifier.padding(padding)) {
            if (stateHolder.isLoading.value) {
                CircularProgressIndicator(Modifier.align(Alignment.CenterHorizontally).padding(16.dp))
            }

            stateHolder.errorMessage.value?.let {
                Text(it, color = MaterialTheme.colorScheme.error, modifier = Modifier.padding(16.dp))
            }

            LazyColumn {
                items(stateHolder.cities) { city ->
                    val weather = stateHolder.weatherData.value[city]
                    CityItem(isDesktop, city, weather) {
                        onNavigateToDetails(city)
                    }
                }
            }
        }

        if (showDialog) {
            AlertDialog(
                onDismissRequest = { showDialog = false },
                title = { Text("Добавить город") },
                text = {
                    OutlinedTextField(
                        value = newCity,
                        onValueChange = { newCity = it },
                        label = { Text("Название") }
                    )
                },
                confirmButton = {
                    Button(onClick = {
                        stateHolder.addCity(newCity)
                        newCity = ""
                        showDialog = false
                    }) { Text("Добавить") }
                }
            )
        }
    }
}

@Composable
fun CityItem(isDesktop: Boolean, city: String, weather: CurrentWeather?, onClick: () -> Unit) {
    val cardShape = if (isDesktop) RectangleShape else RoundedCornerShape(16.dp)

    Card(
        shape = cardShape,
        modifier = Modifier
            .fillMaxWidth()
            .padding(8.dp)
            .clickable(onClick = onClick)
    ) {
        Row(
            modifier = Modifier.padding(16.dp).fillMaxWidth(),
            horizontalArrangement = Arrangement.SpaceBetween
        ) {
            Text(city, fontSize = 20.sp)
            Text(weather?.let { "${it.main.temp.toInt()}°C" } ?: "...", fontSize = 20.sp)
        }
    }
}

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun DetailsScreen(stateHolder: WeatherStateHolder, city: String, onBack: () -> Unit, onNavigateToForecast: (String) -> Unit) {
    val weather = stateHolder.weatherData.value[city]

    Scaffold(
        topBar = {
            TopAppBar(
                title = { Text(city) },
                navigationIcon = {
                    IconButton(onClick = onBack) {
                        Icon(Icons.Default.ArrowBack, "Назад")
                    }
                }
            )
        }
    ) { padding ->
        Column(Modifier.padding(padding).padding(16.dp)) {
            weather?.let {
                Text("Температура: ${it.main.temp.toInt()}°C", fontSize = 24.sp)
                Text("Ощущается: ${it.weather.firstOrNull()?.description ?: ""}")
                Text("Влажность: ${it.main.humidity}%")
                Text("Ветер: ${it.wind.speed} м/с")
                Text("Давление: ${it.main.pressure} мм рт. ст.")
                Spacer(Modifier.height(16.dp))
                Button(onClick = { onNavigateToForecast(city) }) {
                    Text("Прогноз на 5 дней")
                }
            } ?: Text("Загрузка...")
        }
    }
}

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun ForecastScreen(stateHolder: WeatherStateHolder, city: String, onBack: () -> Unit) {
    Scaffold(
        topBar = {
            TopAppBar(
                title = { Text("Прогноз: $city") },
                navigationIcon = {
                    IconButton(onClick = onBack) {
                        Icon(Icons.Default.ArrowBack, "Назад")
                    }
                }
            )
        }
    ) { padding ->
        Column(Modifier.padding(padding)) {
            if (stateHolder.isLoading.value) {
                CircularProgressIndicator(Modifier.align(Alignment.CenterHorizontally).padding(16.dp))
            }
            LazyColumn {
                items(stateHolder.forecastData.value) { item ->
                    Card(Modifier.fillMaxWidth().padding(8.dp)) {
                        Column(Modifier.padding(16.dp)) {
                            Text(item.dateTime.substringBefore(" "), fontSize = 18.sp)
                            Text("${item.main.temp.toInt()}°C, ${item.weather.firstOrNull()?.description ?: ""}")
                        }
                    }
                }
            }
        }
    }
}