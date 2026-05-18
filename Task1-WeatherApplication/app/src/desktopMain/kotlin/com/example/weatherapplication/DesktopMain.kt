package com.example.weatherapplication

import androidx.compose.ui.window.Window
import androidx.compose.ui.window.application
import com.example.weatherapplication.App

fun main() = application {
    Window(
        onCloseRequest = ::exitApplication,
        title = "Ziz Weather Desktop"
    ) {
        App()
    }
}